% Load two image files, (2D->2D, pseudo2D->3D, or 3D to 3D) and align them using rigid
% transformation. Give X,Y,rotational offsets to aid physical adjustment of specimen to same position.
%
% Keeping as script for debugging purposes
% 

selectTIFs % Select two tifs, first a moving image, and a reference fixed image

%if ndims(fixed_image)==3 && ndims(moving_image)==3
if ndims(moving_image)==3
    findposition3D % Register 3D->3D to find best matching transformation and visualize
else
    findposition2D % Find best matching slice and transformation and visualize
end
