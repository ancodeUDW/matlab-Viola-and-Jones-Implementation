%% LOAD MODULES
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 04/01/2015
% * *Version*: 1.0

%%
% This module is in charge of loading all the modules inside the folders we
% introduce as parameters. This is due those folders having other folders
% to better organize the program.
function load_modules(myDir)
    % first we load the current directory to the path
    load_to_path(myDir);
    
    % check if this directory have other directory inside and add them (and
    % their children directories) to the path
    check_children_dir(myDir);
end

%% check children dir
% Checks if the current dir have other dirs, and make a recursive call to
% add them and their children to the path.
function check_children_dir(myDir)
    % Get the directory list in 
    moduleDir=dir(myDir);
    % print_all_folders(moduleDir);
    n = size(moduleDir,1);
    
    % use a recursive function to load all the folders inside myDir. It
    % ends when there are no more directories inside of myDir or its
    % children
    for i=1:n(1)
        currentDir=moduleDir(i);
        if (is_a_folder(currentDir)) 
            % The current file in the list is a folder
            load_modules(strcat(myDir,'/', currentDir.name));
        end
    end

end

%% is a folder
% checks if a name is a directory and if it is not the current directory
% '.' - nor the parent directorry '..'
function res=is_a_folder(currentDir)
    dirName=currentDir.name; % this variable exist just as sintactic sugar
    res=currentDir.isdir && ~strcmp(dirName, '.') && ~strcmp(dirName, '..');
end

%% load to path
% loads a modules to the path, so it can be used by the program
function load_to_path(myAdress)
    addpath([pwd strcat('/', myAdress)]);
end

%% print all folders
% function that works to print all the folders in one directory that has
% been given as a parameter. This is done for testing purposes, and should
% be not used in the final version of this program
function print_all_folders(currentDir)
    n = size(currentDir,1)
    for i=1:n(1)
        currentDir.name
    end
end
