function imageStack = tiffclassreader(fname)
% Simple TIF reader for Scanimage or Prarie 2P tif/tiff images/stacks

%fname = 'RR.tif';
%regexp(fname,'ZSeries')

if isempty( regexp(fname,'ZSeries') ) || isempty( regexp(fname,'_Ch') )

    
    
    % for generic multi-stack tiffs
    info = imfinfo(fname);
    numberOfImages = length(info);
    %[info(1).Width info(1).Height numberOfImages]
    
    if ~isempty(strfind(info(1).ImageDescription, 'state'))
        disp('Using Scanimage 3.X tif reader...')
        [header,imageStack] = scim_openTif(fname); % For Scanimage 3.X files, open with scim_openTif
        
        if ndims(imageStack)>3 
            disp('Multicolor (or timelapse) image detected. Using first color only.')
            imageStack=squeeze(imageStack(:,:,1,:));
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
            if info(1).Width == size(currentImage,2)
                currentImage=currentImage';
            end

            imageStack(:,:,k) = currentImage';
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
