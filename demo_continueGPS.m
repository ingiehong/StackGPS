
% Demo script for continuing a StackGPS session with given fixed image
% Resolution values are default for 20X Sutter 2P microscope at 512x512
% acquisition and 1um z-steps.

%[registered_image, moving_image, fixed_image, transformation, fit, movingFileName, fixedFileName ] = stackGPS(moving_image, fixed_image, moving_res, fixed_res);
[registered_image, moving_image, fixed_image, transformation, fit, movingFileName, fixedFileName ] = stackGPS([], fixed_image, [389/512 389/512 1], [389/512 389/512 1]);