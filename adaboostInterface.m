function varargout = adaboostInterface(varargin)
    % ADABOOSTINTERFACE MATLAB code for adaboostInterface.fig
    %      ADABOOSTINTERFACE, by itself, creates a new ADABOOSTINTERFACE or raises the existing
    %      singleton*.
    %
    %      H = ADABOOSTINTERFACE returns the handle to a new ADABOOSTINTERFACE or the handle to
    %      the existing singleton*.
    %
    %      ADABOOSTINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in ADABOOSTINTERFACE.M with the given input arguments.
    %
    %      ADABOOSTINTERFACE('Property','Value',...) creates a new ADABOOSTINTERFACE or raises
    %      the existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before adaboostInterface_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to adaboostInterface_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help adaboostInterface

    % Last Modified by GUIDE v2.5 11-May-2016 00:07:33

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @adaboostInterface_OpeningFcn, ...
                       'gui_OutputFcn',  @adaboostInterface_OutputFcn, ...
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
end

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
    % If the metricdata field is present and the showAllResults flag is false, it means
    % we are we are just re-initializing a GUI by calling it from the cmd line
    % while it is up. So, bail out as we dont want to showAllResults the data.

    % Update handles structure
    guidata(handles.figure1, handles);
    addpath('matlab');
    load_modules('matlab'); % here we have functions and classes
end

% --- Executes just before adaboostInterface is made visible.
function adaboostInterface_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to adaboostInterface (see VARARGIN)

    % Choose default command line output for adaboostInterface
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    initialize_gui(hObject, handles, false);

    % UIWAIT makes adaboostInterface wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = adaboostInterface_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end

% --- Executes on button press in trainAdaboost.
% starts an adaboost training with the images we have stored in variables
% before in the folder img
function trainAdaboost_Callback(hObject, eventdata, handles)
    % hObject    handle to trainAdaboost (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % get ready the variables for adaboost
    emptyMessage(handles);
    displayStatistics =  get(handles.displayStadistics, 'Value');
    checkSavestate = get(handles.checkSavestate, 'Value');
    savePeriodically =  get(handles.savePeriodically, 'Value');
    saveWhenClosing = get(handles.saveWhenClosing, 'Value');
    
    % start adaboost. it will save the state in the proper place.
    ui_calculate_best_weak_classifiers(checkSavestate, displayStatistics, savePeriodically, saveWhenClosing);
    
end

% --- Executes on button press in showAllResults.
function showAllResults_Callback(hObject, eventdata, handles)
    % hObject    handle to showAllResults (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    emptyMessage(handles)
    
    [res, size_result, data_results] = ui_check_results('all');
    
    if res
        set(handles.sizeResultList, 'String', size_result);
        set(handles.classVisualizationTable, 'Data', data_results);
        set(handles.classVisualizationTable, 'Visible', 'On');
        set(handles.typeOfClassifier, 'Visible', 'On');
        set(handles.typeOfClassifier, 'String', 'Complete');
    else
        set(handles.uiMessages, 'String', 'There has been an error loading the data');
    end
end


% --- Executes on button press in topBestPositive.
function topBestPositive_Callback(hObject, eventdata, handles)
    % hObject    handle to topBestPositive (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    emptyMessage(handles)
    
    numberOfClassifiers =  str2num(get(handles.numClass, 'String'));
    
    if ~numberOfClassifiers
        numberOfClassifiers = 23;
    end
    
    
    [res, size_result, data_results] = ui_check_results('best_positive', numberOfClassifiers);
    
    if res
        set(handles.sizeResultList, 'String', size_result);
        set(handles.classVisualizationTable, 'Data', data_results);
        set(handles.classVisualizationTable, 'Visible', 'On');
        set(handles.typeOfClassifier, 'Visible', 'On');
        set(handles.typeOfClassifier, 'String', 'Positive');
    else
        set(handles.uiMessages, 'String', 'There has been an error loading the data');
    end
end

% --- Executes on button press in topBestAbsolute.
function topBestAbsolute_Callback(hObject, eventdata, handles)
    % hObject    handle to topBestAbsolute (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    emptyMessage(handles)
    
    numberOfClassifiers =  get(handles.numClass, 'String');
    numberOfClassifiers = str2double(numberOfClassifiers);
    
    if ~numberOfClassifiers
        numberOfClassifiers = 23;
    end
    
    [res, size_result, data_results] = ui_check_results('best_all', numberOfClassifiers);
    
    if res
        set(handles.sizeResultList, 'String', size_result);
        set(handles.classVisualizationTable, 'Data', data_results);
        set(handles.classVisualizationTable, 'Visible', 'On');
        set(handles.typeOfClassifier, 'Visible', 'On');
        set(handles.typeOfClassifier, 'String', 'Absolute');
    else
        sendMessage(handles, 'There has been an error loading the data');
    end    
end

% --- Executes on button press in haarLikeVisualization.
function haarLikeVisualization_Callback(hObject, eventdata, handles)
    % hObject    handle to haarLikeVisualization (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    emptyMessage(handles)
    
    hl_code = get(handles.inputHaarLikeCode, 'String');
    hl_code = str2double(hl_code);
    
    if hl_code
        sendMessage(handles, ['calculating harr like code for ', num2str(hl_code)]);
        my_plot = ui_show_haarLike(hl_code);
        % my_adress = 'img/samples/temporalplot';
        % hgexport(my_plot, my_adress);
    else
        sendMessage(handles, 'There has been an error loading the data');
    end
end


function sendMessage(handles, msn)
    % write a message in the output
    set(handles.uiMessages, 'String', msn);
end

function emptyMessage(handles)
    set(handles.uiMessages, 'String', 'loading');
end

function inputHaarLikeCode_Callback(hObject, eventdata, handles)
    % hObject    handle to inputHaarLikeCode (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of inputHaarLikeCode as text
    %        str2double(get(hObject,'String')) returns contents of inputHaarLikeCode as a double
end

% --- Executes during object creation, after setting all properties.
function inputHaarLikeCode_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to inputHaarLikeCode (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.

end


% --- Executes on button press in displayStadistics.
function displayStadistics_Callback(hObject, eventdata, handles)
% hObject    handle to displayStadistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of displayStadistics
end

% --- Executes on button press in checkSavestate.
function checkSavestate_Callback(hObject, eventdata, handles)
% hObject    handle to checkSavestate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkSavestate
end

% --- Executes on button press in savePeriodically.
function savePeriodically_Callback(hObject, eventdata, handles)
    % hObject    handle to savePeriodically (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of savePeriodically
end


% --- Executes on button press in saveWhenClosing.
function saveWhenClosing_Callback(hObject, eventdata, handles)
    % hObject    handle to saveWhenClosing (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of saveWhenClosing
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in makeClassifier. make a classifier with
% the current data found in the table
function makeClassifier_Callback(hObject, eventdata, handles)
% hObject    handle to makeClassifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    emptyMessage(handles);
    results_type = get(handles.typeOfClassifier, 'String');
    
    if ~strcmp(results_type, '-' )
        classifier_data = get(handles.classVisualizationTable, 'Data');
        [ classifier_result, percentage ] = ui_make_classifiers(results_type, classifier_data);
        sendMessage(handles, ['results using TRAINING set; ' int2str(percentage) '% (success)']);
        figure();
        bar(classifier_result);
    else
        sendMessage(handles, 'No data ready for making the classifier, select number of classifiers');
    end  
end

% --- Executes on button press in testClassifier. test the classifier using
% all the data from the table.
function testClassifier_Callback(hObject, eventdata, handles)
% hObject    handle to testClassifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    emptyMessage(handles);
    results_type = get(handles.typeOfClassifier, 'String');
    
    if ~strcmp(results_type, '-' )
        classifier_to_load = ['final_result/classifier_' results_type '.mat'];
        
        if exist(classifier_to_load)
            [ classifier_test_case_result, classifier_real_classification, percentage, acumulative_result ] = ui_test_classifiers(classifier_to_load);
            sendMessage(handles, ['results using the TEST set; ' int2str(percentage) '% (success)']);
            % sendMessage(handles, ['The classifier was successful a ' int2str(percentage) '% of the times']);
            filename = 'cumulative_value.mat';
            save(filename, 'acumulative_result');
            figure();
            plot(acumulative_result);
            ylabel('% of success');
            xlabel('num of classifiers used');
            figure();
            bar(classifier_test_case_result);
        else
            sendMessage(handles, 'the classifier doesnt exist');
        end
    end    
end



function numClass_Callback(hObject, eventdata, handles)
    % hObject    handle to numClass (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of numClass as text
    %        str2double(get(hObject,'String')) returns contents of numClass as a double
end

% --- Executes during object creation, after setting all properties.
function numClass_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to numClass (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in createIntegralImages. Creates the
% integral images from the folder img/training set
function createIntegralImages_Callback(hObject, eventdata, handles)
% hObject    handle to createIntegralImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    emptyMessage(handles)
    [message] = ui_create_integral_image_variable();
    sendMessage(handles, message);
end
