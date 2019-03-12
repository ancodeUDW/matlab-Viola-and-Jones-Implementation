 %% Initialization
 % in this file we add all what we need to initializate in all the tests
 % from this folder.
 
    % Erase all the data and close all the windows one might find.
    close all;
    clear all; % depending on the case, we might need to not to apply this
    clc;
    
    % this variable should be defined depending the folder we are working
    % on. in this case we are in the test folders inside matlab folder. all
    % the imports should be done taking in account that project root adress
    % is the root of the project itself.
    project_root_adress = '..\..\'; % we define the root of the project here so we
                            % can import things properly

    % load the modules
    % load the function load_modules that will automate the process of
    % loading all the parts of the project. All the executable scripts
    % should have this part.
    addpath([project_root_adress 'matlab']);
   
    % the modules are loaded inside the program adding their paths.
    load_modules([project_root_adress 'matlab\functions']); % here we have functions and classes
    load_modules([project_root_adress 'img']); % here we have the images
    load_modules([project_root_adress 'img\examples']); % here we have the images
    load_modules([project_root_adress 'matlab\gui']); % graphical user interface
    load_modules([project_root_adress 'matlab\classes']); % classes we will be using in the program
    load_modules([project_root_adress 'matlab\variables']); % classes we will be using in the program
    clear project_root_adress; % we wont be needed this variable anymore so
                               % better to keep the workspace organized 

