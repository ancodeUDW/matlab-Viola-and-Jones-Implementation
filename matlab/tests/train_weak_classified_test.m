%% train weak classifier test
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 18/01/2015
% * *Version*: 1.0
%%
% train weak classifier test
    %% Initialization
    % in system_ini we initializate the system. For initialization we mean
    % close all windows, clear all variables, clean the screen and and add
    % some libraries so we dan access to all functions from the project.
    run('system_ini');
 
    %% initialize the variables we will use to train the classifier

    file_name = 'matlab/variables/haar_like_features_with_limitations.mat';
    load(file_name, 'all_haar_like_types');
    
    file_name = 'matlab/variables/integral_images_list.mat';
    load(file_name);
    
    %% create the img_pack, using the pos and neg integral images list   
    img_pack = vj_image_data(positive_ii_list, negative_ii_list);
    
    %% gets one haar_like_type to do the test
    hl_feat = all_haar_like_types(500,:); 
    
    %% exectue the fucntion and its showtime
    [my_threshold, my_alpha, w_c_results] = train_weak_classifier(hl_feat, img_pack)


