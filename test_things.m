    % load the modules
    % the modules are loaded inside the program adding their paths.
    %
    clear all;
    close all;
    addpath('matlab');
    load_modules('matlab'); % here we have functions and classes
    load('matlab/variables/haar_like_features_with_limitations.mat', 'all_haar_like_types');
    load('matlab/variables/integral_images_list.mat', 'positive_ii_list', 'negative_ii_list', 'positive_ii_identifier', 'negative_ii_identifier');
    % if an error keep a bar open this will close it
    % close_all_taskbars

    %%
    
    img_pack = vj_image_data(positive_ii_list, negative_ii_list);
    num_it = 1000;
    num_img = img_pack.number_images;
    
    check_results = zeros(num_it, num_img);
    weight_results = zeros(num_it, num_img);
    
    threshold_lists = zeros(num_it, 1);
    alpha_lists = threshold_lists;
    rate_fail = threshold_lists;
    
    faces_values =  zeros(num_it, img_pack.number_pos_images);
    no_faces_values =  zeros(num_it,  img_pack.number_pos_images);
    
    for i = 1:num_it
        
        [my_threshold, my_alpha, image_testing_results, my_alert, num_fails, fail_rate, temp_faces_values, temp_no_faces_values] = ...
                train_weak_classifier(all_haar_like_types(i, :), img_pack); %, my_feature_bar);
        
        threshold_lists(i,1) = my_threshold;
        alpha_lists(i,1) = my_alpha;
        rate_fail(i,1) = fail_rate;
        
        check_results(i, :) = image_testing_results(1,1:num_img);
        faces_values(i, :) = temp_faces_values;
        no_faces_values(i, :) = temp_no_faces_values;

        [img_pack, current_weight] = img_pack.update_weights_standard(...
                            image_testing_results...
                            );
         
         weight_results(i, :) = img_pack.image_weight(1:num_img, 1);
        
    end

 
%% show the weights in a visual way
% close all
close all;
i = 900;

show_training_result(faces_values(i,:), no_faces_values(i,:), alpha_lists(i), threshold_lists(i), [100-rate_fail(i); alpha_lists(i)]);



                        
%% training test
this_no_faces = [16, 17 18 25];
this_faces  = [6 7 8 9 10 11 12 13 14 15 155 ];

[my_alpha, my_threshold] = find_best_threshold(this_faces, this_no_faces);

show_training_result(this_faces, this_no_faces, my_alpha,my_threshold, 'test');



%% 16 tiene una alta tasa de error

faces_lab = ones(size(this_faces));
non_faces_lab = zeros(size(this_no_faces));

fish_discr = fitcdiscr([this_faces this_no_faces]', [faces_lab non_faces_lab]');

mean_faces = mean(this_faces);
mean_no_faces = mean(this_no_faces);

var_faces= var(this_faces);
var_no_faces = var(this_no_faces);

V  = ((mean_faces - mean_no_faces)^2) / (var_faces + var_no_faces)