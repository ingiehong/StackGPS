function [transformation, fit, registered_image] = reg2D(fixed, target, bVerbose)
% reg2D is a wrapper for ELASTIX for 2D-to-2D registration
% Given two 2D matrix images (fixed, target) it finds a Euler transfomation
% that minimizes a fit function through ELASTIX registration.

%tic
[execution_path,~,~] = fileparts( mfilename('fullpath') );

if nargin<3 || isempty(bVerbose) 
    options.verbose=false;
else
    options.verbose=bVerbose;
end

[t, immreg, iterinfo] = elastix(['' execution_path '\Parameters_Rigid_2Dto2D.txt'], fixed, target, options);
%elapsed_time=toc;

transformation=t.TransformParameters;
registered_image=immreg.data;
%imagesc(immreg.data)
fit=iterinfo.Metric(length(iterinfo.Metric));


