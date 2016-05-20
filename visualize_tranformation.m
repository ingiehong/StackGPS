function visualize_tranformation(registered_image)
% Visualize transformation
%
% Ingie Hong, Johns Hopkins Medical Institute, 2016
figure
subplot(2,2,1)
imagesc(squeeze(mean(registered_image, 3)))
title('Top view')
subplot(2,2,2)
imagesc(squeeze(mean(registered_image, 2)))
title('Side view')
subplot(2,2,3)
imagesc(squeeze(mean(registered_image, 1))') % Note the transpose
title('Front view')