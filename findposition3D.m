function [registered_image, transformation, fit, t] = findposition3D( moving_image, fixed_image, moving_res, fixed_res)
% findposition3D() : matches moving_image (3D) to fixed_image (3D) 
% with rigid registration and finds best fit & transformation.
% 
%
% Ingie Hong, Johns Hopkins Medical Institute, 2016

% Convert images to scimat format for Elastix
moving_image = scimat_im2scimat(moving_image, moving_res);
fixed_image = scimat_im2scimat(fixed_image, fixed_res );
%moving_image = scimat_im2scimat(reshape(moving_image, size(moving_image, 1), size(moving_image, 2), size(moving_image, 3), 1, size(moving_image,4)), moving_res);
%fixed_image = scimat_im2scimat(reshape(fixed_image, size(fixed_image, 1), size(fixed_image, 2), size(fixed_image, 3), 1, size(fixed_image,4)), fixed_res );

% To avoid saturation and cutoff due to int16 output of elastix, divide image by 2 and correct later
if max(moving_image.data(:)) >= 2^15 && min(moving_image.data(:)) >= 0
    moving_image.data = moving_image.data/3;
    scaled_down = true;
else
    scaled_down = false;
end
    
% Execute registration through Elastix wrapper from Oxford
disp('3D Registration initiated...')
[transformation, fit, registered_image, t] = reg3D(fixed_image, moving_image);

if scaled_down == true
    registered_image = uint16(registered_image) * 3;
end


