function save_tif(img, outputFineName)

outputFileName = 'img_stack.tif'
for K=1:length(img(1, 1, :))
   imwrite(img(:, :, K), outputFileName, 'WriteMode', 'append',  'Compression','none');
end