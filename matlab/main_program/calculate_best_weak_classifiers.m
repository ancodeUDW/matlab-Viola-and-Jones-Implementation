%% calculate best weak classifiers
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 19/01/2015
% * *Version*: 1.0
%%
% In this file some test on images and the Haar-like features will be done.

    %% Initialization
    % Erase all the data and close all the windows one might find.
    close all;
    clear all;
    clc;

    addpath('matlab');
   
    % load the modules
    % the modules are loaded inside the program adding their paths.
    %
    load_modules('matlab'); % here we have functions and classes
    load('matlab/variables/haar_like_features_with_limitations.mat', 'all_haar_like_types');
    load('matlab/variables/integral_images_list.mat', 'positive_ii_list', 'negative_ii_list');
    
    % if an error keep a bar open this will close it
    close_all_taskbars

    % greate the image pack
    img_pack = vj_image_data(positive_ii_list, negative_ii_list);
    
    %% creates the GUI
    % h = adaboost_results;
    % gets the GUI handles
    % my_handle = get(h);
    % handles=guidata(h);
    
    %% adaboost test, we will get 4 haar-like feature and do the test
    hl_feat = all_haar_like_types; %(1:50,:); 
    check_savestate = true;
    show_statistics = false;
    
    [weak_classifiers, result_list, continue_work] = adaboost(hl_feat, positive_ii_list, negative_ii_list, check_savestate, show_statistics); %, handles);
    
    %% get the results in the gui
    if continue_work
        
        num_classif_needed = 23;
        best_classifiers = weak_classifiers.return_n_best_classifiers_indexes(num_classif_needed);

        result_table = zeros(num_classif_needed, 2);

        save('matlab/variables/total_adaboost_results.mat', 'weak_classifiers', 'result_list', 'best_classifiers');

        for i=1:num_classif_needed
            result_table(i,1) = best_classifiers(i);
            result_table(i,2) = weak_classifiers.get_error_rate(best_classifiers(i));
        end
        
        disp('finished, saved in matlab/variables/total_adaboost_retults.mat');
        
    else
        % it has been established that we dont continue. But just in case,
        % we will save up the results
        save('matlab/variables/canceled_adaboost_results.mat', 'weak_classifiers', 'result_list');
        disp('didnt finish, saved the state and saved the pseudo results in matlab/variables/canceled_adaboost_results.mat');
    end
    
    % set (handles.results_table, 'Data', result_table);

    %% create and save the strong classifier
    % my_strong_classifier = strong_classifier(all_haar_like_types, weak_classifiers, best_classifiers);
    % save('matlab/variables/strong_classifier.mat', 'my_strong_classifier');