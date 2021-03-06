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
figure('Name','Registration results','units','normalized','outerposition',[0.35 0.1 0.45 0.85])

% Draw image volume in correct voxel size from 3 directions
% First, calculate some ratios.
%top_view_x = (fixed_res(1)*size(registered_image,1)/ (fixed_res(1)*size(registered_image,1) + fixed_res(3)*size(registered_image,3)))^1;
%top_view_y = (fixed_res(2)*size(registered_image,2)/ (fixed_res(3)*size(registered_image,3) + fixed_res(2)*size(registered_image,2)))^1;
margin = 0.09;
ylength = fixed_res(1)*size(registered_image,1);
xlength = fixed_res(2)*size(registered_image,2);
zlength = fixed_res(3)*size(registered_image,3);
axes_size = (1-3*margin)/(zlength + max(xlength, ylength));

% Divide figure into subplots 
%subplot('Position', [ margin 1-top_view_y+margin top_view_x-2*margin top_view_y-2*margin])
subplot('Position', [ margin 2*margin+axes_size*zlength axes_size*ylength axes_size*xlength])
imagesc(squeeze(mean(registered_image, 3)), clims)
title('Top view')
xlabel('X-axis - Pixels')
ax=gca;
ax.YAxisLocation = 'right';
ylabel('Y-axis - Pixels')
%daspect([fixed_res(2) fixed_res(1) 1])

%subplot('Position', [ top_view_x+margin 1-top_view_y+margin 1-top_view_x-2*margin top_view_y-margin*2])
subplot('Position', [ 2*margin+axes_size*ylength 2*margin+axes_size*zlength axes_size*zlength axes_size*xlength])
imagesc(squeeze(mean(registered_image, 2)), clims)
title('Side view')
ax=gca;
ax.YAxisLocation = 'right';
ylabel('Y-axis - Pixels')
xlabel('Z-axis - Pixels')
%daspect([fixed_res(2) fixed_res(3) 1])


%subplot('Position', [ margin margin top_view_x-2*margin 1-top_view_y-2*margin])
subplot('Position', [ margin margin axes_size*ylength axes_size*zlength])
imagesc(squeeze(mean(registered_image, 1))', clims) % Note the transpose
title('Front view')
xlabel('X-axis - Pixels')
ylabel('Z-axis - Pixels')
% Set colormap to magma for high contrast
load('cmap.mat')
colormap(cmap)
%daspect([fixed_res(3) fixed_res(1) 1])

%subplot('Position', [ top_view_x  0 1-top_view_x 1-top_view_y ])
subplot('Position', [ 1.5*margin+axes_size*ylength margin 1-axes_size*ylength-3*margin 1-axes_size*ylength-3*margin])
text(0.1,0.5,['* Mean Intensity Projections (MIP) ' char(10) '  of the registered moving image' char(10) '  volume from each 3D direction'])
set(gca, 'Visible', 'off')