% GUI interface for selection of 2 tif files. 

[movingFileName PathName] = uigetfile('*.tif;*.tiff','Select the current moving image');

if ~isequal(movingFileName,0)
      moving_image = tiffclassreader(fullfile(PathName,movingFileName));
else
    error('No moving file.');
end

[fixedFileName PathName] = uigetfile('*.tif;*.tiff','Select the reference fixed image', [PathName movingFileName] );

if ~isequal(fixedFileName,0)
      fixed_image = tiffclassreader(fullfile(PathName,fixedFileName));
      else
    error('No target fixed image file.');
end

%clear PathName
