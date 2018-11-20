function visualize3D(img1, img2, ignore)
% Shows alignment of to images in a z_axis movie format
% img1 = fixed_image.data
% img2 = registered_moving_image.data
% ignore = percentage of brightest and darkest pixels to ignore to enhance
% image contrast
%
% i.e. one can run:
% visualize3d(fixed_image.data,registered_image)
% 
% Ingie Hong, Johns Hopkins Medical Institute, 2018

if nargin < 2 || isempty(img2) 
    img2=img1; % Default to just displaying img1
end

if nargin < 3 || isempty(ignore) 
    ignore=0.5; % Default to ignoring 0.5% of histogram
end

[py,px,pz,~,~] = size(img1);

% Enhance contrast based on value 'ignore(%)'
img1 = ( img1-prctile(img1(:),ignore) )* ( intmax(class(img1)) / (prctile(img1(:),100-ignore)-prctile(img1(:),ignore) ) );
img2 = ( img2-prctile(img2(:),ignore) )* ( intmax(class(img2)) / (prctile(img2(:),100-ignore)-prctile(img2(:),ignore) ) );

warning('off','images:initSize:adjustingMag')
figure;
for i = 1:pz
    im=imshowpair(img1(:,:,i,1,1),img2(:,:,i,1,1),'falsecolor','Scaling','independent');
    title(['Green - Fixed image, Magenta - Registered moving image  Frame: ' num2str(i) ' of ' num2str(pz)])
    % Alternative (slower) method to enhance contrast
    %im.CData = (im.CData - prctile(im.CData(:), 1)) * (255 / (prctile(im.CData(:), 99) - prctile(im.CData(:), 1)));
    axis image;  
    pause(0.1)
end

