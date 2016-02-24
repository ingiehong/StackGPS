
% Use imshowpair to visualize registration results
figure
for i=1:size(registered_image,3)
imshowpair(fixed_image.data(:,:,i),registered_image(:,:,i), 'montage')
pause;
end