function visualize_tranformation(registered_image)
% Visualize transformed image
%     registered_image: 3D transformed image. If multichannel, first
%     channel will be visualized.
%
% Ingie Hong, Johns Hopkins Medical Institute, 2016
if ndims(registered_image)>3
    registered_image=registered_image(:,:,:,1,1);
end

%figure
figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,2,1)
imagesc(squeeze(mean(registered_image, 3)))
title('Top view')
xlabel('X-axis - Pixels')
ax=gca;
ax.YAxisLocation = 'right';
ylabel('Y-axis - Pixels')

subplot(2,2,2)
imagesc(squeeze(mean(registered_image, 2)))
title('Side view')
ax=gca;
ax.YAxisLocation = 'right';
ylabel('Y-axis - Pixels')
xlabel('Z-axis - Pixels')

subplot(2,2,3)
imagesc(squeeze(mean(registered_image, 1))') % Note the transpose
title('Front view')
xlabel('X-axis - Pixels')
ylabel('Z-axis - Pixels')
colormap gray
