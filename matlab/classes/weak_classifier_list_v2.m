%% class vj_image_data
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 01/05/2016
% * *Version*: 1.0

%% WEAK_CLASSIFIER_LIST contains a list of weak classifiers
%   contains a list of weak classifiers, with all their data: their
%   haar-like code (as they were given in the adaboost function), the
%   optimal threshold that separates faces from not faces and the
%   error_rate using the image samples. All are data that were given in
%   the adaboost algoritm - more specifically, in the train weak
%   classifier function. This list is an ORDERED list using the
%   error_rate as index to order it. This might change if this function
%   delays the algorithm too much.
classdef weak_classifier_list_v2
    
    properties(Constant)
        is_minor = -1;
        is_major = -2;
    end
    
    properties
        list_size = 0
        haar_like_code = -1;
        threshold = -1;
        alpha = 0;
        error_rate = -1; % aka "weight of the classifier" now
    end
    
    methods
        %% class creators
        % create instances of the class.
        function obj=weak_classifier_list_v2()
        end
        
        function obj = weak_classifier_list_init(obj, haar_like_code, threshold, alpha, error_rate)
            obj.list_size = 1;
            obj.haar_like_code = haar_like_code;
            obj.threshold = threshold;
            obj.error_rate = error_rate;
            obj.alpha = alpha;
        end
        
        %% add_classifier
        % adds the classifier to the list.
        function obj = add_classifier(obj, hl_code, thres, alpha, e_rate, c_weight)
            obj = obj.add_classifier_i_pos(hl_code, thres,  alpha, e_rate, obj.list_size+1);
        end
        
        function res = get_hl_index(obj, hl_code)
            % get the index that is correct for the current hl_code
            res = find(obj.haar_like_code==hl_code);
        end
        
        %% get_all_info
        % returns all the info from one weak classifier
        function res = get_all_info(obj, i)
            if obj.is_in_range(i)
                res = [obj.haar_like_code(i) obj.threshold(i) obj.alpha(i) obj.error_rate(i)];
            else
                res = [0 0 0];
            end
        end
        
        function res = print_all_info(obj, i)
            if obj.is_in_range(i)
                disp('')
                disp('this is the requested classifier data:');
                disp([' - haar like code:      ' int2str(obj.haar_like_code(i))]);
                disp([' - threshold:            ' int2str(obj.threshold(i))]);
                disp([' - alpha:                  ' int2str(obj.alpha(i))]);
                disp([' - error_rate:           ' int2str(obj.error_rate(i))]);
                
            else
                disp(['there is less than ' int2str(i) ' classifiers in the list']);
            end
        end
        
        %% get_alpha
        % returns info from one weak classifier
        function res = get_alpha(obj, i)
            if obj.is_in_range(i)
                res = obj.alpha(i);
            else
                res = 0;
            end
        end
        
        %% get_haar_like_code
        % returns info from one weak classifier
        function res = get_haar_like_code(obj, i)
            if obj.is_in_range(i)
                res = obj.haar_like_code(i);
            else
                res = 0;
            end
        end
        
        %% get_threshold
        % returns info from one weak classifier
        function res = get_threshold(obj, i)
            if obj.is_in_range(i)
                res = obj.threshold(i);
            else
                res = 0;
            end
        end
        
        %% get_error_rate
        % returns info from one weak classifier
        function res = get_error_rate(obj, i)
            if obj.is_in_range(i)
                res = obj.error_rate(i);
            else
                res = 0;
            end
        end
        
        %% return_weak_classifier
        % returns the weak classifier corresponding to the element i. the
        % weak classifier is a class in itself and have the means to solve
        % if a value belongs to the group 'face' or not. Check the
        % weak_classifier class
        function res = return_weak_classifier(obj, i)
            res = weak_classifier(obj.haar_like_code(i), obj.threshold(i), obj.alpha(i));%, obj.error_rate(i));
        end
        
        %% return_weak_classifier
        % returns the answer to the question "does this value belogs to the
        % a face depending of the weak_classifier i?
        function res = return_weak_classifier_result(obj, value_to_classify, i)
            w_c = weak_classifier(obj.haar_like_code(i),...
                                  obj.threshold(i),...
                                  obj.alpha(i),...
                                  obj.error_rate(i));
            res = w_c.class_value(value_to_classify);
        end

        %% add_classifier_i_pos
        % adds the data of a classifier inside the class
        function obj=add_classifier_i_pos(obj, hl_code, thres, alpha, e_rate, pos)
            if obj.list_size == 0;
                obj = obj.weak_classifier_list_init(hl_code, thres, alpha, e_rate);
            elseif obj.is_in_range_plus_one(pos)
                % we will only do our task if the pos is inside the range
                % or range plus minus one
                if pos == 1 || pos == 0 % we must prepend the object to the current list
                    obj.haar_like_code = [hl_code; obj.haar_like_code];
                    obj.threshold = [thres; obj.threshold];
                    obj.error_rate = [e_rate; obj.error_rate];
                    obj.alpha =  [alpha; obj.alpha];
                elseif pos == obj.list_size || pos == obj.list_size + 1 % we must append the current object to the lsit
                    obj.haar_like_code = [obj.haar_like_code; hl_code];
                    obj.threshold = [obj.threshold; thres];
                    obj.error_rate = [obj.error_rate; e_rate];
                    obj.alpha =  [obj.alpha; alpha];
                else % is inside the range 1-lenght, then we need to put the object in its position and put the 2 half parts in the corresponding place
                    obj.haar_like_code = [obj.haar_like_code(1:pos); hl_code; obj.haar_like_code(pos+1:obj.list_size)];
                    obj.threshold = [obj.threshold(1:pos); thres; obj.threshold(pos+1:obj.list_size)];
                    obj.error_rate = [obj.error_rate(1:pos); e_rate; obj.error_rate(pos+1:obj.list_size)];
                    obj.alpha =  [obj.alpha(1:pos); alpha; obj.alpha(pos+1:obj.list_size)];
                end
                obj.list_size = obj.list_size +1;
            end
        end
        
        %% is_in_range
        % checks if pos is a valid coordinate for the vectors inside this
        % class
        function res=is_in_range(obj, pos)
            res = pos >= 1 && pos <= obj.list_size;
        end
        
                
        %% is_in_range_plus_one
        % checks if pos is a valid coordinate for the vectors inside this
        % class
        function res=is_in_range_plus_one(obj, pos)
            res = pos >= 0 && pos <= obj.list_size+1;
        end
        
                
        %% return_n_best_classifiers_indexes_new
        % searchs for the n best classifiers and return a list with their
        % index, ordered by best and worse
        function res = return_n_best_classifiers_indexes_new(obj, n)
            if ~obj.is_in_range(n)
                n = obj.list_size;
            end
            [~, sort_indexes] = sort(obj.error_rate,'descend');
            res = sort_indexes(1:n);
        end
            
                
        %% return_n_best_classifiers_indexes_new
        % searchs for the n best classifiers and return a list with their
        % index, ordered by best and worse. This version also searchs for
        % negative values - the comparator will be used as the oposed of
        % what it says
        function res = return_n_best_classifiers_indexes_absolute_new(obj, n)
            if ~obj.is_in_range(n)
                n = obj.list_size;
            end
            [~, sort_indexes] = sort(abs(obj.error_rate), 'descend');
            res = sort_indexes(1:n);
        end
            
        
        %% return_n_best_classifiers_indexes
        % searchs for the n best classifiers and return a list with their
        % index, ordered by best and worse
        function res = return_n_best_classifiers_indexes(obj, n)
            if ~obj.is_in_range(n)
                n = obj.list_size;
            end
            [~, sort_indexes] = sort(obj.error_rate);
            res = sort_indexes(1:n);
        end
    end
end

