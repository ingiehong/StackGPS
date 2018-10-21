function visualize_tranformation(registered_image, fixed_res)
% Visualize transformed image
%     registered_image: 3D transformed image. If multichannel, first
%     channel will be visualized.
%
% Ingie Hong, Johns Hopkins Medical Institute, 2016
if ndims(registered_image)>3
    registered_image=registered_image(:,:,:,1,1);
end

clims= [prctile(registered_image(:),10) prctile(registered_image(:),90)];
%figure
figure('Name','Registration results','units','normalized','outerposition',[0.35 0.1 0.6 0.85])
top_view_x = (fixed_res(1)*size(registered_image,1)/ (fixed_res(1)*size(registered_image,1) + fixed_res(3)*size(registered_image,3)))^3;
top_view_y = (fixed_res(2)*size(registered_image,2)/ (fixed_res(3)*size(registered_image,3) + fixed_res(2)*size(registered_image,2)))^3;
margin = 0.08;

subplot('Position', [ margin 1-top_view_y+margin top_view_x-2*margin top_view_y-2*margin])
imagesc(squeeze(mean(registered_image, 3)), clims)
title('Top view')
xlabel('X-axis - Pixels')
ax=gca;
ax.YAxisLocation = 'right';
ylabel('Y-axis - Pixels')

subplot('Position', [ top_view_x+margin 1-top_view_y+margin 1-top_view_x-2*margin top_view_y-margin*2])
imagesc(squeeze(mean(registered_image, 2)), clims)
title('Side view')
ax=gca;
ax.YAxisLocation = 'right';
ylabel('Y-axis - Pixels')
xlabel('Z-axis - Pixels')

subplot('Position', [ margin margin top_view_x-2*margin 1-top_view_y-2*margin])
imagesc(squeeze(mean(registered_image, 1))', clims) % Note the transpose
title('Front view')
xlabel('X-axis - Pixels')
ylabel('Z-axis - Pixels')
%colormap gray
load('cmap.mat')
colormap(cmap)

subplot('Position', [ top_view_x  0 1-top_view_x 1-top_view_y ])
text(0.1,0.5,['* Mean Intensity Projections (MIP) ' char(10) '  of the registered moving image' char(10) '  from each cardinal direction'])
set(gca, 'Visible', 'off')