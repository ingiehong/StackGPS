
% Use imshowpair to visualize registration results

scrsz = get(groot,'ScreenSize');
figure('Position',[50 50 scrsz(3)-100 scrsz(4)-200])
set(gcf,'Units','normal')
    
for i=1:size(registered_image,3)
    subplot(1,2,1)
    set(gca,'Position',[0 0 0.5 1])
    imshowpair(fixed_image.data(:,:,i),registered_image(:,:,i)); %, 'montage')
    subplot(1,2,2)
    set(gca,'Position',[0.5 0 0.5 1])
    imshowpair(fixed_image.data(:,:,i),registered_image(:,:,i), 'diff'); %, 'montage')
    pause;
end

close(gcf)
