%% class strong_classifier ENDGAME
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 07/05/2016
% * *Version*: 1.0

% this is the final strong classifier, made of weak_classifiers

classdef strong_classifier
    %WEAK_CLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        list_size = 0
        % haar_like components: we cant have all the haar-like features
        % loaded here, so we will load only the ones we need
        haar_like_code = -1;
        haar_like_start_point;
        haar_like_unitary_rec_width;
        haar_like_unitary_rec_height;
        haar_like_type;
        
        % each of the weak classifiers info
        threshold = -1;
        alpha = 0;
        error_rate = -1;
        
        % individual classifier weight in the classification
        wc_weight = 0;
    end
    
    methods
        %% creation of the object.
        % initialites the object with all the data we need.
        function obj = strong_classifier(...
                   all_haar_like_types, weak_classifiers, best_classifiers)
            % num of weak_classifiers we will use   
            obj.list_size = obj.my_size_list(best_classifiers);
            
            % weak classifiers data initialization
            obj.haar_like_code = zeros(obj.list_size,1);
            obj.haar_like_start_point = zeros(obj.list_size, 2);
            obj.haar_like_unitary_rec_width = zeros(obj.list_size, 1);
            obj.haar_like_unitary_rec_height = zeros(obj.list_size, 1);
            obj.haar_like_type = zeros(obj.list_size, 1);
            obj.threshold = zeros(obj.list_size, 1);
            obj.alpha = zeros(obj.list_size, 1);
            obj.error_rate = zeros(obj.list_size, 1);
            obj.wc_weight = zeros(obj.list_size, 1);

            % filling the weak_classifiers data
            for i=1:obj.list_size
                current_classifier = best_classifiers(i);
                
                % initialite the classifier list
                obj.haar_like_code(i) = current_classifier;
                obj.haar_like_start_point(i,:) = ...
                           [all_haar_like_types(current_classifier, 1) all_haar_like_types(current_classifier, 2)];
                obj.haar_like_unitary_rec_width(i) = all_haar_like_types(current_classifier, 3);
                obj.haar_like_unitary_rec_height(i) = all_haar_like_types(current_classifier, 4);
                obj.haar_like_type(i) = all_haar_like_types(current_classifier, 5);
                obj.threshold(i) = weak_classifiers.get_threshold(current_classifier);
                obj.alpha(i) = weak_classifiers.get_alpha(current_classifier);
                obj.error_rate(i) = weak_classifiers.get_error_rate(current_classifier);
                obj.wc_weight(i) = obj.calcule_wc_weight(obj.error_rate(i));
            end

        end
        
        %% test_classifier_i
        % creates a classifier with the info of the i weak classifer and
        % test an integral image out of it.
        function res = test_classifier_i(obj, i, i_image)
            my_current_feature = haar_like(...
                obj.haar_like_start_point(i,:), ...      % start point
                obj.haar_like_unitary_rec_width(i), ...  % unitary rectangle width
                obj.haar_like_unitary_rec_height(i), ... % unitary rectangle height
                obj.haar_like_type(i) ...                % feature type
            );
                        
            if my_current_feature.valid
                h_l_value = my_current_feature.calc_haar_integral(i_image);
                my_current_weak_classifier = weak_classifier(           ...
                                                  obj.haar_like_code(i),...
                                                  obj.threshold(i),     ...
                                                  obj.alpha(i));
                                              
                % returns true or false depending if the value results
                % face.
                res = my_current_weak_classifier.test_value(h_l_value);
                
            else
                res = 0;
                disp(['the feature ' i ' is not valid']);
            end
        
        end

        function [res] = classify_image(obj, my_image)
            my_iimage = integralImage(my_image);
            s_c_alhpa_t = 0;
            add_weak_class = 0;
            
            for i=1:obj.list_size
                % calcule the strong classifier comparator for this step
                s_c_alhpa_t = s_c_alhpa_t + obj.wc_weight(i);
                % test the classifier
                if obj.test_classifier_i(i, my_iimage)
                    %disp(['code:' num2str(obj.haar_like_code(i)) ' weight:' num2str(obj.wc_weight(i)) ' thinks IS a face']);
                    add_weak_class = add_weak_class + obj.wc_weight(i);
                else
                    %disp(['code:' num2str(obj.haar_like_code(i)) ' weight:' num2str(obj.wc_weight(i)) ' thinks IS NOT a face']);
                end
                
            end
            
            res = add_weak_class >= s_c_alhpa_t/2;
        end
        
        function res = return_haar_like(obj, i)
            res = haar_like(...
                    obj.haar_like_start_point(i,:), ...      % start point
                    obj.haar_like_unitary_rec_width(i), ...  % unitary rectangle width
                    obj.haar_like_unitary_rec_height(i), ... % unitary rectangle height
                    obj.haar_like_type(i) ...                % feature type
                );       
        end
        
        %% plot_all_haar_like
        % plot all the haar_like features in the same window
        function plot_all_haar_like(obj)
            recToPlot='haar like figure';
            
            for i=1:obj.list_size
                my_current_feature = obj.return_haar_like(i);
                if i == 1
                    main_square = my_current_feature.return_grid_rectangle();
                     % plot everything
                    figure

                    % an square symbolizing the image
                    plot( main_square(:,1), main_square(:,2),...
                          'LineWidth',2); 
                    hold on;
                    grid on;
                end
                
                % haar-like rectangles
                my_rec_black = my_current_feature.black_rec();
                my_rec_white = my_current_feature.white_rec();
                
                % the white rectangle
                for j=1:my_current_feature.get_rect_size(my_rec_white)
                    my_current_feature.get_rect_size(my_rec_white)
                    my_uni_rec = my_current_feature.get_rect_list(my_rec_white, j);
                    plot(my_uni_rec(:,1), my_uni_rec(:,2),...
                         'color', 'black',...   
                         'LineWidth',2);    
                end


                % the black rectangle
                for j=1:my_current_feature.get_rect_size(my_rec_black)
                    my_uni_rec = my_current_feature.get_rect_list(my_rec_black, j);
                    plot(my_uni_rec(:,1), my_uni_rec(:,2),...
                         'color', 'black',...   
                         'LineWidth',2);

                    h=fill(my_uni_rec(:,1), my_uni_rec(:,2));
                    set(h,'FaceColor','black');
                end

            end
            
            title(recToPlot);
            
            set(gca,'YDir','Reverse') % makes the axis reverse like images
            axis square % makes the proportions fit
            
            % plot(myRec, 'Color', 'red');
            y_labels = 0:1:26;
            axis([0,26,0,26])
            set(gca, 'YTickLabel', y_labels);
            set(gca, 'XTickLabel', y_labels);
            set(gca,'xtick', y_labels);
            set(gca,'ytick', y_labels);
            
            hold off;
            
        end    
        
        %% plot_all_haar_like
        % plot all the haar_like features in images
        function plot_haar_like_i(obj, i)
            my_current_feature = haar_like(...
                obj.haar_like_start_point(i,:), ...      % start point
                obj.haar_like_unitary_rec_width(i), ...  % unitary rectangle width
                obj.haar_like_unitary_rec_height(i), ... % unitary rectangle height
                obj.haar_like_type(i) ...                % feature type
            );
            
            if i==1
                figure;
                recToPlot='Strong classifier';
                title(recToPlot);
                my_current_feature.plot_main_grid();
                hold on;
            elseif i==obj.list_size
                hold off;
            end
            
            my_current_feature.plot_black_rectangle();
            my_current_feature.plot_white_rectangle();
        
        end
        
        
        %% plot_all_haar_like_diff_windows
        % plot all the haar_like features in different windows
        function plot_all_haar_like_diff_windows(obj)
            for i=1:obj.list_size
                obj.plot_haar_like_i_diff_windows(i);
            end
        end
        
        %% plot_all_haar_like
        % plot all the haar_like features in images
        function plot_haar_like_i_diff_windows(obj, i)
            my_current_feature = haar_like(...
                obj.haar_like_start_point(i,:), ...      % start point
                obj.haar_like_unitary_rec_width(i), ...  % unitary rectangle width
                obj.haar_like_unitary_rec_height(i), ... % unitary rectangle height
                obj.haar_like_type(i) ...                % feature type
            );
            
            my_current_feature.plot_rectangle();
        
        end
        
    end
  
    methods(Static)
        %% my_size_list
        % simple way to get the size of a list in this class. Just
        % sintactic sugar.
        function res = my_size_list(my_list)
            num_class = size(my_list);
            res = num_class(1);
        end
        
        %% calcule_wc_weight
        % value needed to calculate the final result, the weight of a weak
        % classifier
        function res = calcule_wc_weight(my_error_rate)
            my_beta = my_error_rate / (1 - my_error_rate);
            res = log(1/my_beta);
        end 
    end
    
end

