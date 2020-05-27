function varargout = ProjectGUI(varargin)
% PROJECTGUI MATLAB code for ProjectGUI.fig
%      PROJECTGUI, by itself, creates a new PROJECTGUI or raises the existing
%      singleton*.
%
%      H = PROJECTGUI returns the handle to a new PROJECTGUI or the handle to
%      the existing singleton*.
%
%      PROJECTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECTGUI.M with the given input arguments.
%
%      PROJECTGUI('Property','Value',...) creates a new PROJECTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ProjectGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ProjectGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ProjectGUI

% Last Modified by GUIDE v2.5 07-Jan-2018 16:48:08

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ProjectGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ProjectGUI_OutputFcn, ...
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


% --- Executes just before ProjectGUI is made visible.

function ProjectGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ProjectGUI (see VARARGIN)

%initialize array of x and y on capture points
handles.check = 0; %variable used for check when start to take the points during the draw
handles.check2 = 0; %used for stop the capture of points when you have already draw the function
handles.check3 = 0; %used for pass to 3dplot in 2dplot when clicking "Capture Points" button

handles.x_array = [];
handles.y_array = [];
handles.z = -40;

y=0;
load('handel.mat','y','Fs');
handles.y = y;

handles.ind = 1;

handles.date = [100;-100;-75;-50;-25;0;25;50;75];

%initialize default plot of circumference
t = 0:0.01:2*pi; 
x = 20*cos(t); 
y = 20*sin(t); 
z = zeros(length(t));
handles.axes1 = plot3(x,y,z);

% setting frequency
handles.freq_low = 8192;
handles.freq_high = 65536;
handles.freq = handles.freq_low;

% setting prebuilt function
handles.circumference = 1;
handles.helix = 2;
handles.custom = 3;
handles.prebuilt = handles.circumference;

[handles.OT,handles.T,handles.X,handles.N]=create_offline_info;  %Create the octree based on the triplets [azi,ele,dist] of the PKU-IOA HRTF database

% Choose default command line output for ProjectGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ProjectGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ProjectGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in capturepoints_button.
function capturepoints_button_Callback(hObject, eventdata, handles)
% hObject    handle to capturepoints_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newplot

plot(0,0,'k.');
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
set(gca,'XTickLabel', handles.date);
set(gca,'YTickLabel', handles.date);
handles.check2 = 1;
handles.check = 0;
handles.x_array = [];
handles.y_array = [];
handles.ind = 1;
handles.prebuilt = handles.custom;
guidata(hObject, handles);


% --- Executes on selection change in elev_popupmenu.
function elev_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to elev_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns elev_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from elev_popupmenu
val = get(hObject,'Value');
switch val
    case 1
        handles.z = -40;
    case 2
        handles.z = -30;
    case 3
        handles.z = -20;
    case 4
        handles.z = -10;
    case 5
        handles.z = 0;
    case 6
        handles.z = 10;
    case 7
        handles.z = 20;
    case 8
        handles.z = 30;
    case 9
        handles.z = 40;
    case 10
        handles.z = 50;
    case 11
        handles.z = 60;
    case 12
        handles.z = 70;
    case 13
        handles.z = 80;
    case 14
        handles.z = 90;
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function elev_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elev_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in circumference_pushbutton.
function circumference_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to circumference_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.check2 = 0;
handles.check = 0;

newplot

t = 0:0.01:2*pi; 
x = 20*cos(t); 
y = 20*sin(t); 
z = zeros(length(t));
handles.axes1 = plot3(x,y,z);

handles.prebuilt = handles.circumference;

guidata(hObject,handles);


% --- Executes on button press in helix_pushbutton.
function helix_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to helix_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.check = 0;
handles.check2 = 0;

newplot

t = 0:0.1:4*pi; 
x = 20*cos(t); 
y = 20*sin(t); 
handles.axes1 = plot3(x,y,t);

handles.prebuilt = handles.helix;

guidata(hObject,handles);


% --- Executes on button press in apply_pushbutton.
function apply_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to apply_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.freq == 8192
    dim_sampling = 128;
else
    dim_sampling = 1024;
end
switch handles.prebuilt
    
    case 1
        w = [];
        Main_program(w,1,handles.y,handles.freq,dim_sampling,handles.OT,handles.T,handles.X,handles.N);
    
    case 2
        w = [];
        Main_program(w,2,handles.y,handles.freq,dim_sampling,handles.OT,handles.T,handles.X,handles.N);
        
    case 3
        w = [];
        w(:,1) = handles.x_array;
        w(:,2) = handles.y_array;
        w(:,3) = handles.z;
       
        Main_program(w,3,handles.y,handles.freq,dim_sampling,handles.OT,handles.T,handles.X,handles.N);
end

% --- Executes on button press in freq_low.
function freq_low_Callback(hObject, eventdata, handles)
% hObject    handle to freq_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of freq_low

handles.freq = handles.freq_low;
guidata(hObject,handles);


% --- Executes on button press in freq_high.
function freq_high_Callback(hObject, eventdata, handles)
% hObject    handle to freq_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of freq_high
handles.freq = handles.freq_high;
guidata(hObject,handles);


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.check == 1
    
    pos = get(gca, 'CurrentPoint'); % get mouse location on figure
    x = pos(1,1); y = pos(1,2); % assign locations to x and y
    x = x*100;
    y = y*100;
    
    handles.x_array(handles.ind) = x;
    handles.y_array(handles.ind) = y;
    
    handles.ind = handles.ind +1;
    guidata(hObject, handles);  
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.check2 == 1
    handles.check = 1;
    pos = get(gca, 'CurrentPoint'); % get mouse location on figure
    x = pos(1,1); y = pos(1,2); % assign locations to x and y
    x = x*100;
    y = y*100;

    handles.x_array(handles.ind) = x;
    handles.y_array(handles.ind) = y;
    handles.ind = handles.ind + 1;
    guidata(hObject, handles);
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.check2 == 1
handles.check2 = 0;
handles.check = 0;
pos = get(gca, 'CurrentPoint'); % get mouse location on figure
x = pos(1,1); y = pos(1,2);% assign locations to x and y
x = x*100;
y = y*100;
handles.x_array(handles.ind) = x;
handles.y_array(handles.ind) = y;
guidata(hObject, handles);

[theta,rho] = cart2pol(handles.x_array,handles.y_array);
%theta = rad2deg(theta);
%theta = mod((90-theta),360);
%theta = deg2rad(theta);

handles.axes1 = polarplot(theta,rho);

end


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1

% --- Executes on selection change in audio_popupmenu.
function audio_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to audio_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns audio_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from audio_popupmenu
val = get(hObject,'Value');
switch val
    case 1
        load('handel.mat','y','Fs');
        handles.y = y;
        guidata(hObject, handles);
           
    case 2
        load('gong.mat','y','Fs');
        handles.y = y;
        guidata(hObject, handles);
        
    case 3
        y = audioread('speech_dft.mp3');
        y = resample(y,8192,22500);
        handles.y = y;
        guidata(hObject, handles);
        
    case 4
        y = audioread('/YOUR_PATH/HRTF_interpolation_convolution/audio samples/drums.wav');
        y = resample(y,8192,44100);
        handles.y = y;
        guidata(hObject, handles);
    case 5
        y = audioread('/YOUR_PATH/HRTF_interpolation_convolution/audio samples/guitar.wav');
        y = resample(y,8192,44100);
        handles.y = y;
        guidata(hObject, handles);
        
        
        
        
end

% --- Executes during object creation, after setting all properties.
function audio_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to audio_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
