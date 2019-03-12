function [ res, size_result, data_result ] = ui_check_results( fun_mode, num_classif_needed )
%UI_CHECK_RESULTS returns the result data
%   checks for the results of adaboost training and returns them in the
%   format specified by the parameteer. If no result is found returns an
%   error message.
    if nargin < 2
        num_classif_needed = 23;    
    end

    load_modules('matlab'); % here we have functions and classes
    
    res = false;
    size_result = false;
    data_result = false;
    
    % checks if the variable exits to do the operations
    if exist('matlab/variables/total_adaboost_results.mat')
        
        load('matlab/variables/total_adaboost_results.mat', 'weak_classifiers');
        
        if strcmp(fun_mode, 'all')
            hl_code = weak_classifiers.haar_like_code;
            error_rate = weak_classifiers.error_rate;
            data_result = [hl_code'; error_rate']';
            size_result = weak_classifiers.list_size;
            res = true;
            
        elseif strcmp(fun_mode, 'best_positive')
            %% Here we get the best results that are positive
            % num_classif_needed = 23;
            my_indexes = weak_classifiers.return_n_best_classifiers_indexes_new(num_classif_needed);
            
            hl_code = weak_classifiers.haar_like_code(my_indexes);
            error_rate = weak_classifiers.error_rate(my_indexes);
            data_result = [hl_code'; error_rate']';
            size_result = num_classif_needed;
            res = true;
            
        elseif strcmp(fun_mode, 'best_all')
            % num_classif_needed = 23;
            my_indexes = weak_classifiers.return_n_best_classifiers_indexes_absolute_new(num_classif_needed);
            
            hl_code = weak_classifiers.haar_like_code(my_indexes);
            error_rate = weak_classifiers.error_rate(my_indexes);
            data_result = [hl_code'; error_rate']';
            size_result = num_classif_needed;
            res = true;   
        end
        
    else
        % there is no result, so we should inform the user

    end

end

