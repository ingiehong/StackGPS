function [transformation, fit, registered_image, t] = reg3D(fixed, target, bVerbose)
% reg3D is a wrapper for ELASTIX for 3D-to-3D registration
% Given two 3D matrix images (fixed, target) it finds a Euler transfomation
% that minimizes a fit function through ELASTIX registration.
% Multi-channel images also supported (X Y Z T=1 C)

%tic
[execution_path,~,~] = fileparts( mfilename('fullpath') );

if nargin<3 || isempty(bVerbose) 
    options.verbose=false;
else
    options.verbose=bVerbose;
end

if ndims(fixed.data)==5 % Multimodal or monomodal registration
    [t, immreg, iterinfo] = elastix([execution_path '\Parameters_Rigid_3Dto3D_MultiChannel.txt'], fixed, target, options);
else
    [t, immreg, iterinfo] = elastix([execution_path '\Parameters_Rigid_3Dto3D.txt'], fixed, target, options);
end

%elapsed_time=toc;

transformation=t.TransformParameters;
registered_image=immreg.data;
%imagesc(immreg.data)
fit=iterinfo.Metric(length(iterinfo.Metric));

