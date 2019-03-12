%% Haar-like features test
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 04/01/2015
% * *Version*: 1.0
%%
% In this file some test on images and the Haar-like features will be done.

    %% Initialization
    % Erase all the data and close all the windows one might find.
    close all;
    %clear all;
    clc;
    
    %% load the modules
    % the modules are loaded inside the program adding their paths.
    load_modules('functions'); % here we have functions and classes
    load_modules('img'); % here we have the images
    load_modules('classes'); % classes
    
    %% Image Test
    % tests if an image is useful. For an image to be useful, *it must be
    % 24x24*. Once we know is useful, *we must assure its an standard image*
    % (grayscale) so we know all the images we are using in this program
    % are the same type
    [myImage1, isUseful]=create_standard_image('faceTrainPos1.jpg');
    % isUseful
    % imshow(myImage1);
    
    %%
    % in the next case the image is not useful because is too big. Then it
    % is not processed and is not expected to be used, at least in the
    % training
    [myImage2, isUseful]=create_standard_image('non-faces (11).jpg');
    % isUseful
    % figure; imshow(myImage2);
    
    %% haar-like class test
    % here we will access to some of the haar-like class options
    %                   [ ]
    %                   [#]    [ ][#]    [ ][#][ ]
    %                 type 1   type 2     type 3
    s = haar_like([2,20], 2, 2, 1); %start_point, width, height, type
    s.plot_rectangle();
    featureIsValid = s.valid
    
    
    % the haar-like value using a grayscale image
    myNormalValue = s.calc_haar(myImage1) 
    
    % the haar-like value using an integral image. they must be equal
    myIImage1 = integralImage(myImage1); % matlab have its own means to create II
    myIntegralValue = s.calc_haar_integral(myIImage1)
    
%     'Calculation of num of Haar-like types 1,2,3. there are limitations'
%     s = haar_like([1,1], 1, 1, 1); %start_point, width, height, type
%     [object_type_1_num, object_type_1] = s.count_all_haar_like();
%     
%     s = haar_like([1,1], 1, 1, 2); %start_point, width, height, type
%     [object_type_2_num, object_type_2] = s.count_all_haar_like();
%     
%     s = haar_like([1,1], 1, 1, 3); %start_point, width, height, type
%     [object_type_3_num, object_type_3] = s.count_all_haar_like();
%     
%     all_haar_like_types = [object_type_1; object_type_2; object_type_3];
%     object_type_1_num
%     object_type_2_num
%     object_type_3_num
%     
%     total_number_haar_like_features = object_type_1_num + object_type_2_num + object_type_3_num
% 
%     save('haar_like_features_with_limitations.mat', 'all_haar_like_types','total_number_haar_like_features','object_type_1_num', 'object_type_2_num', 'object_type_3_num')
%     
