%% class vj_image_data
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 14/01/2015
% * *Version*: 1.0

%% vj_image_data
% a file that implements the images and all the values they have
% associated, with the functions to get, set those values, and update them
% depending of our situation. Note: vj stands for viola and jones
classdef vj_image_data
    properties(Constant)
        % this constants are used as a syntactic sugar.
        is_negative = -1;
        is_positive =  1;
        correct_class = 1; % is necessary?
        wrong_class = 2; % is necessary?
        correct_tested = 1
        incorrect_tested = 0
    end
    
    properties
        % the acual values of this class. They are initializated to zero
        image_pack = ['none' 'none'];
        image_weight = 0;
        number_images = 0;
        number_pos_images = 0;
        number_neg_images = 0;
    end
    
    methods
        %% creation of the object
        % creates the vj_image_data object. A sample_image objects is an
        % objects with all the data belonging to the image set:
        %
        % PARAMETERS:
        % pos_images: list of the integral images that are "faces"
        % neg_images: list of the integral images that aren't "faces"
        %
        % INTERNAL VARIABLES:
        %
        % image_pack = list of the name of the integral images we will use
        %              They are considered the image_pack
        % number_pos_images = number of images that are "faces"
        % number_neg_images = nunmber of images that aren't "faces"
        % number_images = the total lenght of the image_pack vector
        % weights = for each image, their weight to measure the importance
        %           it will have with the current weak classificator
        function obj=vj_image_data(pos_images, neg_images)
            % maybe we will have to include somethign that checks that both
            % pos_images and neg_images are vectors in the fashion we need.
            obj.image_pack = [pos_images neg_images];
            obj.number_pos_images = obj.sample_img_size(pos_images);
            obj.number_neg_images = obj.sample_img_size(neg_images);
            obj.number_images = obj.number_pos_images + obj.number_neg_images;
            obj.image_weight = obj.init_weights();    
        end
        
        %% norm_weights
        % Normalize the weights so they become a probability distribution
        % VALIDATE THAT THIS WORKS AS INTENDED
        function image_weight=norm_weights(obj)
            cumulative_weight = sum(obj.image_weight);
            image_weight = obj.image_weight / cumulative_weight;
        end
        
        %% init_weights
        % gives the first value to the weights, so they can start to be
        % used
        function image_weight = init_weights(obj)
           obj.image_weight = ones(obj.number_images, 1)./obj.number_images;
           image_weight = obj.image_weight;
        end
        
        function res = stadistics_figure(obj, h)
            % creates a bar with the weight of the images
                my_bars = [obj.image_weight(1:obj.number_pos_images); obj.image_weight(obj.number_pos_images:end)]; % show in 2 groups so we can see them in different colors
                if nargin < 2
                    res = bar(my_bars);
                else
                    set(h, 'YData', my_bars);
                end
        end

        %% check weighted error probability
        function res = check_weighted_error_probability(obj, image_testing_results)
            % returns the weighted error probability
            error_list = image_testing_results == obj.incorrect_tested;
            res = sum(obj.image_weight(error_list));
        end
        
        %% update_weights
        % gives the first value to the weights, so they can start to be
        % used
        function [obj, current_weight]=update_weights_standard(obj, image_testing_results)
            % The purpose of setting variable beta is NOT to always
            % increase the weight, but rather to decrease/penalize the
            % weight only if the particular weak classifier is a good one    
            err = obj.check_weighted_error_probability(image_testing_results);
            
            current_weight =(1/2) * log((1-err) / max(err,eps)); % maybe the alpha will be beter to get it later
            % so, the error will give a log + if smaller than 0.5 (luck),
            % and - if bigger than 0.5. for an error of 0.5, we get 0 and
            % the weights will not change.
            
            if exp(current_weight) ~= 1 % if we get "luck" at one point there is no reason why we should do this loop. before it was current_weight == 0, but it didnt quite work properly
                for i = 1:length(image_testing_results)
                    if image_testing_results(i) == obj.incorrect_tested
                        % if the image has been incorrectly classified, we
                        % increase the weight
                        obj.image_weight(i) = obj.image_weight(i)* exp(current_weight);
                    else
                        % if the image has been correctly classified, we
                        % decrease the weight
                        obj.image_weight(i) = obj.image_weight(i)* exp(-current_weight);
                    end
                end
            end
            
            
            % here we make it a distribution
            obj.image_weight = obj.image_weight./sum(obj.image_weight);
        end
        
        
        %% update_weights
        % gives the first value to the weights, so they can start to be
        % used
        function obj=update_weights(obj, error_value, image_testing_results)
            % The purpose of setting variable beta is NOT to always
            % increase the weight, but rather to decrease/penalize the
            % weight only if the particular weak classifier is a good one 
            % (I will explain what is considered good in a moment) and to 
            % increase/boost the weight if the classifier is a bad one. 
            % (Keep in mind that the weight here is the weight of the error
            % rate not the weight of each classifier, so the better the
            % classifier is, the less weight there should be)

            % Apparently you can have different ways to define what is a
            % "good" classifier, but in Viola and Jones paper a very simple
            % criteria is used, that is, if the error rate of the weak 
            % classifier is less than 50%, it is "good", otherwise it is 
            % "bad". The better the classifier is(the smaller the error 
            % rate is), we want to boost the weight more, and vice versa. 
            % Up to now you should have a feeling of why the beta value is 
            % selected this way -- whenever the error rate(epsilon_e) is 
            % greater than 1/2, the beta value will be greater than 1 and
            % thus the weight will be boosted and vice versa.
            
            % so this is designed to be in percentages or in total errors?
            my_beta = error_value/(1-error_value);
            
            % so beta will be only active if the classification was
            % correct, modifiying the weight depending of the error of the 
            % weak classifier: if the error was smaller than 0.5, then
            % the weight of this image is decreased. If it was bigger, then
            % the image weight is increased.
            %
            % the fact that a correct classified image error weight was
            % increased
            %
            %. if there was an error, no
            % weight is modified.
            
            for i=1:obj.number_images
                if image_testing_results(i) == obj.correct_tested
                    obj.image_weight(i) = obj.image_weight(i) * my_beta;                    
                end
            end
            
        end
        
        %% evaluate_error
        % evaluates the error using a vector with the results and the
        % weights
        function my_error = evaluate_error(obj, image_testing_results)
            % The error is evaluated with respect of the image weights.
            my_error = 0;
            
            for i=1:obj.number_images
                if image_testing_results(i) == obj.incorrect_tested
                    % there has been an error, so we must add the error
                    % value.
                    my_error = my_error + obj.image_weight(i);
                end
            end
        end
        
                
        %% evaluate_error
        % evaluates the error using a vector with the results and the
        % weights
        function my_error_rate = evaluate_error_rate(obj, image_testing_results)
            % The error is evaluated with respect of the image weights.
            
            my_error_rate = length(image_testing_results(image_testing_results==obj.incorrect_tested));
            
        end
        
        %% validate_i_range
        % tells if a value i is inside the number of elements that are in
        % the image pack and can be used to adress an element both in the
        % image and the weight.
        function res = validate_i_range(obj, i)
            res = i > 0 && i <= obj.number_images;
        end
     
                        
        %% return_image_i
        % returns the image_pack(i) value, if the i is inside the range of
        % the number of elements that image_pack have
        function res=return_image_i(obj, i)
            res = obj.return_image_i_name(i);
            if res ~= 0
                res = load_ii(res);
            end
        end
        
        
                
        %% return_image_i_name
        % returns the image_pack(i) value, if the i is inside the range of
        % the number of elements that image_pack have
        function res=return_image_i_name(obj, i)
            res = 0;
            if obj.validate_i_range(i)
                res = obj.image_pack{i};
            end
        end
        
        
        %% return_image_i
        % returns true if the image is positive (is a face), and false if 
        % the image is negative (is not a face)
        function res = image_is_positive(obj, i)
            res = 0;
            
            if obj.validate_i_range(i)
                % we dont really need to store this value in a variable,
                % can be calculated through the number of positive images,
                % that will be always the first ones in the pack
                if (i <= obj.number_pos_images)
                    res = obj.is_positive;
                else
                    res = obj.is_negative;
                end
            end
        end
        
        
        %% return_image_i
        % returns true if the image is positive (is a face), and false if 
        % the image is negative (is not a face)
        function res = return_image_weight(obj, i)
            res = 0;
            if obj.validate_i_range(i)
                res = obj.image_weight(i);
            end
        end
    end
    
    methods (Static)
        

        
        
        %% sample_img_size
        % gives the size of a sample_img pack.
        function res = sample_img_size(image_pack)
            % note: the integral images were done beforehand, and here we
            % have the adresses of all the integral images we have in the
            % database.
            my_size = size(image_pack);
            res = my_size(2);
        end
        
    end
    
end

