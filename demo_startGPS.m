
% Demo script for starting a StackGPS session 
% Resolution values are default for 20X Sutter 2P microscope at 512x512
% acquisition and 1um z-steps.
%
% Ingie Hong, Johns Hopkins Medical Institute, 2016

%[registered_image, moving_image, fixed_image, transformation, fit, movingFileName, fixedFileName ] = stackGPS(moving_image, fixed_image, moving_res, fixed_res);
[registered_image, moving_image, fixed_image, transformation, fit, movingFileName, fixedFileName ] = stackGPS([], [], [389/512 389/512 1], [389/512 389/512 1]);