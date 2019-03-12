%% vj_image_data test
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 04/01/2015
% * *Version*: 1.0
%%
% In this file some test on images and the Haar-like features will be done.

    %% Initialization
    % in system_ini we initializate the system. For initialization we mean
    % close all windows, clear all variables, clean the screen and and add
    % some libraries so we dan access to all functions from the project.
    run('system_ini')
    
    %%
    weak_class_list = weak_classifier_list();

    % to add we need the following: 
    %
    %   *hl identification
    %   *threshold
    %   *alpha,
    %   *error rate
    %
    weak_class_list = weak_class_list.add_classifier(1, 434, 1, 1);
    weak_class_list = weak_class_list.add_classifier(2, 4434, 1, 0.5);
    weak_class_list = weak_class_list.add_classifier(3, 44, -1, 0.3);
    weak_class_list = weak_class_list.add_classifier(33, 4345534, -1, 0.55);
    
    for i = 1:weak_class_list.list_size
        weak_class_list.print_all_info(i);
        test = [weak_class_list.get_haar_like_code(i) weak_class_list.get_threshold(i) weak_class_list.get_error_rate(i)]
    end