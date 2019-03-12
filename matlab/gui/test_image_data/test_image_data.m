function varargout = test_image_data(varargin)
% TEST_IMAGE_DATA MATLAB code for test_image_data.fig
%      TEST_IMAGE_DATA, by itself, creates a new TEST_IMAGE_DATA or raises the existing
%      singleton*.
%
%      H = TEST_IMAGE_DATA returns the handle to a new TEST_IMAGE_DATA or the handle to
%      the existing singleton*.
%
%      TEST_IMAGE_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_IMAGE_DATA.M with the given input arguments.
%
%      TEST_IMAGE_DATA('Property','Value',...) creates a new TEST_IMAGE_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_image_data_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_image_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_image_data

% Last Modified by GUIDE v2.5 16-Jan-2015 20:18:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_image_data_OpeningFcn, ...
                   'gui_OutputFcn',  @test_image_data_OutputFcn, ...
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


% --- Executes just before test_image_data is made visible.
function test_image_data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test_image_data (see VARARGIN)

% Choose default command line output for test_image_data
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test_image_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_image_data_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in corrected_weight.
function corrected_weight_Callback(hObject, eventdata, handles)
% hObject    handle to corrected_weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns corrected_weight contents as cell array
%        contents{get(hObject,'Value')} returns selected item from corrected_weight


% --- Executes during object creation, after setting all properties.
function corrected_weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to corrected_weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in normalized_weight.
function normalized_weight_Callback(hObject, eventdata, handles)
% hObject    handle to normalized_weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns normalized_weight contents as cell array
%        contents{get(hObject,'Value')} returns selected item from normalized_weight


% --- Executes during object creation, after setting all properties.
function normalized_weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to normalized_weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in original_weight.
function original_weight_Callback(hObject, eventdata, handles)
% hObject    handle to original_weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns original_weight contents as cell array
%        contents{get(hObject,'Value')} returns selected item from original_weight


% --- Executes during object creation, after setting all properties.
function original_weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to original_weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
