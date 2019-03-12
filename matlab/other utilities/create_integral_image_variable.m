%% Creation of the integral images
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 04/01/2015
% * *Version*: 1.0
%%
% In this file we will create all the integral images and store them in an
% individual .mat files. in order to store and load integral images, we
% have created the ii_store and ii_load functions, so we will be using that
% in the adaboost algorithm

    %% Initialization
    % Erase all the data and close all the windows one might find.
    close all;
    %clear all;
    clc;
    
    %% load the modules
    % the modules are loaded inside the program adding their paths.
    
    load_modules('matlab'); % here we have functions and classes
    load_modules('img'); % here we have the images
    
    % we will load all the images from the folder img/test set/negative and
    % positive and we will store them inside a variable (fix the adaboost
    % to get the variable instead of a file)
    
    % positive list:

    % Replace pos_image_list(1,1) with pos_image_list{1,1}. You access the contents of a cell-array with {}. You access the cell element itself with ().
        
    [pos_image_list, pos_image_list_counter] = get_image_list('img/faces/training set/faces');
    positive_ii_list = create_ii_variables('img/integral images/faces/', pos_image_list, pos_image_list_counter);
    
    [neg_image_list, neg_image_list_counter] = get_image_list('img/faces/training set/no_faces');
    negative_ii_list = create_ii_variables('img/integral images/no_faces/', neg_image_list, neg_image_list_counter);

    save('integral_images_list.mat', 'positive_ii_list', 'negative_ii_list');
       