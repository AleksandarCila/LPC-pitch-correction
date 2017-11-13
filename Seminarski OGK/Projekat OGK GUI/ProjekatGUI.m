function varargout = ProjekatGUI(varargin)
% PROJEKATGUI MATLAB code for ProjekatGUI.fig
%      PROJEKATGUI, by itself, creates a new PROJEKATGUI or raises the existing
%      singleton*.
%
%      H = PROJEKATGUI returns the handle to a new PROJEKATGUI or the handle to
%      the existing singleton*.
%
%      PROJEKATGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJEKATGUI.M with the given input arguments.
%
%      PROJEKATGUI('Property','Value',...) creates a new PROJEKATGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ProjekatGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ProjekatGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ProjekatGUI

% Last Modified by GUIDE v2.5 16-Jun-2017 11:53:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ProjekatGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ProjekatGUI_OutputFcn, ...
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


% --- Executes just before ProjekatGUI is made visible.
function ProjekatGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ProjekatGUI (see VARARGIN)

% Choose default command line output for ProjekatGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ProjekatGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ProjekatGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadFile.
function loadFile_Callback(hObject, eventdata, handles)
% hObject    handle to loadFile (see GCBO)
[FileName,PathName,FilterIndex] = uigetfile('*.wav','Choose wave file to open');
file_name=sprintf('%s%s',PathName,FileName);
set(handles.nameOfFile,'String',FileName);
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,fs]=audioread(file_name);
set(handles.samplingFrequency,'String',num2str(fs));
T=str2num(get(handles.windowLength,'String'));
handles.T=T;
guidata(hObject,handles);
win_overlap=str2num(get(handles.overlapPercentage,'String'));
handles.win_overlap=win_overlap;
guidata(hObject,handles);
f0_original=pitch(x,fs,T,win_overlap);
plot(handles.pitchOriginal,(0:length(f0_original)-1)*(T/2000),f0_original);
xlabel(handles.pitchOriginal,'time(s)');
ylabel(handles.pitchOriginal,'pitch(Hz)');
handles.f0_original=f0_original;
guidata(hObject,handles);
handles.x=x;
guidata(hObject,handles);
mode=get(handles.sliderMode,'Value');
if(mode>=0.5)
    mode=1;
    set(handles.sliderMode,'Value',1);
elseif(mode<0.5)
    mode=0;
    set(handles.sliderMode,'Value',0);
end;
handles.mode=mode;
f0_corrected=correction(f0_original,mode);
plot(handles.pitchCorrected,(0:length(f0_corrected)-1)*(T/2000),f0_corrected);
xlabel(handles.pitchCorrected,'time(s)');
ylabel(handles.pitchCorrected,'pitch(Hz)');
handles.f0_corrected=f0_corrected;
guidata(hObject,handles);
ooa_overlap=str2num(get(handles.ooaNumber,'String'));
handles.ooa_overlap=ooa_overlap;
guidata(hObject,handles);
s=synthesis(x,f0_original,fs,T,win_overlap,ooa_overlap);
handles.s=s;
guidata(hObject,handles);
s_corrected=synthesis(x,f0_corrected,fs,T,win_overlap,ooa_overlap);
handles.s_corrected=s_corrected;
guidata(hObject,handles);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over loadFile.
function loadFile_ButtonDownFcn(hObject, eventdata, handles)

% hObject    handle to loadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in playOriginal.
function playOriginal_Callback(hObject, eventdata, handles)
% hObject    handle to playOriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs=str2num(get(handles.samplingFrequency,'String'));
sound(handles.s,fs);


% --- Executes on button press in playCorrected.
function playCorrected_Callback(hObject, eventdata, handles)
% hObject    handle to playCorrected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs=str2num(get(handles.samplingFrequency,'String'));
sound(handles.s_corrected,fs);

% --- Executes during object creation, after setting all properties.
function loadFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pitchOriginal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pitchOriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate pitchOriginal


% --- Executes on slider movement.
function sliderMode_Callback(hObject, eventdata, handles)
% hObject    handle to sliderMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f0_original=handles.f0_original;

if(get(handles.sliderMode,'Value')<0.5)
    set(handles.sliderMode,'Value',0);
    f0_corrected=correction(f0_original,get(handles.sliderMode,'Value'));
elseif(get(handles.sliderMode,'Value')>=0.5)
   set(handles.sliderMode,'Value',1);
   f0_corrected=correction(f0_original,get(handles.sliderMode,'Value'));
end;
T=handles.T;
plot(handles.pitchCorrected,(0:length(f0_corrected)-1)*(T/2000),f0_corrected);
xlabel(handles.pitchCorrected,'time(s)');
ylabel(handles.pitchCorrected,'pitch(Hz)');
handles.f0_corrected=f0_corrected;
guidata(hObject,handles);

handles.mode=get(handles.sliderMode,'Value');

fs=str2num(get(handles.samplingFrequency,'String'));
win_overlap=handles.win_overlap;
ooa_overlap=handles.ooa_overlap;
s_corrected=synthesis(handles.x,f0_corrected,fs,T,win_overlap,ooa_overlap);
handles.s_corrected=s_corrected;
guidata(hObject,handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function overlapPercentage_Callback(hObject, eventdata, handles)
% hObject    handle to overlapPercentage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
number=str2num(get(handles.overlapPercentage,'String'));
if(number<10)
    set(handles.overlapPercentage,'String',num2str(10));
elseif (number>75)
    set(handles.overlapPercentage,'String',num2str(75));
end;
handles.win_overlap=number;
guidata(hObject,handles);


T=handles.T;
fs=str2num(get(handles.samplingFrequency,'String'));
win_overlap=handles.win_overlap;
ooa_overlap=handles.ooa_overlap;


f0_original=pitch(handles.x,fs,T,win_overlap);
plot(handles.pitchOriginal,(0:length(f0_original)-1)*(T/2000),f0_original);
xlabel(handles.pitchOriginal,'time(s)');
ylabel(handles.pitchOriginal,'pitch(Hz)');
handles.f0_original=f0_original;
guidata(hObject,handles);

f0_corrected=correction(handles.f0_original,handles.mode);
handles.f0_corrected=f0_corrected;
guidata(hObject,handles);
plot(handles.pitchCorrected,(0:length(f0_corrected)-1)*(T/2000),f0_corrected);
xlabel(handles.pitchCorrected,'time(s)');
ylabel(handles.pitchCorrected,'pitch(Hz)');

s=synthesis(handles.x,f0_original,fs,T,win_overlap,ooa_overlap);
handles.s=s;
guidata(hObject,handles);

s_corrected=synthesis(handles.x,f0_corrected,fs,T,win_overlap,ooa_overlap);
handles.s_corrected=s_corrected;
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of overlapPercentage as text
%        str2double(get(hObject,'String')) returns contents of overlapPercentage as a double


% --- Executes during object creation, after setting all properties.
function overlapPercentage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to overlapPercentage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ooaNumber_Callback(hObject, eventdata, handles)
% hObject    handle to ooaNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
number=str2num(get(handles.ooaNumber,'String'));
if(number<1)
    set(handles.ooaNumber,'String',num2str(1));
elseif (number>6)
    set(handles.ooaNumber,'String',num2str(6));
end;
handles.ooa_overlap=number;
guidata(hObject,handles);



T=handles.T;
fs=str2num(get(handles.samplingFrequency,'String'));
win_overlap=handles.win_overlap;
ooa_overlap=handles.ooa_overlap;

f0_original=pitch(handles.x,fs,T,win_overlap);
plot(handles.pitchOriginal,(0:length(f0_original)-1)*(T/2000),f0_original);
xlabel(handles.pitchOriginal,'time(s)');
ylabel(handles.pitchOriginal,'pitch(Hz)');
handles.f0_original=f0_original;
guidata(hObject,handles);

f0_corrected=correction(handles.f0_original,handles.mode);
handles.f0_corrected=f0_corrected;
guidata(hObject,handles);
plot(handles.pitchCorrected,(0:length(f0_corrected)-1)*(T/2000),f0_corrected);
xlabel(handles.pitchCorrected,'time(s)');
ylabel(handles.pitchCorrected,'pitch(Hz)');

s=synthesis(handles.x,f0_original,fs,T,win_overlap,ooa_overlap);
handles.s=s;
guidata(hObject,handles);

s_corrected=synthesis(handles.x,f0_corrected,fs,T,win_overlap,ooa_overlap);
handles.s_corrected=s_corrected;
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of ooaNumber as text
%        str2double(get(hObject,'String')) returns contents of ooaNumber as a double


% --- Executes during object creation, after setting all properties.
function ooaNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ooaNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function windowLength_Callback(hObject, eventdata, handles)
% hObject    handle to windowLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
number=str2num(get(handles.windowLength,'String'));
if(number<5)
    set(handles.windowLength,'String',num2str(5));
elseif (number>40)
    set(handles.windowLength,'String',num2str(40));
end;
handles.T=number;
guidata(hObject,handles);


T=handles.T;
fs=str2num(get(handles.samplingFrequency,'String'));
win_overlap=handles.win_overlap;
ooa_overlap=handles.ooa_overlap;

f0_original=pitch(handles.x,fs,T,win_overlap);
plot(handles.pitchOriginal,(0:length(f0_original)-1)*(T/2000),f0_original);
xlabel(handles.pitchOriginal,'time(s)');
ylabel(handles.pitchOriginal,'pitch(Hz)');
handles.f0_original=f0_original;
guidata(hObject,handles);

f0_corrected=correction(handles.f0_original,handles.mode);
handles.f0_corrected=f0_corrected;
guidata(hObject,handles);
plot(handles.pitchCorrected,(0:length(f0_corrected)-1)*(T/2000),f0_corrected);
xlabel(handles.pitchCorrected,'time(s)');
ylabel(handles.pitchCorrected,'pitch(Hz)');

s=synthesis(handles.x,f0_original,fs,T,win_overlap,ooa_overlap);
handles.s=s;
guidata(hObject,handles);

s_corrected=synthesis(handles.x,f0_corrected,fs,T,win_overlap,ooa_overlap);
handles.s_corrected=s_corrected;
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of windowLength as text
%        str2double(get(hObject,'String')) returns contents of windowLength as a double


% --- Executes during object creation, after setting all properties.
function windowLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
