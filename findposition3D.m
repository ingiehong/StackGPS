% findposition.m : matches moving_image (3D) to fixed_image (3D) 
% with rigid registration and finds best fit & transformation.
% 

% We should implement image header information import for RESOLUTION info
fixed_image = scimat_im2scimat(reshape(fixed_image, size(fixed_image, 1), size(fixed_image, 2), size(fixed_image, 3), 1, size(fixed_image,4)), [389/512 389/512 1] );
moving_image = scimat_im2scimat(reshape(moving_image, size(moving_image, 1), size(moving_image, 2), size(moving_image, 3), 1, size(moving_image,4)), [389/512 389/512 1]);
% Execute registration through Elastix wrapper from Oxford
disp('3D Registration initiated...')
[transformation, fit, registered_image] = reg3D(fixed_image, moving_image);

% Visualize transformation
figure
subplot(2,2,1)
imagesc(squeeze(mean(registered_image, 3)))
title('Top view')
subplot(2,2,2)
imagesc(squeeze(mean(registered_image, 2)))
title('Side view')
subplot(2,2,3)
imagesc(squeeze(mean(registered_image, 1))')
title('Front view')

% Present transformation parameters
%min_fit_i
disp([num2str(round(10*transformation(6))/10) 'um Z-shift between moving and fixed reference image corresponds to best registration.' ]);
% %transformation(min_fit_i, :)
disp(['Transformation X-Y-Z (um): ' num2str(round(10*transformation(4:6))/10)]);
disp(['Euler Angles (deg, X-Y-Z axis): ' num2str(round(-10*transformation(1:3)*360/pi/2)/10)])

clear h
clear i