%% Generates an integral image from an image
% img= an image that will be trasnsformerd to grayscale
% II= the resulting integral image
function II=integral_image(img)
    % image normalize -> [0,1]
    img = img - min(img(:));
    img = img/max(img(:));

    % gray-scale image
    img = rgb2gray(img);
    
    [sy, sx]=size(img);
    
    II = zeros([sy,sx]);

    % computing integral image
    for y = 1:sy
        for x = 1:sx

            % case: y=1 x=1
            if (y==1 && x==1)
                II(y,x) = img(y,x);
            end

            % case: y>1 x=1
            if (y>1 && x==1)
                II(y,x) = II(y-1,x) + img(y,x);
            end

            % case: y=1 x>1
            if (y==1 && x>1)
                II(y,x) = II(y,x-1) + img(y,x);
            end

            % case: y>1 x>1
            if (y>1 && x>1)
                II(y,x) = II(y-1,x) + II(y,x-1) - II(y-1,x-1) + img(y,x);
            end

        end
    end

    % show integral image
    %figure,imagesc(II),colormap(gray)
    %pause
    % show integral image as surface
    %figure,surfc(II)
end





