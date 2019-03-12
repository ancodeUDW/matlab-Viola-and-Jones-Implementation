function varargout = adaboost_results(varargin)
% ADABOOST_RESULTS MATLAB code for adaboost_results.fig
%      ADABOOST_RESULTS, by itself, creates a new ADABOOST_RESULTS or raises the existing
%      singleton*.
%
%      H = ADABOOST_RESULTS returns the handle to a new ADABOOST_RESULTS or the handle to
%      the existing singleton*.
%
%      ADABOOST_RESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADABOOST_RESULTS.M with the given input arguments.
%
%      ADABOOST_RESULTS('Property','Value',...) creates a new ADABOOST_RESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before adaboost_results_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to adaboost_results_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help adaboost_results

% Last Modified by GUIDE v2.5 19-Jan-2015 13:53:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @adaboost_results_OpeningFcn, ...
                   'gui_OutputFcn',  @adaboost_results_OutputFcn, ...
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


% --- Executes just before adaboost_results is made visible.
function adaboost_results_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to adaboost_results (see VARARGIN)

% Choose default command line output for adaboost_results
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes adaboost_results wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = adaboost_results_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in error_list.
function error_list_Callback(hObject, eventdata, handles)
% hObject    handle to error_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns error_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from error_list


% --- Executes during object creation, after setting all properties.
function error_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to error_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
