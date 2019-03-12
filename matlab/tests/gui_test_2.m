%% vj_image_data test
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 04/01/2015
% * *Version*: 1.0
%%
% In this file some test on images and the Haar-like features will be done.

    %% Initialization
    % in system_ini we initializate the system. For initialization we mean
    % close all windows, clear all variables, clean the screen and and add
    % some libraries so we dan access to all functions from the project.
    run('system_ini')
    
    %% creates the GUI
    h = test_image_data;
    % gets the GUI handles
    my_handle = get(h);
    handles=guidata(h);
    
    pos_img_set = [...
        'pos_1.jpg';...
        'pos_2.jpg';...
        'pos_3.jpg';...
        'pos_4.jpg';...
        'pos_5.jpg';...
    ];
    
    neg_img_set = [...
  %      'neg_1.jpg';...
   %     'neg_2.jpg';...
        'neg_3.jpg';...
        'neg_4.jpg';...
        'neg_5.jpg';...
    ];

    my_image_set = vj_image_data(pos_img_set, neg_img_set);
    
    image_list_weight = [];
    for i =1:my_image_set.number_images
        % res = my_image_set.return_image_i(i)
        % 'image is positive?'
        % res = my_image_set.image_is_positive(i)
        % ['weight i: ' num2str(i) ' is ' num2str(my_image_set.return_image_weight(i))]
        image_list_weight = [image_list_weight; my_image_set.return_image_weight(i)];
    end
    % Input the info inside the GUI - original weight table - via the
    % handle
    set (handles.original_weight, 'string', image_list_weight);

    
    
    my_image_set=my_image_set.norm_weights(my_image_set);
    
    image_list_weight = [];
    for i =1:my_image_set.number_images
        % res = my_image_set.return_image_i(i)
        % 'image is positive?'
        % res = my_image_set.image_is_positive(i)
        % ['norm weight i: ' num2str(i) ' is ' num2str(my_image_set.return_image_weight(i))]
        image_list_weight = [image_list_weight; my_image_set.return_image_weight(i)];        
    end
    
    set (handles.normalized_weight, 'string', image_list_weight);
    set (handles.normalized_weight, 'string', image_list_weight);


    
    my_results = [1 0 0 0 1];
    my_error = 0.1;
    my_image_set = my_image_set.update_weights(my_error, my_results);
    my_image_set=my_image_set.norm_weights(my_image_set);

    image_list_weight = [];

    for i =1:my_image_set.number_images
        % res = my_image_set.return_image_i(i)
        % 'image is positive?'
        % res = my_image_set.image_is_positive(i)
        %['norm weight i: ' num2str(i) ' is ' num2str(my_image_set.return_image_weight(i))]
        image_list_weight = [image_list_weight; my_image_set.return_image_weight(i)];        
    end
    set (handles.corrected_weight, 'string', image_list_weight);
    set (handles.error_text, 'string', my_error);
    
    
