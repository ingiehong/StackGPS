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

% Execute registration through Elastix wrapper from Oxford
disp('3D Registration initiated...')
[transformation, fit, registered_image, t] = reg3D(fixed_image, moving_image);


