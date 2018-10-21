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

% Last Modified by GUIDE v2.5 20-Oct-2018 23:43:45

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

% Set StackGPS icon 
try
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame')
    javaFrame = get(hObject,'JavaFrame');
    javaFrame.setFigureIcon(javax.swing.ImageIcon('ICON.png'));
end

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

movegui(handles.figure1, 'northwest')

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

    [sg.fixedFileName sg.fixedPathName] = uigetfile('*.tif;*.tiff','Select the reference fixed image', sg.fixedPathName );

    if ~isequal(sg.fixedFileName,0)
        sg.fixed_image = tiffclassreader(fullfile(sg.fixedPathName,sg.fixedFileName),sg.channels);
        if sg.use_highpassfilt
            disp('Highpass filtering to allow registration based on local features...')
            sg.fixed_image_orig=sg.fixed_image;
            sg.fixed_image = highpassfilt3(sg.fixed_image,50);   % highpass filtering to allow registration based on local features
        end
        handles.edit11.String = sg.fixedFileName; 
        disp('Done loading target fixed image.')
    else
        warning('No target fixed image file.');
    end
    
    

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global sg
% GUI interface for selection of moving image file. 

    [sg.movingFileName sg.movingPathName] = uigetfile('*.tif;*.tiff','Select the current moving image', sg.movingPathName);

    if ~isequal(sg.movingFileName,0)
          sg.moving_image = tiffclassreader(fullfile(sg.movingPathName,sg.movingFileName),sg.channels);
          if sg.use_highpassfilt
            disp('Highpass filtering to allow registration based on local features...')
            sg.moving_image_orig=sg.moving_image;
            sg.moving_image = highpassfilt3(sg.moving_image,50);  % highpass filtering to allow registration based on local features
          end
          handles.edit12.String = sg.movingFileName;
          disp('Done loading moving image.')
    else
        warning('No moving file.');
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
text(60,200,'Fixed Image','backgroundcolor','none','FontSize',8,'parent',gca)
text(60,400,'Moving Image','backgroundcolor','none','FontSize',8,'parent',gca)
text(60,650,'          Pixel Size (Fixed)            Channel             Pixel Size (Moving)','backgroundcolor','none','FontSize',8,'parent',gca)
text(60,700,'      X             Y             Z             (0=all)              X            Y             Z             ','backgroundcolor','none','FontSize',8,'parent',gca)

text(60,1050,'              Linear Offset                                           Euler Angle Offset  ','backgroundcolor','none','FontSize',8,'parent',gca)
text(60,1100,'      X             Y             Z                                     X            Y             Z             ','backgroundcolor','none','FontSize',8,'parent',gca)

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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Starting registration...')
global sg
[sg.registered_image, sg.moving_image, sg.fixed_image, sg.transformation, sg.fit, sg.movingFileName, sg.fixedFileName ] = stackGPS( sg.moving_image, sg.fixed_image, sg.moving_res, sg.fixed_res, sg.channels, sg.use_highpassfilt);
handles.edit13.String=round(100*sg.transformation(4)/100);
handles.edit14.String=round(100*sg.transformation(5)/100);
handles.edit15.String=round(100*sg.transformation(6)/100);
handles.edit16.String=num2str(round(-10*sg.transformation(1)*360/pi/2)/10);
handles.edit17.String=num2str(round(-10*sg.transformation(2)*360/pi/2)/10);
handles.edit19.String=num2str(round(-10*sg.transformation(3)*360/pi/2)/10);
