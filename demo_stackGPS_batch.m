
% Demo script for starting a StackGPS_batch session 
% Resolution values are default for 20X Sutter 2P microscope at 1024x1024,3x zoom
% acquisition and 1um z-steps.
% If multi-channel, StackGPS_batch will attempt to do multichannel
% registration.
%
% Ingie Hong, Johns Hopkins Medical Institute, 2016

moving_image=[];
fixed_image=[];
% 3x zoom on 20x objective 
moving_res=[389/3/1024 389/3/1024 1 1 ];
fixed_res=[389/3/1024 389/3/1024 1 1 ];
channels=0;
use_highpassfilt=false;

[registered_image, moving_image, fixed_image, transformation, fit, movingFileName, fixedFileName ] = stackGPS_batch( moving_image, fixed_image, moving_res, fixed_res, channels, use_highpassfilt);
% 5x zoom on 40x objective of in vitro scope
%[registered_image, moving_image, fixed_image, transformation, fit, movingFileName, fixedFileName ] = stackGPS_batch([], [],  [80/1024 80/1024 1 1 ] , [80/1024 80/1024 1 1] );