function visualize3D(img1,img2)
% img1 = fixed_image.data
% i.e. one can run:
% visualize3d(fixed_image.data,registered_image)

[py,px,pz] = size(img1);

img = zeros(py,px,pz,3);

img(:,:,:,1) = img1;
img(:,:,:,2) = img2;

img = img/max(img(:));
figure;
for i = 1:pz
    image(squeeze(img(:,:,i,:))); axis image; pause
end

