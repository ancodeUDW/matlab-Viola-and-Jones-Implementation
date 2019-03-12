%% create standard image
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 09/05/2016
% * *Version*: 1.0
%%
% This module will check if the image is 24x24, if it is, it will be
% considerated useful to be used in the training and will be transformed in
% grayscale if it wasn't already.
%
% This way we make sure that all the images have the same specs in order to
% work the training properly.
function [resImage, isUseful]=create_standard_image(myImage)
    resImage=imread(myImage);
    isUseful=1;
    
    % if the image is not a 24x24 image, we must notify it so we wont use
    % it - we could resize it but we must asure that we dont deform the
    % image in any way possible, so if the image have no the desired
    % proportions, we simply wont use it.
    if (size(resImage, 1)~=24 && size(resImage, 2) ~= 24)
        % as today, we resize the image so it will always be useful, but a
        % warning will be given to the user.
        resImage = imresize(resImage,[24 24]);
        % disp([ 'image ' myImage ' was more than 24x24 and has been resized!' ] );
    end
    
    % if the image is a color image, we must make it in grayscale
    if (size(resImage, 3)==3)
        resImage=rgb2gray(resImage);
        % disp([ 'image ' myImage ' was colored and has been grayscaled!' ] );
    end
    % Our tests will be done in a 24x24 pixel images
end