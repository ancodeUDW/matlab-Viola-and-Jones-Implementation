%% Check results calculations viola and jones
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 02/05/2016
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
    load('matlab/variables/total_adaboost_results.mat');
    
    %% Calculate best classifiers
    
    num_classif_needed = 23;
    best_classifiers = weak_classifiers.return_n_best_classifiers_indexes_new(num_classif_needed);

    real_result_table = zeros(num_classif_needed, 4);

    save('matlab/variables/total_adaboost_results.mat', 'weak_classifiers', 'result_list', 'best_classifiers');

    for i=1:num_classif_needed
        real_result_table(i,1) = best_classifiers(i);
        real_result_table(i,2) = weak_classifiers.get_haar_like_code(best_classifiers(i));
        real_result_table(i,3) = weak_classifiers.error_rate(best_classifiers(i));
        real_result_table(i,4) = weak_classifiers.alpha(best_classifiers(i));
    end



    