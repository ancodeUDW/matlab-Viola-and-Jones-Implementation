%% function adaboost
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 14/01/2015
% * *Version*: 0.1
% strong_classifier
function [ classifier_list, image_testing_results, continue_work ] = adaboost( haar_like_feat_list, sample_img_true, sample_img_false, id_img_true, id_img_false, check_savestate, show_statistics, save_periodically, save_at_close)
%% ADABOOST_NEW implements the adaboost algorithm
%   Fix of the adaboost algorithm. The original one was not properly
%   finished so it failed to get a good set. In this version we aim to fix
%   any error it should have

    %% Input
    % as input we have the set of faces and non faces The first parameter
    % defined the faces and the second the non faces
    
    if nargin < 9
        save_at_close = false;    
    end
    
    if nargin < 8
        save_periodically = false;        
    end
    
    if nargin < 7
        show_statistics = false;
    end
    
    if nargin < 6
        check_savestate = false;
    end
    
    %% initializations
    num_of_classifiers = size_of_feat(haar_like_feat_list); % total number of features
    system_error_counter = 0; % how many classifiers that doesnt work we have

    if check_for_savestate() && check_savestate
        [start_with_classifier, classifier_list, img_pack , system_error_list, system_error_counter] = restore_savestate();
    else
        start_with_classifier = 1;
        classifier_list = weak_classifier_list(); % here we will store the classifiers.
        img_pack = vj_image_data(sample_img_true, sample_img_false);
        system_error_list = {}; % in the case some classifiers wont work, we will store the message here
    end
    
    image_testing_results_cum = zeros(1, img_pack.number_images);

    % timming stuff.
    tic; % to check the time, TIC, pair 1
    tStart = tic;
    
    % as a new feature, wait bar has been added with a cancel option, and
    % also an stimated time.
    my_bar = waitbar(0,'1', 'Name','Checking features', 'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
        
    if show_statistics
        [bar_faces, bar_no_faces, bar_positive_addition, graph_hl_weights] = initialize_bar_statics(img_pack, id_img_true, id_img_false, image_testing_results_cum);      
    end
   
    %% the Loop starts
    for current_classifier=start_with_classifier:num_of_classifiers
        %% the real algorithm starts here
        % something we need to add is the error rate 
        
        % need img_pack.weights to be a probability distribution
       
        img_pack.image_weight = img_pack.norm_weights();
        
        % inside weak_classifier_list(t) you can find the classifier data:
        % that is: haar-like number, optimal threshold and error_rate
        % BECAUSE OF THIS WE SHOULD CHECK THE REDIRECTION!
        
        % the my_error_data is not the suitable one, we must calculate it
        % in the adaboost weight way.
        % EXTRA: added progress bar with cancel features
        % TODO: add save features
        
        
        [my_threshold, my_alpha, image_testing_results, my_alert, num_fails, fail_rate, ~, ~] = ...
            train_weak_classifier(haar_like_feat_list(current_classifier, :), img_pack);%, my_feature_bar);
        
        if my_alert == 1
            % some of the haar-like have errors, here we can check them
            % here and not to be added to the classifier list
            system_error_counter = system_error_counter + 1;
            
            if fail_rate < 100
                % ignore the classifiers that have certain error margin
                disp(['the haar_like feature t: ' int2str(current_classifier) ' is too random with an error rate of ' int2str(fail_rate)]);
                system_error_list{system_error_counter} = ['the haar_like feature t: ' int2str(current_classifier) ' is too random with an error rate of ' int2str(fail_rate)];
            else
                disp(['the haar_like feature t:' current_classifier ' is not valid']);
                system_error_list{system_error_counter} = ['the haar_like feature t:' current_classifier ' is not valid'];
            end
                    
            % evaluate error

            % find this haar-like feature weak classificator error, that
            % depends of the weights of the image.

            % we wont use this classifier so we won't update weights, depending of the current error
        
        else
        
            % evaluate error

            % find this haar-like feature weak classificator error, that
            % depends of the weights of the image.
            image_testing_results_cum = add_cumulative_stuff(image_testing_results_cum, image_testing_results);
            
            % my_error_data = img_pack.evaluate_error(image_testing_results);

            % update weights, depending of the current error

            % update weights depending of the error value we get in this
            % iteration
            [img_pack, current_weight] = img_pack.update_weights_standard(...
                                            image_testing_results...
                                            );


            % adds the classifier to the list 
            classifier_list = classifier_list.add_classifier( ...
                                            current_classifier, ... % its code is its position in the haar-like features vector
                                            my_threshold, ... % optimal treshold
                                            my_alpha, ...
                                            current_weight ...
                                            ); % error data of this classifier, later will serve to order the classifiers.
        end
        
        
        %% check if the user clicked the cancel button
        % note: maybe this should be in the end of the loop when added the
        % saving feature.
        [continue_work, tStart] = update_the_bar(my_bar, tStart, current_classifier, num_of_classifiers);
        
        if ~continue_work
            % we should add here a way to save the current state
            if save_at_close
                save_data(current_classifier+1, classifier_list, img_pack , system_error_list, system_error_counter);
            end
            
            break
        elseif save_periodically && mod(current_classifier, 2500) == 0
            % the savestate has been created so if there is some trouble -
            % the computer shut down, electricity went out, etc - we dont
            % lose all the computing work done. for this reason, this will
            % save the state when certain number of loops has passed. In
            % this case, we have decided 2500, that are, roughly, 5% of the
            % job done. If stadistically the computer have to work 2 hours
            % to finish a job, this will be around 6 seconds
            
            % save the state so we dont have to start over next time
            save_data(current_classifier+1, classifier_list, img_pack , system_error_list, system_error_counter);
            disp(['saved information at cicle ' int2str(current_classifier)])
        end
        
        if show_statistics && mod(current_classifier, 20) == 0
            % we show this only when we want to show stadistics AND the
            % current classifier is module of 20. this way we wont have as
            % much calculation time.
            
            [bar_faces, bar_no_faces, bar_positive_addition] = update_bar_statics(bar_faces, bar_no_faces, bar_positive_addition, img_pack, image_testing_results_cum);      
            [graph_hl_weights] = update_weight_figure(graph_hl_weights, current_classifier, current_weight);
        end
        
    end
    
    delete(my_bar)
%    delete(my_feature_bar)
    
    % we write the results in the gui
    %write_results_in_gui(handles, t, error_counter, error_list)
end


function [ classifier_list, image_testing_results ] = adaboost_old( haar_like_feat_list, sample_img_true, sample_img_false)%, handles)
%% ADABOOST implements the adaboost algorithm for viola and jones boosting detector
%   adabost is the implementation of the viola and jones adaboost part of
%   their boosting face detector algorithm.
    
    % Given example images sample_img_true and sample_img_false. True and
    % false denotes if it is a face or is not.
   
    num_of_feat = size_of_feat(haar_like_feat_list); % total number of features
    
    %% Weights initialization.
    %
    % Each image have 1/num weight at the
    % start of the algorithm. Again, it was not necessary to create a
    % variable just for this, but it helps to understand what the
    % algorithm is doing
    img_pack = vj_image_data(sample_img_true, sample_img_false);
    classifier_list = weak_classifier_list();
    error_list = [];
    error_counter = 0;
    
    tic; % to check the time, TIC, pair 1
    tStart = tic;
    % as a new feature, I add a wait bar
    my_bar = waitbar(0,'1', 'Name','Checking features', 'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
    % my_feature_bar = waitbar(0,'1', 'Name','Training weak classifier', 'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
    
    %% adaboost itineration
    % we start the itineration. We are trying for each feature from our set
    for current_feature=1:num_of_feat 
        
        [continue_work, tStart] = update_the_bar(my_bar, tStart, current_feature, num_of_feat);
       
        if ~continue_work
            % we should add here a way to save the current state
            % also we should take care of loading the current state
            % save_data(img_pack, classifier_list, error_counter, image_testing_results, current_feature);
            break
        end
        
        % if getappdata(my_feature_bar,'canceling')
        %    save_data(img_pack, classifier_list, error_counter, image_testing_results, current_feature);
        %    break
        % end
        
        % we need img_pack.weights to be a probability distribution
        img_pack.image_weight = img_pack.norm_weights();
        
        % inside weak_classifier_list(t) you can find the classifier data:
        % that is: haar-like number, optimal threshold and error_rate
        % BECAUSE OF THIS WE SHOULD CHECK THE REDIRECTION!
        
        % the my_error_data is not the suitable one, we must calculate it
        % in the adaboost weight way.
        % EXTRA: added progress bar with cancel features
        % TODO: add save features
        [my_threshold, my_alpha, image_testing_results, my_alert] = ...
            train_weak_classifier(haar_like_feat_list(current_feature, :), img_pack);%, my_feature_bar);
        
        if my_alert == 1
            % some of the haar-like have errors, here we can check them
            error_counter = error_counter + 1;
            
            error_list(error_counter) = ['the haar_like feature t = ' current_feature 'is not valid'];
            classifier_list = classifier_list.add_classifier( ...
                                        current_feature, ... % its code is its position in the haar-like features vector
                                        my_threshold, ... % optimal treshold
                                        my_alpha, ...
                                        1); % error data of this classifier, later will serve to order the classifiers.

        else
        
            % evaluate error

            % find this haar-like feature weak classificator error, that
            % depends of the weights of the image.
            my_error_data = img_pack.evaluate_error(image_testing_results);

            % update weights, depending of the current error

            % update weights depending of the error value we get in this
            % iteration
            img_pack = img_pack.update_weights(...
                                            my_error_data,...
                                            image_testing_results...
                                            );


            % adds the classifier to the list 
            classifier_list = classifier_list.add_classifier( ...
                                            current_feature, ... % its code is its position in the haar-like features vector
                                            my_threshold, ... % optimal treshold
                                            my_alpha, ...
                                            my_error_data); % error data of this classifier, later will serve to order the classifiers.
        end

    end
    
    delete(my_bar)
%    delete(my_feature_bar)
    
    % we write the results in the gui
    %write_results_in_gui(handles, t, error_counter, error_list)


    
    %% Define an strong classifier
    % strong_classifier = create_strong_classifier(weak_classifier_list);
end


function [ret, tStart] = update_the_bar(my_bar, tStart, current_feature, num_of_feat)
    %%
    % does all the stuff to update the state bar
        tElapsed= toc(tStart);
        tStart = tic;
        [my_hours, my_minutes] = estimation(tElapsed, current_feature, num_of_feat);
        waitbar(current_feature/num_of_feat, my_bar, sprintf('%d of %d estimated time: %dh, %dmin', current_feature, num_of_feat, my_hours, my_minutes));
        
        if getappdata(my_bar,'canceling')
            % we should add here a way to save the current state
            % also we should take care of loading the current state
            ret = false;
        else
            ret = true;
        end
 end

function write_results_in_gui(handles, total_num, error_counter, error_list)
    %write the results in a GUIDE windows
    set (handles.total_number, 'string', total_num);
    set (handles.num_errors, 'string', error_counter);
    set (handles.error_list, 'string', error_list);
end

function res = size_of_feat(haar_like_feat_list)
    res = size(haar_like_feat_list);
    res = res(1);
end

function save_data(current_classifier, classifier_list, img_pack , system_error_list, system_error_counter)
    %% to do, saves the data so it can be resumed in other moment.
    save('matlab/savestates/savestates.mat', 'current_classifier', 'classifier_list', 'img_pack' , 'system_error_list', 'system_error_counter');
end

function  res = check_for_savestate()
    %% checks if a savestate exists
    if exist('matlab/savestates/savestates.mat', 'file')
        res = true;
    else
        res = false;
    end
        
end

function [my_hours, my_minutes] = estimation(tElapsed, current_feature, num_of_feat)
    my_time = tElapsed*(num_of_feat - current_feature); % in seconds
    my_hours = fix(my_time/3600); % in minutes
    my_minutes = fix(rem(my_time, 3600)/60);
end

function [start_with_classifier, classifier_list, img_pack , system_error_list, system_error_counter] = restore_savestate()
    %% restores the state we can find in the folder 'matlab/savestate' 
    my_savestates = load('matlab/savestates/savestates.mat');
    start_with_classifier = my_savestates.current_classifier;
    classifier_list = my_savestates.classifier_list;
    img_pack = my_savestates.img_pack;
    system_error_list = my_savestates.system_error_list;
    system_error_counter = my_savestates.system_error_counter;
 end

function [bar_faces, bar_no_faces, bar_positive_addition, graph_weights] = initialize_bar_statics(img_pack, id_img_true, id_img_false, image_testing_results_cum)
    %% initializes the bar_statidistics
    figure;
    my_y_limit = 0.04;
    my_window_y_size = 4;
    my_window_x_size = 1;
    
    subplot(my_window_y_size, my_window_x_size,1) ;
    my_bars_pos = img_pack.image_weight(1:img_pack.number_pos_images); % show in 2 groups so we can see them in different colors
    my_bar_neg =  img_pack.image_weight(img_pack.number_pos_images+1:end);
    bar_faces = bar(my_bars_pos, 'facecolor', 'g');
    % set(gca,'XTickLabel', id_img_true)
    ylim([0 my_y_limit]);
    title('weight of the faces');
    
    subplot(my_window_y_size, my_window_x_size,2) 
    bar_no_faces = bar(my_bar_neg, 'facecolor', 'r');
    set(bar_no_faces, 'XData', img_pack.number_pos_images+1:img_pack.number_images);
    % set(gca,'XTickLabel', id_img_false)
    ylim([0 my_y_limit])
    title('weight of the no faces');
    
    subplot(my_window_y_size, my_window_x_size,3) 
    bar_positive_addition = bar(image_testing_results_cum, 'facecolor', 'b');
    title('image weight addition');
    
    size_plot = 50;
    subplot(my_window_y_size, my_window_x_size, 4) 
    graph_weights = plot(zeros(1, size_plot));
    title('classifier evolution');
        
end 


function h = update_weight_figure(h, new_classifier, new_data)
    %% creates a bar with the weight of the images
    y_info = h.YData;
    
    y_info = [y_info(2:end) new_data];
    
    set(h, 'YData', y_info);
    refreshdata;
    drawnow;
end
         
 
 function [bar_faces, bar_no_faces, bar_positive_addition] = update_bar_statics(bar_faces, bar_no_faces, bar_positive_addition, img_pack, image_testing_results_cum);      
   %% updates the bar stadistics
    my_bars_pos = img_pack.image_weight(1:img_pack.number_pos_images); % show in 2 groups so we can see them in different colors
    my_bar_neg =  img_pack.image_weight(img_pack.number_pos_images+1:end);

    set(bar_faces, 'YData', my_bars_pos);
    set(bar_no_faces, 'YData', my_bar_neg);

    set(bar_positive_addition, 'YData', image_testing_results_cum);
    
    refreshdata;
    drawnow;
 end
 
 function [image_testing_results_cum] = add_cumulative_stuff(image_testing_results_cum, image_testing_results)
    %% creates a grahpic bar in where you can see the properly and unproperly classify cumulative sum
    aux = image_testing_results == 1;
    image_testing_results_cum = image_testing_results_cum + aux;
 end
