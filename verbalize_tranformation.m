function verbalize_tranformation(transformation)
% Visualize transformation
%
% Ingie Hong, Johns Hopkins Medical Institute, 2016


% Present transformation parameters
%min_fit_i
disp([num2str(round(10*transformation(6))/10) ' unit Z-shift between moving and fixed reference image corresponds to best registration.' ]);
% %transformation(min_fit_i, :)
disp(['Transformation X-Y-Z (units): ' num2str(round(10*transformation(4:6))/10)]);
disp(['Euler Angles (deg, X-Y-Z axis): ' num2str(round(-10*transformation(1:3)*360/pi/2)/10)])
