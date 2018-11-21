function [transformed_image, target_image] = apply_transformation( target_FileName, target_channel, target_res, t, target_image) 
% Function to transform other images with the transformation discovered with
% registration
%
% target_FileName is the source image filename, for use of loading and also
% saving with '_transformed.tif' postfix
%
% ex) [transformed_image, target_image] = apply_transformation(fullfile(sg.movingPathName,sg.movingFileName), 2, sg.moving_res, sg.t);
%
% Ingie Hong, Johns Hopkins Medical Institute, 2018


if nargin < 5 || isempty(target_image) 
    target_image = tiffclassreader( target_FileName, target_channel);
else
    disp('Using image provided...') 
end
  
t.ResultImageFormat = 'mha';
transformed_image = transformix( t, scimat_im2scimat(target_image, target_res));
disp([ 'Original image dynamic range = ' num2str( [ min(target_image(:)) max(target_image(:))]) ]);
disp([ 'Transformed image dynamic range = ' num2str( [ min(transformed_image.data(:)) max(transformed_image.data(:))]) ]);
[filepath,name,ext] = fileparts(target_FileName);
save_tif(uint16(transformed_image.data), [filepath filesep name '_transformed.tif']  )
disp(['Done transforming target image. Results saved as ' filepath filesep name '_transformed.tif'])