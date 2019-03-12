%% find best threshold test  - VERIFIED -
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 16/04/2016
% * *Version*: 1.0
%%
% in this file some tests of the weak_classifier function will be used. In
% particular, the discovery of the threshold and the alpha

    %% Initialization
    % in system_ini we initializate the system. For initialization we mean
    % close all windows, clear all variables, clean the screen and and add
    % some libraries so we dan access to all functions from the project.
    run('system_ini')


    %% Best threshold test
    % load faces and no faces results. in this case, as this is a test, we
    % load random values. But both variables must be ordered so the
    % function "find_best_threshold works as expected."
    
    % in here we define that, my_faces and my_no_faces are the result
    % values for applying the haar_like_code to a set of training images
    % that are defined and faces and defined as no faces
    
     % find_best_threshold will return us the alpha and the threshold for
    % the haar_like code. remember that, if a value got by applying this
    % haar_like_code is hl_value we can calule if it is a face or not by
    % doing this operation:
    %
    % IF threshold <= alpha*hl_value THEN is face ELSE is no face
    %
    
    haar_like_code = '30'; % we need a value for the haar_like code, so we get a random one
        
    %% first test,
    % Faces are always smaller than non faces
    clc
    my_faces = [11 31 41 45 45 48];
    my_no_faces = [100 200 200 300 500 600 600 700 800 1000 1000];
    
    [my_alpha, my_thres] = find_best_threshold(my_faces, my_no_faces);
    my_w_c = weak_classifier(haar_like_code, my_thres, my_alpha);
    my_w_c.print_values();
    
    % as the faces are always smaller than the non faces, the expected
    % value of alpha is -1. the expected value of threshold is (100+48)/2 =
    % 74 and the actual value of the threshold is -74
    
        
    %% second test,
    % Faces are always bigger than non faces
    clc
    my_faces = [100 200 200 300 500 600 600 700 800 1000 1000];
    my_no_faces = [11 31 41 45 45 48];
    
    [my_alpha, my_thres] = find_best_threshold(my_faces, my_no_faces);
    my_w_c = weak_classifier(haar_like_code, my_thres, my_alpha);
    my_w_c.print_values();
    
    % as the faces are always bigger than the non faces, the expected
    % value of alpha is 1. the expected value of threshold is (100+48)/2 =
    % 74 and the actual value of the threshold is 74
    
    
    %% third test
    % Faces and Non Faces have mixed values, but faces tend to be bigger
    % than non faces
    clc
    my_faces = [8 10 10 11 31 41 45 45 48];
    my_no_faces = [1 2 2 3 5 6 6 7 8 10 10 10 11];
    
    [my_alpha, my_thres] = find_best_threshold(my_faces, my_no_faces);
    my_w_c = weak_classifier(haar_like_code, my_thres, my_alpha);
    my_w_c.print_values();
    
        
    % as the faces are most of the time bigger than the non faces, the
    % expected values are the following:
    %
    % * alpha: 1
    % * threshold: (8+10)/2 = 9
    % * alpha * threshold = 9
    % with the new way to calcule the threshold in this case this is closer
    % to 10, but is ok
    
    
    %% fourth test
    % Faces and Non Faces have mixed values, but non faces tend to be bigger
    % than faces
    clc
    my_faces = [1 2 2 3 5 6 6 7 8 10 10 10 11];
    my_no_faces = [8 10 10 11 31 41 45 45 48];

    [my_alpha, my_thres] = find_best_threshold(my_faces, my_no_faces);
    my_w_c = weak_classifier(haar_like_code, my_thres, my_alpha);
    my_w_c.print_values();
    
        
    % as the faces are most of the time bigger than the non faces, the
    % expected values are the following:
    %
    % * alpha: -1
    % * threshold: (8+10)/2 = 9
    % * alpha * threshold = -9
    % with the new way to calcule the threshold in this case this is closer
    % to 10, but is ok
    
    
    %% fifth test
    % Faces and Non Faces have mixed values and the same values to start
    % and finish
    clc
    my_faces = [1 2 2 3 5 6 6 7 8 10 10 10 11 48]; % faces are essentially smaller most of the time
    my_no_faces = [1 8 10 10 11 31 41 45 45 48]; % non faces are essentially bigger

    [my_alpha, my_thres] = find_best_threshold(my_faces, my_no_faces);
    my_w_c = weak_classifier(haar_like_code, my_thres, my_alpha);
    my_w_c.print_values();
    
        
    % as the faces are most of the time bigger than the non faces, the
    % expected values are the following:
    %
    % * alpha: -1
    % * threshold: mean of the both means
    % * alpha * threshold = -9
    % with the new way to calcule the threshold in this case this is closer
    % to 10, but is ok
    
      
    %% sixth test
    % Faces and Non Faces have mixed values and the same values to start
    % and finish
    clc
    my_faces = [1 8 10 10 11 31 41 45 45 48]; % faces are essentially bigger most of the time
    my_no_faces  = [1 2 2 3 5 6 6 7 8 10 10 10 11 48]; % non faces are essentially smaller

    [my_alpha, my_thres] = find_best_threshold(my_faces, my_no_faces);
    my_w_c = weak_classifier(haar_like_code, my_thres, my_alpha);
    my_w_c.print_values();
    
        
    % as the faces are most of the time bigger than the non faces, the
    % expected values are the following:
    %
    % * alpha: 1
    % * threshold: mean of the both means
    % * alpha * threshold = 
    % with the new way to calcule the threshold in this case this is closer
    % to 10, but is ok
    
    
      
    %% seventh test
    % Faces and Non Faces have the same exact value
    clc
    my_faces = [1 8 10 10 11 31 41 45 45];
    my_no_faces  = my_faces;

    [my_alpha, my_thres] = find_best_threshold(my_faces, my_no_faces);
    my_w_c = weak_classifier(haar_like_code, my_thres, my_alpha);
    my_w_c.print_values();
    
        
    % in this case, the expected value is the mean, in this case 22.4444.
    % alpha will be 1 always, because we dont really care if the faces are
    % bigger or smaller, yet this is the default value
    % This weak classifier would be a very bad on in comparision of the
    % others
                              
    
    %% 
    % testing the classifier with the values we used to set it.  We can use
    % this part after excuting any of the former tests
    
    [~, faces_size] = size(my_faces);
    [~, no_faces_size] = size(my_no_faces); 
    
    faces_result = zeros(1, faces_size);
    
    for i = 1:faces_size
        faces_result(i) = my_w_c.test_value(my_faces(i));
    end
     
     no_faces_result = zeros(1, no_faces_size);
     
     for i = 2:no_faces_size
         no_faces_result(i) = my_w_c.test_value(my_no_faces(i));
     end   
     
     disp('results: first from the faces_vector, then from the non faces vector');
     disp(my_faces);
     disp(faces_result);
     disp(my_no_faces);
     disp(no_faces_result);
     
     %% finally we test the function test_classifier
     % this function checks if all the values from a vector are faces or
     % not. We assume all the values are faces, so every error is counted
     % and returned
     clc
     vector_to_check = my_faces;    
     disp('current classifier');
     my_w_c.print_values();
     disp(' ');
     disp(' ');

     disp('test_classifier over vector of faces. Is expected to have a low error rate');
     [res, num_error, percentage_error] = my_w_c.test_classifier(vector_to_check);

     disp('values to check');
     disp(vector_to_check);
     disp('results');
     disp(res);
     disp('num errors');
     disp(num_error);
     disp('% error');
     disp(percentage_error);
     
     vector_to_check = my_no_faces;
     disp('test_classifier over no faces. is expected to have a high error rate');
     [res, num_error, percentage_error] = my_w_c.test_classifier(vector_to_check);
     disp('values to check');
     disp(vector_to_check);
     disp('results');
     disp(res);
     disp('num errors');
     disp(num_error);
     disp('% error');
     disp(percentage_error);
    
   