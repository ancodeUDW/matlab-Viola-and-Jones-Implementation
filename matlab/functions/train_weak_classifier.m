%% function train_weak_classifier
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 14/01/2015
% * *Version*: 0.1

%% TRAIN_WEAK_CLASSIFIER trains a weak classifier
%   trains a weak classifier to get its optimal theshold

%% added positive_hl_values_sorted and negative_hl_values_sorted
function [my_threshold, my_alpha, w_c_results, my_alert, error_counter, my_error_rate, positive_hl_values_sorted, negative_hl_values_sorted]...
                     = train_weak_classifier(hl_feat, img_pack)%, my_feature_bar)
    % PARAMETERS
    %
    % haar_like_feature: NOT a class, but a list of values with the info
    % of a haar-like feature. It follow the following order
    %
    %     [(pos x), (pos y), (height), (width), (type of feature)]
    %
    % img_pack: List of address where you can find the images we need
    % to do the test. Those images must be integral images, and we need to
    % calculate them behorefand in order to save calculation time in the
    % training
    
    % RETURN
    %
    % my_threshold: the optimal threshold we have calculated
    % my_alpha: how the threshold have to be compared
    %           my_alpha*my_threshold <= my_alpha*value_to_classify;
    % my_error_value: the error rate this classifier had with the traing
    %                 set. <- it is not the proper way to do it, cuz here
    %                 we dont take in account the weights to make the
    %                 errors. :deprecated:
    % w_c_results: a list with the results when used with all the
    %              image_pack values
    
    
    
    %% Constants
    % here we will define the algorithm constants, used to improve the
    % undertanding of the code
    
    % the feat_ constants are sintactic sugar to know what component
    % belongs to what part of the haar_like_feat variable
    % (pos x), (pos y), (height), (width), (type of feature)
    % remember that this components must be used in the second coordinate
    % of the haar_like_feat variable, being the first, the number who
    % specify and identify one specific haar_ like 
    feat_pos_x = 1;
    feat_pos_y = 2;
    feat_width = 3;
    feat_height = 4;
    feat_type = 5;
    
    my_alert = 0;
    
    
    % we need to create our current haar_like feature
    my_current_feature = haar_like(...
                            [hl_feat(feat_pos_x) hl_feat(feat_pos_y)], ...  % start point
                            hl_feat(feat_width), ...  % unitary rectangle width
                            hl_feat(feat_height), ... % unitary rectangle height
                            hl_feat(feat_type) ...    % feature type
                        );
    
    if my_current_feature.valid
        % haar-like results of all the 'faces'. to be used when we search
        % for the optimal threshold
        positive_hl_values = zeros(1, img_pack.number_pos_images);

        % haar-like results of all the 'no faces'. To be used when we search
        % for the optimal threshold
        negative_hl_values = zeros(1, img_pack.number_neg_images);
        % list of results
        % image_testing_results = zeros(img_pack.number_images);

        % positive and negative counters
        i_pos = 1;
        i_neg = 1;

        for i=1:img_pack.number_images
            % we will load the image vector. we have to make it sure that is an
            % integral image before entering to the adaboost!
            % waitbar(i/img_pack.number_images, my_feature_bar, sprintf('%d of %d', i, img_pack.number_images))
            
            % if getappdata(my_feature_bar,'canceling')
                % we should add here a way to save the current state
                % also we should take care of loading the current state
                % break
            % end
            
            my_current_image = img_pack.return_image_i(i);

            if img_pack.image_is_positive(i) == 1
                % adds the value to the positive image values list
                positive_hl_values(i_pos) = my_current_feature.calc_haar_integral(my_current_image);
                i_pos = i_pos + 1;
            else
                % adds the value to the negative image values list
                negative_hl_values(i_neg) = my_current_feature.calc_haar_integral(my_current_image);
                i_neg = i_neg + 1;
            end

        end


        [my_alpha, my_threshold, positive_hl_values_sorted, negative_hl_values_sorted] = find_best_threshold(positive_hl_values, negative_hl_values);

        temp_class = weak_classifier(1, my_threshold, my_alpha);

        % the error rate must be calculated taking in account the image_weights
        % so my_error_rate is not valid here.
        [w_c_results, error_counter, my_error_rate] = temp_class.test_classifier( ...
                                     [positive_hl_values negative_hl_values]...
                                   );
%   in this case we wont ignore the ones with  error rate similar to luck
%
%         if my_error_rate > 47 && my_error_rate < 53
%             % in this case we discard this classifier for being too similar
%             % to luck.
%             my_alert = 1;
%         end

        % in this point we have the optimal treshold and we must get ready all
        % the return data
    else
        my_threshold = 1000000000;
        my_alpha = 1;
        w_c_results = zeros(1, img_pack.number_images);
        my_alert = 1;
        error_counter = -1;
        my_error_rate = 100;
    end
    
end



