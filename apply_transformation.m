function [transformed_image, target_image] = apply_transformation( target_FileName, target_channel, target_res, t) 
% Function to transform other images with the transformation discovered with
% registration
%
% ex) [transformed_image, target_image] = apply_transformation(fullfile(sg.movingPathName,sg.movingFileName), 2, sg.moving_res, sg.t);
%
% Ingie Hong, Johns Hopkins Medical Institute, 2018

target_image = tiffclassreader( target_FileName, target_channel);
t.ResultImageFormat = 'mha';
transformed_image = transformix( t, scimat_im2scimat(target_image, target_res));
disp([ 'Original image dynamic range = ' num2str( [ min(target_image(:)) max(target_image(:))]) ]);
disp([ 'Transformed image dynamic range = ' num2str( [ min(transformed_image.data(:)) max(transformed_image.data(:))]) ]);
[filepath,name,ext] = fileparts(target_FileName);
save_tif(uint16(transformed_image.data), [filepath filesep name '_transformed.tif']  )