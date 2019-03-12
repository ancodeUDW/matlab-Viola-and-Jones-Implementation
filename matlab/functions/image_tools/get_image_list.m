%% get_image_list
% giving myDir=hard drive folder adress, returns the list of all the files
% that are inside it that are not a directory, and the size of such array.
% We'll use it to get the image files
%
% Note: imageList have a list of adresses that must be accesses via
% imageList{i}, being i the index we want to acess. For knowing the number
% of images we have inside imageList, we can do size(imageList), and it
% will give us a number in the way of (1, N), where N is the number of
% images.

function [imageList, imageListCounter]=get_image_list(myDir)  
    imageDirList=dir(myDir);
    n = size(imageDirList,1);
    
    % we start the process of extracting the path and name of the files
    imageListCounter=0;
    imageList = {};
    
    for i=1:n(1)
        if (imageDirList(i).isdir ~= 1)
            imageListCounter=imageListCounter+1;
            imageList{imageListCounter}=strcat(myDir,'/', imageDirList(i).name);            
        end
    end
end