%% class haar_like
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 04/01/2015
% * *Version*: 1.0

%% TODO: 
% * create a haar_like class, that includes the 2 haar_like feataures we 
% will use here
% * create a function to count all the possible haar like combinations of
% this haar-like feature type.

%%
% implementation of the Haar-like features. In this implementation we only
% take in account 2 haar-like types, but it can change in the future
%
% by now we assume than the basic type is one pixel by one pixel
% but that may change in the future. this is the structure with 2
% rectangles, one on the top of the other
classdef haar_like_1
    properties (Constant)
        type=1;
        img_min_pos=1;
        img_max_pos=24;
        min_size_rec=1; % min size for height*2 and and width
        max_size_rec_height=12; % maxim size for height
        max_size_rec_width=24;
    end
    
    properties
        % here define the 2 squares.
        start_point = [1, 1]; % the point in where the rectangles starts.
        % [x, y]
        my_width = 1; % the width of the individual rectangle
        my_height = 1; % the height of the individual rectangle
        valid = 0;
    end
    
    methods
        %% creation of the object
        function obj=haar_like_1(start_point, my_width, my_height)
            % a verification needs to be done - the square must be inside 
            % a 24x24 grid: the start point must be greather than [0 0] and
            % start_point + [my_width my_height*2] must be smaller than
            % [24 24], and of course, integer
            
            % the representation of this haar-like feature is according the
            % rectangle that will be outside, so instead of using the 24 as
            % a limit, we use 24 + 5. this we will ensure that we dont left
            % the last pixels of the square whitout attending

            if ((start_point(1) + my_width)    > obj.img_max_pos + 1 || ...
                (start_point(2) + my_height*2) > obj.img_max_pos + 1 || ...
                 start_point(1)                < obj.img_min_pos || ...
                 start_point(2)                < obj.img_min_pos    ...
                )
                obj.valid = 0;
            else
                obj.valid = 1;
            end
            obj.start_point = start_point;
            obj.my_width = my_width;
            obj.my_height = my_height;
        end
        
        %% black_rec
        % the black rectangle is in the bottom of the white rectangle
        function res=black_square(obj)
            res = create_square(obj, obj.start_point(1), obj.start_point(2) + obj.my_height); 
        end
        
        %% white_rec
        % the white rectangle is at the top of the black rectangle
        function res=white_square(obj)
            res = create_square(obj, obj.start_point(1), obj.start_point(2));
        end
        
        %% create_square
        % in order to not to repeat code, we have defined here an standard
        % function to create one square. Probably will be repeated in type
        % 2 too.
        function res=create_square(obj, start_x, start_y)
            res = obj.create_base_square(start_x, ...
                                     start_y, ...
                                     obj.my_width, ...
                                     obj.my_height); % if using a basic type, check the type before deciding to multiply this one or the other
        end
        
                
        %% create_full_rectangle
        % creates the rectangle that is equivalent to the full shape of the
        % 2 rectangles that make the haar like feature.
        function res=create_full_rectangle(obj, start_x, start_y)
            res = create_base_square(obj, ...
                                     start_x, ...
                                     start_y, ...
                                     obj.my_width, ...
                                     obj.my_height*2); % if using a basic type, check the type before deciding to multiply this one or the other
        end
        
        
        %% calculate Haar value
        % calculate Haar value of a grayscale image
        function res=calc_haar(obj, my_image)
            % If this dont work, check that is an integer and not an 
            % unsigned integer
            
            if obj.valid
                res = obj.calc_haar_square(obj.white_square, my_image)...
                    - obj.calc_haar_square(obj.black_square, my_image);
            else
                res = -1;
            end
        end
        
        
        %% calculate Haar value Integral
        % calculate Haar value of a grayscale integral image
        function res=calc_haar_integral(obj, my_ii)
            if obj.valid
                res = obj.calc_haar_square_integral(obj.white_square, my_ii)...
                    - obj.calc_haar_square_integral(obj.black_square, my_ii);
            else
                res=-1;
            end
        end
        
        
        %% calc_haar_square
        % calculates the value of one square using a grayscale image
        function res=calc_haar_square(obj, my_square, my_image)
            % We must be note that the
            % representation of the image 24x24 with the haar-like features
            % starts with the coordinate [0 0] and ends in the coordinate
            % [23,23]. As matlab uses vectors and matrix that are indexes
            % starting 1, a correction must be used when we access to the
            % image (adding 1).
            
            % note: images are uint8, that means they have a limit of 255.
            % take this in account when you have to add the values in res
            
            my_start_point = my_square(1,:);
            res = 0;
            my_x = 1;
            my_y = 2;

            for i = my_start_point(my_x):my_start_point(my_x) + obj.my_width-1
                for j = my_start_point(my_y):my_start_point(my_y) + obj.my_height-1
                    res = res + int32(my_image(j, i)); % must make the conversion, if not  its from 0 to 256
                end
            end

        end        
       
        
        %% plot rectangle
        % plots the haar-like rectangles in a 24x24 grid. we can chose
        % which one to plot, the black or the white. Must note that the
        % plots and areas used in this fuctions uses X, Y type parameters,
        % but the Images themselves use coordinates in the type Y, X
        function plot_rectangle(obj)
            recToPlot='haar like figure';
            
            % haar-like rectangles
            my_rec_black = obj.black_square();
            my_rec_white = obj.white_square();
  
            % main grid
            main_square=[1                     1;
                        (obj.img_max_pos + 1)  1
                        (obj.img_max_pos + 1) (obj.img_max_pos + 1)
                        1                     (obj.img_max_pos + 1)
                        1                      1];
            
            % plot everything
            figure
            
            % an square symbolizing the image
            plot( main_square(:,1), main_square(:,2),...
                  'LineWidth',2); 
            hold on;
           	grid on;

            % the white rectangle
            plot(my_rec_white(:,1), my_rec_white(:,2),...
                 'color', 'black',...   
                 'LineWidth',2);
            % the black rectangle
            plot(my_rec_black(:,1), my_rec_black(:,2),...
                 'color', 'black',...   
                 'LineWidth',2);
            h=area(my_rec_black(:,1), my_rec_black(:,2));
            set(h,'FaceColor','black');
            
            title(recToPlot);
            
            set(gca,'YDir','Reverse') % makes the axis reverse like images
            axis square % makes the proportions fit
            
            % plot(myRec, 'Color', 'red');
            y_labels = 0:1:26;
            axis([0,26,0,26])
            set(gca, 'YTickLabel', y_labels);
            set(gca, 'XTickLabel', y_labels);
            set(gca,'xtick', y_labels);
            set(gca,'ytick', y_labels);
            
            hold off;
        end
        
        
        %% count all haar like
        % counts all the possible haar-like features exist in a window of
        % 24x24 pixels. We must count all the posible variations and all
        % the positions for each variation. Finally it have to return the
        % parameters we can use with this object in order to create the
        % feature.
        % **WARNING** this function will erase the data from the
        % haar-like-1 object
        %
        % num_haar: num of type 1 haar-like features that exist inside a
        % 24x24 window.
        % data_haar: vector with [x,y,width,height, type_of_haar] components that
        % describes all the possible haar-like features
        %
        function [num_haar, data_haar]=count_all_haar_like(obj)
            num_haar=0;
            data_haar = [0, 0, 0, 0];
            
            % with this we try all the haar-like rectangles size
            % combinations
            for width_x = obj.min_size_rec:obj.max_size_rec_width
                for height_y = obj.min_size_rec:obj.max_size_rec_height
                
                    % here we try all the start position possible
                    for x = obj.img_min_pos:obj.img_max_pos
                        for y = obj.img_min_pos:obj.img_max_pos
                            obj = haar_like_1([x,y], width_x, height_y);

                            if obj.valid == 0
                                % its placed outside the image window, so its
                                % not valid. we dont count this one.
                                % *NOTE* Originally it was intented to be
                                % checked directed in here, but in the end
                                % the class' "valid" property was already
                                % implemented so we used it insted to evoid
                                % double check.
                                break;
                            else
                                % the haar-like feature is correct so we count
                                % it
                                num_haar = num_haar + 1;
                                data_haar(num_haar,:) = [x y width_x height_y obj.type]; 
                            end
                        end
                    end
                end
            end
            
        end
    end
    
    methods(Static)
        %% create_base_square
        % in order to not to repeat code, we have defined here an standard
        % function to create one square.
        function res=create_base_square(start_x, start_y, width_x, height_y)
            x_increment = start_x + width_x;
            y_increment = start_y + height_y;
            
            res=[start_x     start_y;
                 x_increment start_y;
                 x_increment y_increment;
                 start_x     y_increment;
                 start_x     start_y];
        end
        
        %% calc_haar_square_integral
        % calculates the value of one (random) square using an integral 
        % image
        % my_square: coordinates of an square.
        % my_ii: integral image as it was made by the Matlab instruction
        % integralImage()
        function res=calc_haar_square_integral(my_square, my_ii)
            % We must be note that the
            % representation of the image 24x24 with the haar-like features
            % starts with the coordinate [1 1] and ends in the coordinate
            % [25,25] due it adding a new file and a new row of zeroes.
            %
            % The integral image, as its made by matlab, adds a new
            % line and row, all zeroes in the first line and first row.
            % so we must fix  that.
            %
            % We are using a grid so we should be careful with the
            % coordinates. in this case, if the height and width are 1, all
            % the points are the same
            
            % this variables will work as a sintax sugar
            sq_top_left = 1;
            sq_top_right = 2;
            sq_bottom_right = 3;
            sq_bottom_left = 4;
            
            sq_x = 1;
            sq_y = 2;
            
            % We must ensure we dont go out of the borders of the ii so for
            % that we have to check some stuff. 
            if ((my_square(sq_top_left, sq_x) == 1) &&...
                (my_square(sq_top_left, sq_y) == 1))
                % case we are in the top left. Then the third component of
                % the square applied to the integral image have the value
                % we want
                % note: check if all this calculations would be better
                % be done when we create the haar-like feature intead of
                % here
                res = my_ii(my_square(sq_bottom_right, sq_y),...
                            my_square(sq_bottom_right, sq_x));
                
            elseif (my_square(sq_top_left, sq_x) == 1)
                % case we are in the left, but not in the top. In this
                % case we only have to substract the top part that doesnt
                % belong to our square
                res = my_ii(my_square(sq_bottom_right, sq_y),...
                            my_square(sq_bottom_right, sq_x))...
                    -...
                      my_ii(my_square(   sq_top_right, sq_y),...
                            my_square(   sq_top_right, sq_x));
                  
            elseif (my_square(sq_top_left, sq_y) == 1)
                % case we are in the top, but not in the left. In this
                % case we only have to substract the left part that doesnt
                % belong to our square
                'case 3';
                res = my_ii(my_square(sq_bottom_right, sq_y),...
                            my_square(sq_bottom_right, sq_x))...
                    -...
                      my_ii(my_square( sq_bottom_left, sq_y),...
                            my_square( sq_bottom_left, sq_x));
                  
            else
                % case we are in the top left
                % rest of the cases, we do the 4 operations, substract the
                % top part, substract the left part, and add the top-left
                % part
                res = my_ii(my_square(sq_bottom_right, sq_y),...
                            my_square(sq_bottom_right, sq_x))...
                    - ...
                      my_ii(my_square(   sq_top_right, sq_y),...
                            my_square(   sq_top_right, sq_x))...
                    - ...
                      my_ii(my_square( sq_bottom_left, sq_y),...
                            my_square( sq_bottom_left, sq_x))...
                    + ...
                      my_ii(my_square(    sq_top_left, sq_y),...
                            my_square(    sq_top_left, sq_x));
                  
            end
        end
        
    end
    
    
end

