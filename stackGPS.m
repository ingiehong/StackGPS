function [ registered_image, moving_image, fixed_image, transformation, fit, movingFileName, fixedFileName, t ] = stackGPS( moving_image, fixed_image, moving_res, fixed_res, channels, use_highpassfilt, bVerbose)
% Load two image files, (2D->2D, pseudo2D->3D, or 3D to 3D) and align them using rigid
% transformation. Output X,Y,Z,rotational offsets to aid physical adjustment of specimen to same position.
%
%   moving_image and fixed_image are image-containing matrices
%   moving_res and fixed_res are vectors with the physical voxel size
%       By default, RES is 1.0 in each dimension. ex) [389/512 389/512 1] 
%   channels is the specific channel set to be used for registration 
%       ex) [1 2] for two channels, default all (0)
%   use_highpassfilt is a boolean flag (true/false) for use of
%       highpassfiltering during registration. 
%
% Ingie Hong, Johns Hopkins Medical Institute, 2016


%selectTIFs % Select two tifs, first a moving image, and a reference fixed image

% Suppress errors related to Scanimage tif files
warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning');

if nargin < 1 && nargout ==0
    stackGPS_GUI; % If no arguments are supplied, load StackGPS GUI and stop.
    return
end

if nargin < 5 || isempty(channels) 
    channels=1; % Default to channel 1
end

if nargin < 6 || isempty(use_highpassfilt) 
    use_highpassfilt=false; % Default to not using highpassfiltering
end

if nargin < 7 || isempty(bVerbose) 
    bVerbose=false;
end

PathName='';
movingFileName='';
fixedFileName='';

% GUI interface for selection of 2 tif files. 
if nargin < 1 || isempty(moving_image) 
    [movingFileName PathName] = uigetfile('*.tif;*.tiff','Select the current moving image');

    if ~isequal(movingFileName,0)
          moving_image = tiffclassreader(fullfile(PathName,movingFileName),channels);
          if use_highpassfilt
            disp('Highpass filtering to allow registration based on local features...')
            moving_image_orig=moving_image;
            moving_image = highpassfilt3(moving_image,50);  % highpass filtering to allow registration based on local features
          end
    else
        error('No moving file.');
    end
    
else
    if channels ~= 0
        moving_image = moving_image(:,:,:,channels);
    end
    disp('Proceeding with provided moving image.')
end

if nargin < 2 || isempty(fixed_image)
    
    [fixedFileName PathName] = uigetfile('*.tif;*.tiff','Select the reference fixed image', [PathName movingFileName] );

    if ~isequal(fixedFileName,0)
        fixed_image = tiffclassreader(fullfile(PathName,fixedFileName),channels);
        if use_highpassfilt
            disp('Highpass filtering to allow registration based on local features...')
            fixed_image_orig=fixed_image;
            fixed_image = highpassfilt3(fixed_image,50);   % highpass filtering to allow registration based on local features
        end
    else
        error('No target fixed image file.');
    end
    
else
    if channels ~= 0
        fixed_image = fixed_image(:,:,:,channels);
    end
    disp('Proceeding with provided fixed image. ')
end
%disp('Done loading images')

% check for RESOLUTION info, if absent set as default
if nargin < 3 || isempty(moving_res) 
    moving_res=ones(1,size(moving_image,5)+2 );
    disp('No resolution information for moving image provided, using 1x1x1 pixels.')
end
if nargin < 4 || isempty(fixed_res) 
    fixed_res=ones(1,size(fixed_image,5)+2);
    disp('No resolution information for fixed image provided, using 1x1x1 pixels.')
end

%if ndims(fixed_image)==3 && ndims(moving_image)==3
if ndims(moving_image)>2
    [registered_image, transformation, fit, t] = findposition3D( moving_image, fixed_image, moving_res, fixed_res, bVerbose); % Register 3D->3D to find best matching transformation and visualize
    if use_highpassfilt
        % Transform original image to get un-filtered&transformed image.
    end
    visualize_tranformation(registered_image, fixed_res);
    verbalize_tranformation(transformation);
else 
    [registered_image, transformation, fit] = findposition2D( moving_image, fixed_image, bVerbose); % Find best matching slice and transformation and visualize
    t=[];
end
