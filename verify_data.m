function [ feat_pos_x_list ] = verify_data(  )
%VERIFY_DATA verify that the data inside a strong classifier
%   the strong classifier have some data inside. this function was created
%   to verify it is correct and consistent with the haar like code assigned
%   to it.

    % initialization
    addpath('matlab');
    load_modules('matlab');
    % load info:
    load('final_result/classifier_Absolute.mat');
    load('matlab\variables\haar_like_features_with_limitations.mat', 'all_haar_like_types');
    
   
    feat_pos_x_list = zeros(this_classifier.list_size, 1);
    feat_pos_y_list = zeros(this_classifier.list_size, 1);
    feat_width_y_list = zeros(this_classifier.list_size, 1);
    feat_height_y_list = zeros(this_classifier.list_size, 1);
    feat_type_y_list = zeros(this_classifier.list_size, 1);

    
    for i=1:this_classifier.list_size
        
        current_feature_id = this_classifier.haar_like_code(i);
        current_feature_from_com = this_classifier.haar_like_pack{i}; % classifier info
        current_feature_real = all_haar_like_types(current_feature_id, :); % real info
        
        feat_pos_x_list(i) = compare_feature_with_data(current_feature_from_com, current_feature_real);
    end
    
    feat_pos_x_list
end

function res = compare_feature_with_data(hl_class, hl_vector)
% compares the data from one haar like feature with the hl data inside a weak
% classifier.
    % constants that say what is what in the variable "all_haar_like_types"
    feat_pos_x = 1;
    feat_pos_y = 2;
    feat_width = 3;
    feat_height = 4;
    feat_type = 5;
    
    res = 1;
    
    if hl_class.type ~=hl_vector(feat_type)
        res = 0;
    elseif hl_class.start_point ~= [hl_vector(feat_pos_x) hl_vector(feat_pos_y)]
        res = 0;
    elseif hl_class.my_width ~= hl_vector(feat_width)
        res = 0;
    elseif hl_class.my_height ~= hl_vector(feat_height)
        res = 0;
    end
end