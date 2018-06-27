function filtered_images = highpassfilt3(raw_image,sigma) 
% Highpass-filters 3d images by subtracting a gaussian filtered image
% 
% raw_image: uint16 3d image
% sigma: gaussian filter kernel width
%
% Ingie Hong, Johns Hopkins Medical Institute, 2016

for i=1:size(raw_image,5)
    smoothed_image = imgaussfilt3(raw_image(:,:,:,:,i),sigma);
    filtered_image = int16(raw_image(:,:,:,:,i))- int16(smoothed_image);
    filtered_images(:,:,:,:,i) = filtered_image - min(filtered_image(:));
end