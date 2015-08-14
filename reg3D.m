function [transformation, fit, registered_image] = reg3D(fixed, target)
% reg2D is a wrapper for ELASTIX for 2D-to-2D registration
% Given two 2D matrix images (fixed, target) it finds a Euler transfomation
% that minimizes a fit function through ELASTIX registration.

%tic
[execution_path,~,~] = fileparts( mfilename('fullpath') );
options.verbose=false;
[t, immreg, iterinfo] = elastix(['"' execution_path '\Parameters_Rigid_3Dto3D.txt"'], fixed, target, options);
%elapsed_time=toc;

transformation=t.TransformParameters;
registered_image=immreg.data;
%imagesc(immreg.data)
fit=iterinfo.Metric(length(iterinfo.Metric));

