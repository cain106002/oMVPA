function varargout = MVPA_GUI2(varargin)
% MVPA_GUI2 M-file for MVPA_GUI2.fig
%      MVPA_GUI2, by itself, creates a new MVPA_GUI2 or raises the existing
%      singleton*.
%
%      H = MVPA_GUI2 returns the handle to a new MVPA_GUI2 or the handle to
%      the existing singleton*.
%
%      MVPA_GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MVPA_GUI2.M with the given input arguments.
%
%      MVPA_GUI2('Property','Value',...) creates a new MVPA_GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MVPA_GUI2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MVPA_GUI2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MVPA_GUI2

% Last Modified by GUIDE v2.5 19-Oct-2016 14:42:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MVPA_GUI2_OpeningFcn, ...
                   'gui_OutputFcn',  @MVPA_GUI2_OutputFcn, ...
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


% --- Executes just before MVPA_GUI2 is made visible.
function MVPA_GUI2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MVPA_GUI2 (see VARARGIN)

% Choose default command line output for MVPA_GUI2
handles.output = hObject;
handles.bP=varargin(1);
handles.labelDir=varargin(2);
label=load(handles.labelDir{1,1});
label(label==-1)=0;
handles.label=label;
handles.score_predict=varargin(3);
fid=fopen([handles.bP{1,1},filesep,'acc_report.txt']);
Content=fscanf(fid,'%s');
idx=strfind(Content,'%');
str0='Result Show:';
str1=Content(1:idx(1));str2=Content(idx(1)+1:idx(2));str3=Content(idx(2)+1:end);
str1=[str1(1:4),' ',str1(5:end)];str2=[str2(1:8),' ',str2(9:10),' ',str2(11:end)];
str3=[str3(1:8),' ',str3(9:10),' ',str3(11:end)];
str0=[str0,10];
str1=[str1,10];
str2=[str2,10];
str3=[str3];
str = [str0,str1,str2,str3];
set(handles.resultshow,'String',str);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MVPA_GUI2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MVPA_GUI2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ROCP.
function ROCP_Callback(hObject, eventdata, handles)
% hObject    handle to ROCP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
label=handles.label;
score_predict=handles.score_predict{1,1};hFigure=figure('visible','on');
plotroc(label',score_predict');

% --- Executes on button press in smri.
function smri_Callback(hObject, eventdata, handles)
% hObject    handle to smri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mvpapath=which('mvpa.m');
path1=mvpapath(1:end-6);
path2=handles.bP{1,1};
eval(['!',path1,'mricron\mricron',' ',path1,'mricron\templates\ch2.nii.gz',' ', '-overlay',' ',path2,'\consensus_feature.nii']);
 

% --- Executes on button press in closed.
function closed_Callback(hObject, eventdata, handles)
% hObject    handle to closed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);


function resultshow_Callback(hObject, eventdata, handles)
% hObject    handle to resultshow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resultshow as text
%        str2double(get(hObject,'String')) returns contents of resultshow as a double


% --- Executes during object creation, after setting all properties.
function resultshow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resultshow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over resultshow.
function resultshow_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to resultshow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
