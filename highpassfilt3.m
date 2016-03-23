function filtered_image = highpassfilt3(raw_image) 
% Highpass-filters 3d images by subtracting a gaussian filtered image
% (sigma 10)
% 
% raw_image: uint16 3d image
%
% Ingie 160321

smoothed_image = imgaussfilt3(raw_image,50);
filtered_image = int16(raw_image)- int16(smoothed_image);
filtered_image = filtered_image - min(filtered_image(:));