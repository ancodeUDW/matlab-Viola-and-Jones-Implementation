%% creates a greyscale image from the image that is in the img adress
% myImage= an image that will be trasnsformerd to grayscale

function myImage=get_image(img) 
    myImage=imread(img);
    myImage=rgb2gray(myImage);
end





