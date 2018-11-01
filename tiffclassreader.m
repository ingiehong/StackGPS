function imageStack = tiffclassreader(fname, channels)
% Simple TIF reader for Scanimage or Prarie 2P tif/tiff images/stacks
% For other microscopy image formats, use Open Microscopy BIO-FORMATS toolbox
%
% fname : full filename of image. ex) '2p_image_file.tif';
% channels: if set as 0 then all channels are returned, otherwise channels
%           defined are returned ex) [1 2]
%
% Ingie Hong, Johns Hopkins Medical Institute, 2016

[filepath,name,ext]  = fileparts(fname);
ext = lower(strrep(ext, '.', ''));

switch ext
    case 'tif'

        if isempty( regexp(fname,'ZSeries') ) || isempty( regexp(fname,'_Ch') )    % Check if Prarie-style zstack file series...

            % for generic multi-stack tiffs
            info = imfinfo(fname);
            numberOfImages = length(info);
            %[info(1).Width info(1).Height numberOfImages]

            if ~isempty(strfind(info(1).ImageDescription, 'state'))
                disp('Using Scanimage 3.X tif reader...')
                [header,imageStack] = scim_openTif(fname); % For Scanimage 3.X files, open with scim_openTif

                if ndims(imageStack)>3 
                    if nargin<2
                        disp('Multicolor (or timelapse) image detected. Using first color only.')
                        imageStack=squeeze(imageStack(:,:,1,:)); 
                    else
                        if channels == 0; channels = 1:size(imageStack,3);end; % Load all channels
                        imageStack=permute(imageStack(:,:,channels,:),[1 2 4 5 3]); % permute to fit scimat specification
                    end
                end
            elseif isfield(info(1), 'Software') && ~isempty(strfind(info(1).Software, 'SI.VERSION_MAJOR'))
                disp('Using Scanimage 4/5/2016/2017/2018 tif reader...')
                [header,imageStack,imgInfo] = scanimage.util.opentif(fname); % For Scanimage 2017 files, open with scanimage.util.opentif

                if ndims(imageStack)>3 
                    if nargin<2
                        disp('Multicolor (or timelapse) image detected. Using first color only.')
                        imageStack=squeeze(imageStack(:,:,1,:)); 
                    else
                        if channels == 0; channels = 1:size(imageStack,3);end; % Load all channels
                        imageStack=permute(imageStack(:,:,channels,:),[1 2 4 5 3]); % permute to fit scimat specification
                    end
                end        

            else
                % For other TIFs, read with MATLAB TIFFclassreader
                disp('Using generic tif reader...')
                imageStack = zeros(info(1).Width,info(1).Height,numberOfImages, 'uint16');
                for k = 1:numberOfImages
                    currentImage = imread(fname, k, 'Info', info);
                    % Widefield RGB images are converted into grayscale
                    if size(currentImage,3)>1 
                        currentImage=rgb2gray(currentImage);
                    end
                    % For some reason, widefield images are transposed
        %             if info(1).Width == size(currentImage,2)
        %                 currentImage=currentImage';
        %             end

                    imageStack(:,:,k) = currentImage;
                end 
            end
        else
            % for Prarie z-series
            disp('Detected Prarie tif series...')

            if isempty( regexp(fname,'_Ch2_') )
                error('File selected is not the typical Prarie Ch2 tif file. More coding required.')
            end
            [pathstr,name,ext] = fileparts(fname);
            filelist=ls([pathstr '\ZSeries*_Ch2_*']);

            imageStack=[];
            numberOfImages = size(filelist,1);
            for k = 1:numberOfImages
                currentImage = imread([pathstr '\' filelist(k,:)]);
                imageStack(:,:,k) = currentImage;
            end 

        end

        
        
    otherwise 
        % Use BIO-FORMATS Matlab toolbox to open other image formats 
        % Download at https://www.openmicroscopy.org/bio-formats/
        data = bfopen(fname);
        
        % Get OME metadata for resolution recommendation
        omeMeta = data{1, 4};
        stackSizeX = omeMeta.getPixelsSizeX(0).getValue(); % image width, pixels
        stackSizeY = omeMeta.getPixelsSizeY(0).getValue(); % image height, pixels
        stackSizeZ = omeMeta.getPixelsSizeZ(0).getValue(); % number of Z slices

        voxelSizeXdefaultValue = omeMeta.getPixelsPhysicalSizeX(0).value();           % returns value in default unit
        voxelSizeXdefaultUnit = omeMeta.getPixelsPhysicalSizeX(0).unit().getSymbol(); % returns the default unit type
        voxelSizeX = omeMeta.getPixelsPhysicalSizeX(0).value(ome.units.UNITS.MICROMETER); % in µm
        voxelSizeXdouble = voxelSizeX.doubleValue();                                  % The numeric value represented by this object after conversion to type double
        voxelSizeY = omeMeta.getPixelsPhysicalSizeY(0).value(ome.units.UNITS.MICROMETER); % in µm
        voxelSizeYdouble = voxelSizeY.doubleValue();                                  % The numeric value represented by this object after conversion to type double
        try
            voxelSizeZ = omeMeta.getPixelsPhysicalSizeZ(0).value(ome.units.UNITS.MICROMETER); % in µm
            voxelSizeZdouble = voxelSizeZ.doubleValue();                                  % The numeric value represented by this object after conversion to type double
        catch
            voxelSizeZdouble = 1;
        end
        
        disp(['The metadata suggests a pixel size of ' num2str([ voxelSizeXdouble voxelSizeYdouble voxelSizeZdouble]) ' . Please update the settings if not correct.' ])
        
        % Organize image data into imagestack
        channelcount = omeMeta.getChannelCount(0);
        imagenumber = 1;
        imageStack=zeros( stackSizeX, stackSizeY, channelcount, stackSizeZ ,omeMeta.getPixelsType(0).char);
        
        for j=1:stackSizeZ
            for k = 1:channelcount
                imageStack(:,:,k,j) = data{1,1}{imagenumber,1};
                imagenumber=imagenumber+1;
            end
        end
        if nargin<2
            disp('Multicolor (or timelapse) image detected. Using first color only.')
            imageStack=squeeze(imageStack(:,:,1,:)); 
        else
            if channels == 0; channels = 1:size(imageStack,3);end; % Load all channels
            imageStack=permute(imageStack(:,:,channels,:),[1 2 4 5 3]); % permute to fit scimat specification
        end
end
