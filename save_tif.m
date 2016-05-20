function save_tif(img, outputFileName)
% Save multi-frame TIFFs with imwrite
%
% Ingie Hong, Johns Hopkins Medical Institute, 2016

if isempty(outputFileName) || nargin < 2 
    outputFileName = 'img_stack.tif';
end

for K=1:length(img(1, 1, :))
   imwrite(img(:, :, K), outputFileName, 'WriteMode', 'append',  'Compression','none');
end