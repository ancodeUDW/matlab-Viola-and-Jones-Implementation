classdef weak_classifier
    %WEAK_CLASSIFIER Abstraction of a weak classifier
    %   this function abstracts a weak classifier in the project. For a
    %   weak classifier, we mean a classifier that uses only one haar like
    %   feature, and its classification of a face or a non-face is
    %   marginally better than luck
    %
    %   in this case, to a value to be tested as face, it should be bigger
    %   than the threshold.
    
    properties
        haar_like_code = -1;
        threshold = 0;
        actual_threshold = 0; % to avoid to do the alpha * threshold operation each time
        alpha = 1;
        % study if adding the weight too.
    end
    
    methods
        function obj = weak_classifier(haar_like_code, threshold, alpha)
            obj.haar_like_code = haar_like_code;
            obj.threshold = threshold;
            obj.actual_threshold = threshold*alpha;
            obj.alpha = alpha;
        end
        
        % given a value, tells if it is a face or not depending of its
        % value and comparing it with alpha*theshold
        %
        % its used as sintactic sugar for test_value. That is because its
        % name is not intuitive, but some parts of the project still use
        % it. Both functions are likely to be merged when fixing the
        % project
        function res = classify_value(obj, value_to_classify)
            res = test_value(obj, value_to_classify);
        end
        
        % return the result of the classification of a value according to
        % our threshold and alpha. By default, a value must be bigger than
        % the threshold to be considered a face,
        % but for the other case around, we switch directions using the
        % alpha
        function res = test_value(obj, value_to_classify)    
            res = obj.alpha*value_to_classify >= obj.actual_threshold;
        end
        
        % prints the internal values of this weak classifier in the screen.
        % used as a reference
        function print_values(obj)
            print_values_in_screen('haar like code:       ', obj.haar_like_code);
            print_values_in_screen('threshold:             ', obj.threshold);
            print_values_in_screen('actual_threshold:   ', obj.actual_threshold);
            print_values_in_screen('alpha:                   ', obj.alpha);            
        end
           
        % return the results and the error rate of a haar-like value list
        % compared to our threshold and alpha
        % value_list must be of the way
        %       [ a b c d e f ...etc]
        % that we know all are faces.
        % so every zero we get will be an error
        % my_error_rate is deprecated
        function [w_c_results, error_counter, my_error_rate] = test_classifier(obj, value_list)
            [~, size_list] = size(value_list);
            
            w_c_results = zeros(1, size_list);
            
            error_counter = 0;
            
            for i=1:size_list
                w_c_results(i) = obj.test_value(value_list(i));
                if ~w_c_results(i)
                    error_counter = error_counter + 1;
                end
            end
            
            my_error_rate = error_counter*100 / size_list; % not the real error
            
        end
    end
    
end

function print_values_in_screen(string_code, int_value)
    % auxiliar function to print values in screen. it makes it easier to
    % print int or numerical values with an added string at the beggining
    print_values = [string_code, num2str(int_value)];
    disp(print_values)
end

