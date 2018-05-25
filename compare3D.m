
% Use imshowpair to visualize registration results

scrsz = get(groot,'ScreenSize');
figure('Position',[50 50 scrsz(3)-100 scrsz(4)-200])
set(gcf,'Units','normal')
    
for i=1:size(registered_image,3)
    scale_ratio=squeeze(mean(mean(registered_image(:,:,i),2),1))/squeeze(mean(mean(fixed_image(:,:,i),2),1));
    subplot(1,2,1)
    set(gca,'Position',[0 0 0.5 1])
    imshowpair(fixed_image(:,:,i)*scale_ratio,uint16(registered_image(:,:,i))); %, 'montage')
    title(['Blend of fixed image (green) and registered moving image (magenta). Z=' num2str(i)]) 
    subplot(1,2,2)
    set(gca,'Position',[0.5 0 0.5 1])
    imshowpair(fixed_image(:,:,i)*scale_ratio,uint16(registered_image(:,:,i)), 'diff'); %, 'montage')
    pause;
end

close(gcf)
