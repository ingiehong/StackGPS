function imageStack = tiffclassreader(fname)
% Simple TIF reader for Scanimage or Prarie 2P tif/tiff images/stacks

%fname = 'RR.tif';
%regexp(fname,'ZSeries')

if isempty( regexp(fname,'ZSeries') ) || isempty( regexp(fname,'_Ch') )

    disp('Using generic tif reader...')
    
    % for generic multi-stack tiffs
    info = imfinfo(fname);
    numberOfImages = length(info);
    %[info(1).Width info(1).Height numberOfImages]
    imageStack = zeros(info(1).Width,info(1).Height,numberOfImages, 'uint16');
    
    for k = 1:numberOfImages
        currentImage = imread(fname, k, 'Info', info);
        imageStack(:,:,k) = currentImage;
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
    numberOfImages = length(filelist);
    for k = 1:numberOfImages
        currentImage = imread([pathstr '\' filelist(k,:)]);
        imageStack(:,:,k) = currentImage;
    end 
    
end
