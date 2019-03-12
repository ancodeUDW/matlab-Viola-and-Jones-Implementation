function [ classifier_test_case_result, classifier_real_classification, percentage, acumulative_classifier_result_values ] = ui_test_classifiers(classifier_adress)
%UI_MAKE_CLASSIFIERS makes a classifier
%   test a classifier against the test set
%
% *results_type: is the type of classifier we have (Complete, Absolute,
% Positive). Mainly used for the name when saving the classifiers
% * reult_data: have the information we will use to make the classifier. In
% particular it is a matrix whose columns are the haar like code and the
% weight we will use to make the classifier
    
    addpath('../..');
    addpath('matlab');
   
    % load the modules
    % the modules are loaded inside the program adding their paths.
    %
    load_modules('matlab'); % here we have functions and classes
    load_modules('img'); % here we have the images

    % load('matlab/variables/haar_like_features_with_limitations.mat', 'all_haar_like_types');
    % load('matlab/variables/integral_images_list.mat', 'positive_ii_list', 'negative_ii_list');
    load(classifier_adress, 'this_classifier');
    
    [pos_image_list, pos_image_list_counter] = get_image_list('img/faces/test set/faces');
    % [positive_ii_list, positive_ii_identifier] = create_ii_variables('img/integral images/faces/', pos_image_list, pos_image_list_counter);
    
    [neg_image_list, neg_image_list_counter] = get_image_list('img/faces/test set/no faces'); % name is important, to fix later
    total_num_images = pos_image_list_counter + neg_image_list_counter;
    % [negative_ii_list, negative_ii_identifier] = create_ii_variables('img/integral images/no_faces/', neg_image_list, neg_image_list_counter);
    
    % img_pack = vj_image_data(positive_ii_list, negative_ii_list);
    classifier_test_case_result = zeros(total_num_images, 1);
    classifier_real_classification = zeros(total_num_images, 1);
    acumulative_result = zeros(this_classifier.list_size, total_num_images); % needed to do the graph
    acumulative_result_percentage = zeros(this_classifier.list_size);
    
    for i=1:pos_image_list_counter
         % loads the image and makes them ii
        my_image_address = pos_image_list{:,i};
        [my_image, is_useful] = create_standard_image(my_image_address);
        
        [classifier_test_case_result(i), acumulative_result(:, i)] = this_classifier.classify_normal_image(my_image);
        classifier_real_classification(i) = 1;
    end
    
    for i=1:neg_image_list_counter
         % loads the image and makes them ii
        my_image_address = neg_image_list{:,i};
        [my_image, is_useful] = create_standard_image(my_image_address);
        
        [classifier_test_case_result(pos_image_list_counter+i), acumulative_result(:, pos_image_list_counter+i) ] = this_classifier.classify_normal_image(my_image);
        classifier_real_classification(pos_image_list_counter+i) = -1;
    end
    

    classifier_result_values = classifier_test_case_result == classifier_real_classification;
    classifier_result_values = sum(classifier_result_values); 
    percentage = classifier_result_values*100/total_num_images;
    
    acumulative_result_values = acumulative_result*0;
    acumulative_classifier_result_values = zeros(this_classifier.list_size, 1);
    
    for i = 1:this_classifier.list_size
        acumulative_result_values(i,:) = acumulative_result(i,:) == classifier_real_classification';
        acumulative_classifier_result_values(i) = sum(acumulative_result_values(i,:))*100/total_num_images; 
    end
    
end

