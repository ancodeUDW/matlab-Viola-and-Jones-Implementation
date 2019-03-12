function [ plot_result ] = ui_show_haarLike( hl_code )
%UI_CHECK_RESULTS returns the result data
%   checks for the results of adaboost training and returns them in the
%   format specified by the parameteer. If no result is found returns an
%   error message.
    load_modules('matlab'); % here we have functions and classes
    load('matlab/variables/haar_like_features_with_limitations.mat', 'all_haar_like_types');
    
    feat_pos_x = 1;
    feat_pos_y = 2;
    feat_width = 3;
    feat_height = 4;
    feat_type = 5;
        
    
    hl_feat = all_haar_like_types(hl_code, :);
    
    my_current_feature = haar_like(...
                        [hl_feat(feat_pos_x) hl_feat(feat_pos_y)], ...  % start point
                        hl_feat(feat_width), ...  % unitary rectangle width
                        hl_feat(feat_height), ... % unitary rectangle height
                        hl_feat(feat_type) ...    % feature type
                    );
                
    plot_result = my_current_feature.plot_rectangle();
                
end

