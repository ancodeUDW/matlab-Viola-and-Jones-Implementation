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

    %% load the modules
    % the modules are loaded inside the program adding their paths.
    load_modules('matlab'); % here we have functions and classes
    
    %% load the haar-like feature list
    load('matlab/variables/haar_like_features_with_limitations.mat', 'all_haar_like_types');
    
    %% load the result: best classifiers
    load('matlab/variables/best_classifiers_face.mat', 'weak_classifiers', 'best_classifiers');
    
    %% creates the GUI
%     h = adaboost_results;
%     % gets the GUI handles
%     my_handle = get(h);
%     handles=guidata(h);
%     set (handles.results_table, 'Data', result_table);



    %% create and save the strong classifier
    my_strong_classifier = strong_classifier(all_haar_like_types, weak_classifiers, best_classifiers);
    
    %% test strong classifier
    pos_image_folder = 'img/faces/test set/positives';
    % pos_images_test_list = get_image_list(pos_image_folder); 
    my_true = 1;
    
    neg_image_folder = 'img/faces/test set/negatives';
    % neg_images_test_list = get_image_list(neg_image_folder);
    my_false = 0;
    
    % test positive set
    [error_rate_faces, num_error_faces, total_set_faces, image_errors_face] = test_list_with_sc(my_strong_classifier, pos_image_folder, my_true);
    [error_rate_no_faces, num_error_no_faces, total_set_no_faces, image_errors_no_face] = test_list_with_sc(my_strong_classifier, neg_image_folder, my_false);
    
    disp(['pos error rate: ' int2str(error_rate_faces*100) '% num errors: ' num_error_faces]);
    disp(['neg error rate: ' int2str(error_rate_no_faces*100) '% num errors: ' num_error_no_faces]);
    disp([]);
    total_error_rate = ( num_error_faces + num_error_no_faces ) / (total_set_faces + total_set_no_faces);
    disp(['->  total error rate: ' int2str(total_error_rate*100) '%']);

    my_strong_classifier.plot_all_haar_like_diff_windows();
    
    save('matlab/variables/strong_classifier.mat', 'my_strong_classifier');