% killwaitbar - Script to remove sticky waitbars in MATLAB.

F = findall(0,'type','figure','tag','TMWWaitbar');
delete(F);