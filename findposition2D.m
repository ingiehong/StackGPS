function [registered_image, transformation, fit] = findposition2D( moving_image, fixed_image, bVerbose)
% findposition2D.m : matches moving_image (2D) to individual stacks of 
% fixed_image (2D or 3D) with rigid registration and finds best fit &
% transformation.
% 

h = waitbar(0,'Initializing registration...','Name','Finding position within stack image',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
figure

for i=1:size(fixed_image,3)
    % Check for Cancel button press
    if getappdata(h,'canceling')
        break
    end
    % Update progress bar
    waitbar(i/size(fixed_image,3),h,sprintf('Registering individual stacks...%d of %d', i, size(fixed_image,3)));
    
    % Execute registration through Elastix wrapper from Oxford
    [transformation(i,:), fit(i), registered_image(:,:,i)] = reg2D(fixed_image(:,:,i), moving_image, bVerbose);

    %Plot results
    subplot(2,2,1)
    cla
    plot(fit)
    title('Fit of registration')
    [~,min_fit_i]=min(fit);
    hold on
    plot(min_fit_i,fit(min_fit_i),'ro')
    
    subplot(2,2,2)
    cla
    plot(transformation(:,2),transformation(:,3),'b-o')
    title('Transformation X-Y (pixels)')
    hold on   
    plot(transformation(min_fit_i,2),transformation(min_fit_i,3),'ro')
    
    subplot(2,2,3)
    cla
    plot(transformation(:,1)*360/pi/2)   % translate into degrees. needs verification.
    title('Transformation Angle (deg)')
    hold on
    plot(min_fit_i,transformation(min_fit_i,1)*360/pi/2,'ro')
    
    subplot(2,2,4)
    imagesc(registered_image(:,:,min_fit_i))
    title('Best fitted image')

end

delete(h)       % DELETE the waitbar; don't try to CLOSE it.

% Present transformation parameters

%min_fit_i
disp([num2str(min_fit_i) 'th slice of fixed reference image corresponds best to the moving image.' ]);
%transformation(min_fit_i, :)
disp(['Transformation X-Y (pixels): ' num2str(transformation(min_fit_i,2:3))]);
disp(['Transformation Angle (deg): ' num2str(transformation(min_fit_i,1)*360/pi/2)])

registered_image = registered_image(:,:,min_fit_i);
transformation = transformation(min_fit_i,:);
fit = fit(min_fit_i);

clear h
clear i

