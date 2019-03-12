%% get all haar ñlike features
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 19/01/2015
% * *Version*: 1.0
%%
% in this file we will compute all the haar-like features.

    %% Initialization
    % Erase all the data and close all the windows one might find.
    close all;
    % clear all;
    clc;
    
    %% creates the GUI
    % h = test_image_data;
    % gets the GUI handles
    % my_handle = get(h);
    % handles=guidata(h);
    
    
    %% load the modules
    % the modules are loaded inside the program adding their paths.
    load_modules('matlab'); % here we have functions and classes
    load('matlab/variables/haar_like_features_with_limitations.mat', 'all_haar_like_types');

    size_haar_like = size(all_haar_like_types);
    size_haar_like = size_haar_like(1);
    size_haar_like = 1
    
    not_valid_haar_like = zeros(size_haar_like, 1);
    counter_non_valid = 1;
    
    for i=1:size_haar_like
       current_haar_like = haar_like([all_haar_like_types(i,1),all_haar_like_types(i,2)], all_haar_like_types(i,3), all_haar_like_types(i,4), all_haar_like_types(i,5)); %start_point, width, height, type 
       if current_haar_like.valid == 0
           not_valid_haar_like(counter_non_valid) = i;
           counter_non_valid = counter_non_valid + 1;
       end
    end
    
    i = 5959;
    current_haar_like = haar_like([all_haar_like_types(i,1),all_haar_like_types(i,2)], all_haar_like_types(i,3), all_haar_like_types(i,4), all_haar_like_types(i,5)); %start_point, width, height, type 
    
    current_haar_like.valid
    current_haar_like.plot_rectangle()

    
    
    %% haar-like class test
    % here we will access to some of the haar-like class options
    %                   [ ]
    %                   [#]    [ ][#]    [ ][#][ ]
    %                 type 1   type 2     type 3

    
    
%     'Calculation of num of Haar-like types 1,2,3. there are limitations'
%     s = haar_like([1,1], 1, 1, 1); %start_point, width, height, type
%     [object_type_1_num, object_type_1] = s.count_all_haar_like();
%     
%     s = haar_like([1,1], 1, 1, 2); %start_point, width, height, type
%     [object_type_2_num, object_type_2] = s.count_all_haar_like();
%     
%     s = haar_like([1,1], 1, 1, 3); %start_point, width, height, type
%     [object_type_3_num, object_type_3] = s.count_all_haar_like();
%     
%     all_haar_like_types = [object_type_1; object_type_2; object_type_3];
%     object_type_1_num
%     object_type_2_num
%     object_type_3_num
%     
%     total_number_haar_like_features = object_type_1_num + object_type_2_num + object_type_3_num
% 
%     save('haar_like_features_with_limitations.mat', 'all_haar_like_types','total_number_haar_like_features','object_type_1_num', 'object_type_2_num', 'object_type_3_num')
%     
