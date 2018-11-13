function visualize3D(img1,img2)
% img1 = fixed_image.data
% i.e. one can run:
% visualize3d(fixed_image.data,registered_image)

[py,px,pz] = size(img1);

%img = zeros(py,px,pz,3);

%img(:,:,:,1) = img1;
%img(:,:,:,2) = img2;
%img1 = double( img1-min(img1(:)) )/ double(max(img1(:))-min(img1(:)) );
%img2 = double( img2-min(img2(:)) )/ double(max(img2(:))-min(img2(:)) );
warning('off','images:initSize:adjustingMag')
figure;
for i = 1:pz
    %image(squeeze(img(:,:,i,:))); 
    imshowpair(img1(:,:,i,1,1),img2(:,:,i,1,1),'falsecolor','Scaling','independent');
    title(['Green - Fixed image, Magenta - Registered moving image  Frame:' num2str(i)])
    temp_img2 = img2(:,:,i,1,1);
    %cscale =  255 * double( [prctile(temp_img2(:),10)  prctile(temp_img2(:),90)] )/ double(max(img2(:)))
    cscale = [5 45]; 
    caxis(cscale);
    axis image;  
    pause(0.1)
end

