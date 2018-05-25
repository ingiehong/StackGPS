function [registered_image, moving_image, fixed_image, transformation, fit, movingFileName, fixedFileName ] = stackGPS_batch( moving_image, fixed_image, moving_res, fixed_res, channels, use_highpassfilt)
% Load multiple image files, (3D to 3D) and align them using rigid
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

% Suppress errors related to Scanimage tif files
warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning');

if nargin < 5 || isempty(channels) 
    channels=0; % Default to All channels
end

if nargin < 6 || isempty(use_highpassfilt)
    use_highpassfilt=false; % Default to not using highpassfiltering
end

% GUI interface for selection of multiple tif files. 
if nargin < 2 || isempty(fixed_image) 
    
    [fixedFileName PathName] = uigetfile('*.tif;*.tiff','Select the reference fixed image');

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
    disp('Proceeding with provided fixed image.')
end

if nargin < 1 || isempty(moving_image) 
    [movingFileName PathName] = uigetfile('*.tif;*.tiff','Select the multiple moving images', [PathName fixedFileName] , 'MultiSelect', 'on');
    if iscell(movingFileName)==0; movingFileName={movingFileName}; end
    if ~isequal(movingFileName,0)
        for i=1:size(movingFileName,2)
          moving_image{i} = tiffclassreader(fullfile(PathName,movingFileName{i}),channels);
          if use_highpassfilt
            disp('Highpass filtering to allow registration based on local features...')
            moving_image_orig{i}=moving_image{i};
            moving_image{i} = highpassfilt3(moving_image{i},50);   % highpass filtering to allow registration based on local features 
          end
        end
    else
        error('No moving files.');
    end
    
else 
    disp('Proceeding with provided moving image.')
end
disp('Done loading images')

% check for RESOLUTION info, if absent set as default
if nargin < 3 || isempty(moving_res) 
    moving_res=ones(1,size(moving_image{1},5)+2 );
    disp('No resolution information for moving image provided, using 1x1x1 pixels.')
end
if nargin < 4 || isempty(fixed_res) 
    fixed_res=ones(1,size(fixed_image{1},5)+2);
    disp('No resolution information for moving image provided, using 1x1x1 pixels.')
end

mkdir([ PathName '\Registered'] )
    
if ~ndims(fixed_image)==3 || ~ndims(moving_image)==3
    error('For batch registration, both fixed and moving images must be 3D or 3D+channels.')
end

for i=1:size(movingFileName,2)
    [registered_image{i}, transformation, fit] = findposition3D( moving_image{i}, fixed_image, moving_res, fixed_res); % Register 3D->3D to find best matching transformation and visualize
    if use_highpassfilt
        % Transform original image to get un-filtered&transformed image.
    end
    visualize_tranformation(registered_image{i}(:,:,:,1));
    drawnow;
    %verbalize_tranformation(transformation);
    %save_tif(uint16(registered_image{i}), [ PathName '\Registered\' movingFileName{i}] )
    save_tif(permute( uint16(registered_image{i}), [1 2 5 3 4]), [ PathName '\Registered\' movingFileName{i}] ) % Save the moving images
end

save_tif(permute(fixed_image , [1 2 5 3 4]) , [ PathName '\Registered\' fixedFileName] ) % Save the fixed image
