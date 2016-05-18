% Suppress errors related to Scanimage tif files
warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning');

% GUI interface for selection of 2 tif files. 

[movingFileName PathName] = uigetfile('*.tif;*.tiff','Select the current moving image');

if ~isequal(movingFileName,0)
      moving_image = tiffclassreader(fullfile(PathName,movingFileName));
      moving_image = highpassfilt3(moving_image); 
else
    error('No moving file.');
end

[fixedFileName PathName] = uigetfile('*.tif;*.tiff','Select the reference fixed image', [PathName movingFileName] );

reuse_fixed=false;
if ~isequal(fixedFileName,0)
      fixed_image = tiffclassreader(fullfile(PathName,fixedFileName));
      fixed_image = highpassfilt3(fixed_image);
else
    if exist('fixed_image','var')
        disp('No fixed image selected, proceeding with previous fixed image.')
        reuse_fixed=true;
    else
        error('No target fixed image file.');
    end
end

%clear PathName

% Image smoothing for noisy images
% moving_image = imgaussfilt(moving_image,2);
% fixed_image = imgaussfilt(fixed_image,2);