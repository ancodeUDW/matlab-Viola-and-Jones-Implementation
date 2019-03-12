function [ classifier_result, percentage ] = ui_make_classifiers(results_type, results_data)
%UI_MAKE_CLASSIFIERS makes a classifier
%   Makes a classifier using the information we get as paramether
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
    load('matlab/variables/haar_like_features_with_limitations.mat', 'all_haar_like_types');
    load('matlab/variables/integral_images_list.mat', 'positive_ii_list', 'negative_ii_list');
    load('matlab/variables/total_adaboost_results.mat', 'weak_classifiers', 'best_classifiers');
    
    this_classifier = final_strong_classifier(all_haar_like_types, weak_classifiers, results_data(:,1));
    disp('a')
    img_pack = vj_image_data(positive_ii_list, negative_ii_list);
    disp('b')
    classifier_result = zeros(img_pack.number_images, 1);
    disp('c')
    real_result = zeros(img_pack.number_images, 1);
    
    for i=1:img_pack.number_images
        current_image = img_pack.return_image_i(i);
        classifier_result(i) = this_classifier.classify_integral_image(current_image);
        real_result(i) = img_pack.image_is_positive(i);
    end
    disp('e')
    
    
    % this_classifier.plot_all_haar_like();

    save(['final_result/classifier_' results_type '.mat'], 'this_classifier', 'classifier_result', 'real_result'); % save the status.
    
    classifier_result_values = classifier_result == real_result;
    classifier_result_values = sum(classifier_result_values); 
    percentage = classifier_result_values*100/img_pack.number_images;
    disp(percentage);
    
end

