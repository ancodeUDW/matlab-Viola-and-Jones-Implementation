%% class strong_classifier ENDGAME
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 24/05/2016
% * *Version*: 1.0

% this is the final strong classifier, made from a set of weak_classifiers
classdef final_strong_classifier
    %WEAK_CLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        list_size = 0
        % haar_like components: we cant have all the haar-like features
        % loaded here, so we will load only the ones we need
        haar_like_code = -1;
        wc_weight = 0; % in this version will clone the error rate from adaboost
        haar_like_pack = {}
        weak_classifier_pack = {}        
    end
    
    methods
        %% creation of the object.
        % initialites the object with all the data we need.
        function obj = final_strong_classifier(...
                                                       all_haar_like_types, ...
                                                       weak_classifiers, ...
                                                       best_classifiers ...
                                                   )
              %% all_haar_like_types: 
              % have a list of all the haar_like types we will create the
              % classifier from
              %% weak_classifiers:
              % have a list of all the weak classifiers generated and
              % selected by the boosting algorithm
              %% best_classifiers:
              % got the list of all the best classifiers by is haar_like
              % code. Must note that teh weak classifiers haar like
              % identificator might not coincide with its number in the
              % list.
            
            % best_classifiers list can be a matrix or a vector. if it is a
            % vetor, its ok, but if it is a matrix, we should get only the
            % first column.
            [y_size, x_size] = size(best_classifiers);
            
            if x_size > 1
                % we have a matrix with the hl codes and the weights
                best_classifiers = best_classifiers(:,1);  % this way we will have the vector we want.
            end
              
            % num of weak_classifiers we will use 
            obj.list_size = y_size;
            
            % weak classifiers data initialization
            obj.weak_classifier_pack = {};
            obj.haar_like_pack = {};
            obj.haar_like_code = zeros(obj.list_size,1);
            obj.wc_weight = zeros(obj.list_size, 1);
            


            % filling the weak_classifiers data
            for i=1:obj.list_size
                % in best_classifiers(i) we have the haar like codes, but
                % we dont know where they are
                % so we ask to the list itself what is the index we should
                % use.                
                
                %% normal variables
                current_haar_like_code = best_classifiers(i);
                current_classifier = weak_classifiers.get_hl_index(current_haar_like_code);

                obj.haar_like_code(i) = best_classifiers(i);
                obj.wc_weight(i) = weak_classifiers.get_error_rate(current_classifier);
                
                %% special classes inside here
                
                % haar like stuff, using variables because it can be
                % confusing to put all of this in the creation of the
                % haar_like object.
                haar_like_start_point = ...
                           [all_haar_like_types(current_haar_like_code, 1) all_haar_like_types(current_haar_like_code, 2)];
                haar_like_unitary_rec_width = all_haar_like_types(current_haar_like_code, 3);
                haar_like_unitary_rec_height = all_haar_like_types(current_haar_like_code, 4);
                haar_like_type = all_haar_like_types(current_haar_like_code, 5);
                
                obj.haar_like_pack{i} = haar_like( ...
                                                    haar_like_start_point, ...
                                                    haar_like_unitary_rec_width, ...
                                                    haar_like_unitary_rec_height, ...
                                                    haar_like_type ...
                                                );
                                            
                obj.weak_classifier_pack{i} = weak_classifiers.return_weak_classifier(current_classifier);

            end

        end
        
        %% test_classifier_i
        % test an integral image to see if it is a face or not
        function res = test_classifier_i(obj, i, i_image)                       
            if obj.haar_like_pack{i}.valid
                h_l_value = obj.haar_like_pack{i}.calc_haar_integral(i_image);
                                             
                % returns true or false depending if the value results
                % face.
                res = obj.weak_classifier_pack{i}.test_value(h_l_value);
                
            else
                res = 0;
                disp(['the feature ' i ' is not valid']);
            end
        
        end

        %% classify image
        % returns true if the image is a face, false if i isn't, using all
        % the classifiers of this object. non integral image version
        function [res, my_accumulative_result] = classify_normal_image(obj, my_image)
            my_iimage = integralImage(my_image);
            [res, my_accumulative_result] = obj.classify_integral_image(my_iimage);            
        end
        
        %% classify image
        % returns true if the image is a face, false if i isn't, using all
        % the classifiers of this object. integral image version
        function [res, my_accumulative_result] = classify_integral_image(obj, my_iimage)
            
            my_result = 0;
            my_accumulative_result = zeros(obj.list_size, 1); % we will also return a vector of values with the result for each step of the classification.
            
            for i=1:obj.list_size
                % test the classifier
                if obj.test_classifier_i(i, my_iimage) > 0
                    % in this new version this should be 1 or -1, but the
                    % weak classifier does 1 or 0
                    % current_result = 1;
                    my_result = my_result + obj.wc_weight(i);
                else
                    % current_result = -1;
                    my_result = my_result - obj.wc_weight(i);
                end
                
                % write the acumulative result
                if my_result < 0
                    % the result is negative, so its a  no face
                    my_accumulative_result(i) = -1;
                else
                    % the result is positive, so its a face
                    my_accumulative_result(i) = 1;
                end
            end
            
            
            if my_result < 0
                % the result is negative, so its a  no face
                res = -1;
            else
                % the result is positive, so its a face
                res = 1;
            end
            
        end
        
        
        %% return_haar_like
        % returns the haar_like info from the classifier i
        function res = return_haar_like(obj, i)
            res = obj.haar_like_pack{i};
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

                    h=area(my_uni_rec(:,1), my_uni_rec(:,2));
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
            my_current_feature = obj.return_haar_like(i);
            
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
            my_current_feature = obj.return_haar_like(i);
            
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
    end
end

