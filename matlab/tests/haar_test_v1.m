%% Haar-like features test
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 16/04/2015
% * *Version*: 1.0
%%
% In this file some test on images and the Haar-like features will be done.

    %% Initialization
    % in system_ini we initializate the system. For initialization we mean
    % close all windows, clear all variables, clean the screen and and add
    % some libraries so we dan access to all functions from the project.
    run('system_ini')
    
    %% Image Test
    % tests if an image is useful. For an image to be useful, *it must be
    % 24x24*. Once we know is useful, *we must assure its an standard image*
    % (grayscale) so we know all the images we are using in this program
    % are the same type
    [myImage1, isUseful]=create_standard_image('1a.jpg');
    disp('is useful?')
    disp(isUseful);
    imshow(myImage1);
    % this image is not useful due being too big. the images should be
    % 24x24  
    % Then it is not processed and is not expected to be used, at least in the
    % training
    
    %% Image Test 2
    % tests if an image is useful. For an image to be useful, *it must be
    % 24x24*. Once we know is useful, *we must assure its an standard image*
    % (grayscale) so we know all the images we are using in this program
    % are the same type
    [myImage1, isUseful]=create_standard_image('non_faces037.jpg');
    disp('is useful?')
    disp(isUseful);
    imshow(myImage1);
    % this image is useful due being 24x24. It is in color, so it has been
    % made in grayscale.

    
    %% haar-like class test
    % here we will access to some of the haar-like class options
    clc;
    close all;
    % parameters: start point, width of one of the compnents, height of
    % one of the components, type (1, 2 or 3)
    s = haar_like([2,2], 2, 2, 1);
    s.plot_rectangle();
    disp('is valid?');
    disp(s.valid);
    
    
    %% the haar-like value using a grayscale image
    myNormalValue = s.calc_haar(myImage1)
    
    %% the haar-like value using an integral image. they must be equal
    myIImage1 = integralImage(myImage1); % matlab have its own means to create II
    myValue = s.calc_haar_integral(myIImage1)
