function [registered_image, moving_image, fixed_image, transformation, fit, movingFileName, fixedFileName ] = stackGPS_batch( moving_image, fixed_image, moving_res, fixed_res, channels)
% Load two image files, (2D->2D, pseudo2D->3D, or 3D to 3D) and align them using rigid
% transformation. Give X,Y,rotational offsets to aid physical adjustment of specimen to same position.
%
%   moving_image and fixed_image are image-containing matrices
%   moving_res and fixed_res are vectors with the physical voxel size
%       By default, RES is 1.0 in each dimension. ex) [389/512 389/512 1] 
%   channels is the specific channel set to be used for registration 
%       ex) [1 2] for two channels, default all
% Ingie Hong, Johns Hopkins Medical Institute, 2016

% Suppress errors related to Scanimage tif files
warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning');

if nargin < 5 || isempty(channels) 
    channels=0; % Default to All channels
end

% GUI interface for selection of multiple tif files. 
if nargin < 2 || isempty(fixed_image) 
    [fixedFileName PathName] = uigetfile('*.tif;*.tiff','Select the reference fixed image');

    if ~isequal(fixedFileName,0)
        fixed_image = tiffclassreader(fullfile(PathName,fixedFileName),channels);
        %fixed_image = highpassfilt3(fixed_image,50);
    else
        error('No target fixed image file.');
    end
    
else 
    disp('Proceeding with provided fixed image.')
end

if nargin < 1 || isempty(moving_image) 
    [movingFileName PathName] = uigetfile('*.tif;*.tiff','Select the current moving image', [PathName fixedFileName] , 'MultiSelect', 'on');
    if iscell(movingFileName)==0; movingFileName={movingFileName}; end
    if ~isequal(movingFileName,0)
        for i=1:size(movingFileName,2)
          moving_image{i} = tiffclassreader(fullfile(PathName,movingFileName{i}),channels);
          %moving_image = highpassfilt3(moving_image,50); 
        end
    else
        error('No moving files.');
    end
    
else 
    disp('Proceeding with provided moving image.')
end


% check for RESOLUTION info, if absent set as default
if nargin < 3 || isempty(moving_res) 
    moving_res=[1 1 1];
end
if nargin < 4 || isempty(fixed_res) 
    fixed_res=[1 1 1];
end

mkdir([ PathName '\Registered'] )
save_tif(fixed_image, [ PathName '\Registered\' fixedFileName] )
    
%if ndims(fixed_image)==3 && ndims(moving_image)==3
for i=1:size(movingFileName,2)
    [registered_image, transformation, fit] = findposition3D( moving_image{i}, fixed_image, moving_res, fixed_res); % Register 3D->3D to find best matching transformation and visualize
    %visualize_tranformation(registered_image);
    %verbalize_tranformation(transformation);
    save_tif(uint16(registered_image), [ PathName '\Registered\' movingFileName{i}] )
end
