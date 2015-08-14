% findposition.m : matches moving_image (3D) to fixed_image (3D) 
% with rigid registration and finds best fit & transformation.
% 

fixed_image = scimat_im2scimat(reshape(fixed_image, size(fixed_image, 1), size(fixed_image, 2), size(fixed_image, 3), 1, size(fixed_image,4)), [0.12 0.12 1] );
moving_image = scimat_im2scimat(reshape(moving_image, size(moving_image, 1), size(moving_image, 2), size(moving_image, 3), 1, size(fixed_image,4)), [0.12 0.12 1]);
% Execute registration through Elastix wrapper from Oxford
[transformation, fit, registered_image] = reg3D(fixed_image, moving_image);

% Visualize transformation
figure
imagesc(mean(registered_image,3))

% Present transformation parameters
%min_fit_i
disp([num2str(round(-10*transformation(6))/10) 'th slice of fixed reference image corresponds best to the first slice of the moving image.' ]);
% %transformation(min_fit_i, :)
disp(['Transformation X-Y-Z (pixels): ' num2str(round(10*transformation(4:6))/10)]);
disp(['Euler Angles (deg, X-Y-Z axis): ' num2str(round(-10*transformation(1:3)*360/pi/2)/10)])

clear h
clear i