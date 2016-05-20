function filtered_image = highpassfilt3(raw_image,sigma) 
% Highpass-filters 3d images by subtracting a gaussian filtered image
% 
% raw_image: uint16 3d image
% sigma: gaussian filter kernel width
%
% Ingie Hong, Johns Hopkins Medical Institute, 2016

smoothed_image = imgaussfilt3(raw_image,sigma);
filtered_image = int16(raw_image)- int16(smoothed_image);
filtered_image = filtered_image - min(filtered_image(:));