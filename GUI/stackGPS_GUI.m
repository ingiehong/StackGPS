function varargout = stackGPS_GUI(varargin)
% STACKGPS_GUI MATLAB code for stackGPS_GUI.fig
%      STACKGPS_GUI, by itself, creates a new STACKGPS_GUI or raises the existing
%      singleton*.
%
%      H = STACKGPS_GUI returns the handle to a new STACKGPS_GUI or the handle to
%      the existing singleton*.
%
%      STACKGPS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STACKGPS_GUI.M with the given input arguments.
%
%      STACKGPS_GUI('Property','Value',...) creates a new STACKGPS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stackGPS_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stackGPS_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stackGPS_GUI

% Last Modified by GUIDE v2.5 21-Nov-2018 16:33:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stackGPS_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @stackGPS_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Save useful variables in workspace variable sg

%disp('Creating main GUI...')

% --- Executes just before stackGPS_GUI is made visible.
function stackGPS_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stackGPS_GUI (see VARARGIN)

% Choose default command line output for stackGPS_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%disp('Opening main GUI...')
global sg
sg=[];
evalin('base','global sg;'); 
%assignin('base', 'sg', [])

%% Some defaults
set(handles.edit1,'String', '0.1266');
set(handles.edit2,'String', '0.1266');
set(handles.edit4,'String', '0.1266');
set(handles.edit5,'String', '0.1266');
set(handles.edit7,'String', '2');

%% Initialize some settings
sg.moving_image=[];
sg.fixed_image=[];
sg.moving_res=[str2double(get(handles.edit4,'String')) str2double(get(handles.edit5,'String')) str2double(get(handles.edit6,'String')) 1];
sg.fixed_res=[str2double(get(handles.edit1,'String')) str2double(get(handles.edit2,'String')) str2double(get(handles.edit3,'String')) 1];
sg.channels=str2num(handles.edit7.String);
sg.use_highpassfilt=handles.checkbox1.Value;
sg.movingPathName=pwd;
sg.fixedPathName=pwd;
sg.movingFileName='';
sg.fixedFileName='';

% Move window to left top corner 
movegui(handles.figure1, 'northwest')

% Set StackGPS icon 
try
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame')
    javaFrame = get(hObject,'JavaFrame');
    javaFrame.setFigureIcon(javax.swing.ImageIcon([fileparts(which('stackGPS')) filesep 'GUI\ICON.png']));
catch
    disp('Failed to load window icon.')
end

sg.handles = handles; 
% UIWAIT makes stackGPS_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stackGPS_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% Generic refresh function for all edit box updates
global sg
sg.moving_res=[str2double(get(handles.edit4,'String')) str2double(get(handles.edit5,'String')) str2double(get(handles.edit6,'String')) 1];
sg.fixed_res=[str2double(get(handles.edit1,'String')) str2double(get(handles.edit2,'String')) str2double(get(handles.edit3,'String')) 1];
sg.channels=str2num(handles.edit7.String);
sg.use_highpassfilt=handles.checkbox1.Value;



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global sg
% GUI interface for selection of fixed image file. 

[sg.fixedFileName sg.fixedPathName] = uigetfile('*.tif;*.tiff;*.czi','Select the reference fixed image', sg.fixedPathName );

if ~isequal(sg.fixedFileName,0)
    handles.edit11.String = '';
    sg.fixed_image = tiffclassreader(fullfile(sg.fixedPathName,sg.fixedFileName),sg.channels);
    if sg.use_highpassfilt
        disp('Highpass filtering to allow registration based on local features...')
        sg.fixed_image_orig=sg.fixed_image;
        sg.fixed_image = highpassfilt3(sg.fixed_image,50);   % highpass filtering to allow registration based on local features
    end
    handles.edit11.String = sg.fixedFileName; 
    imagesizetext = num2str([size(sg.fixed_image,1) size(sg.fixed_image,2) size(sg.fixed_image,3) size(sg.fixed_image,5)]);
    sg.handles.axes1.Children(6).String = ['Fixed Image     (Dimensions: ' imagesizetext ')' ];
    disp('Done loading target fixed image.')
else
    disp('No target fixed image file selected.');
    sg.fixedPathName = [];
    sg.fixedFileName = [];
    sg.handles.axes1.Children(6).String = 'Fixed Image';
end

if isempty(sg.movingPathName)
    sg.movingPathName = sg.fixedPathName;
end    
    

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global sg
% GUI interface for selection of moving image file. 

[sg.movingFileName sg.movingPathName] = uigetfile('*.tif;*.tiff;*.czi','Select the current moving image', sg.movingPathName);

if ~isequal(sg.movingFileName,0)
    handles.edit12.String = '';
    sg.moving_image = tiffclassreader(fullfile(sg.movingPathName,sg.movingFileName),sg.channels);
    if sg.use_highpassfilt
        disp('Highpass filtering to allow registration based on local features...')
        sg.moving_image_orig=sg.moving_image;
        sg.moving_image = highpassfilt3(sg.moving_image,50);  % highpass filtering to allow registration based on local features
    end
    handles.edit12.String = sg.movingFileName;
    imagesizetext = num2str([size(sg.moving_image,1) size(sg.moving_image,2) size(sg.moving_image,3) size(sg.moving_image,5)]);
    sg.handles.axes1.Children(5).String = ['Moving Image  (Dimensions: ' imagesizetext ')' ];
    disp('Done loading moving image.')
else
    disp('No moving image file selected.');
    sg.movingPathName = [];
    sg.movingFileName = [];
    sg.handles.axes1.Children(5).String = 'Moving Image';
end
if isempty(sg.fixedPathName) 
    sg.fixedPathName = sg.movingPathName;
end

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1

% Draw background and generate transparent text labels

axes(hObject);
bakTag = get(gca, 'Tag');
h=imshow('BG.png');
set(h, 'AlphaData', 1);
text1 = text(110,200,'Fixed Image','backgroundcolor','none','FontSize',8,'parent',gca);
text2 = text(110,400,'Moving Image','backgroundcolor','none','FontSize',8,'parent',gca);
text(60,650,'          Pixel Size (Fixed)          Channel             Pixel Size (Moving)','backgroundcolor','none','FontSize',8,'parent',gca)
text(60,700,'      X             Y             Z           (0=all)              X            Y             Z             ','backgroundcolor','none','FontSize',8,'parent',gca)

text(60,950,'              Linear Offset                                         Euler Angle Offset  ','backgroundcolor','none','FontSize',8,'parent',gca)
text(60,1000,'      X             Y             Z                                   X            Y             Z             ','backgroundcolor','none','FontSize',8,'parent',gca)

set(gca, 'Tag', bakTag);




function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Currently disabled.')

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Starting registration (this may take several minutes depending on image size)...')
global sg
[sg.registered_image, sg.moving_image, sg.fixed_image, sg.transformation, sg.fit, ~, ~, sg.t ] = stackGPS( sg.moving_image, sg.fixed_image, sg.moving_res, sg.fixed_res, sg.channels, sg.use_highpassfilt);
if length(sg.transformation)==6
    handles.edit13.String=round(100*sg.transformation(4)/100);
    handles.edit14.String=round(100*sg.transformation(5)/100);
    handles.edit15.String=round(100*sg.transformation(6)/100);
    handles.edit16.String=num2str(round(-10*sg.transformation(1)*360/pi/2)/10);
    handles.edit17.String=num2str(round(-10*sg.transformation(2)*360/pi/2)/10);
    handles.edit19.String=num2str(round(-10*sg.transformation(3)*360/pi/2)/10);
elseif length(sg.transformation)==3
    handles.edit13.String=num2str(sg.transformation(2),3);
    handles.edit14.String=num2str(sg.transformation(3),3);
    handles.edit15.String=[];
    handles.edit16.String=[]; 
    handles.edit17.String=[];
    handles.edit19.String=num2str((-sg.transformation(1)*360/pi/2),2);

end
disp('Done!')    


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Starting movie visualization...')
global sg
try 
    visualize3D(sg.fixed_image,sg.registered_image, 0.5, sg.channels)
catch
    errordlg('Images not found. Please load images and register first.','No Image Error');
end
disp('Done!')

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Applying found transformation to current moving image...')
global sg
try 
    [transformed_image, target_image] = apply_transformation(fullfile(sg.movingPathName,sg.movingFileName), 2, sg.moving_res, sg.t, sg.moving_image);
catch
    errordlg('Images and transformation not found. Please load images and register first.','No Image or Transformation Error');
end
disp('Done!')

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Saving registered moving image...')
global sg
[~,name,~] = fileparts(sg.movingFileName);
save_tif(uint16(sg.registered_image), [sg.movingPathName filesep name '_registered.tif']  )
disp('Done!')