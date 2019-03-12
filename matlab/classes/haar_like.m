%% class haar_like
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 04/01/2015
% * *Version*: 1.0

%% TODO: 
% * http://es.mathworks.com/help/matlab/math/multidimensional-arrays.html
%  CAREFUL WITH MULTIDIMENSIONAL ARRAYS CUZ WE MUST USE THEM IN THE
%  RECTANGLES!!!
%

%%
% implementation of the Haar-like features. In this implementation we only
% take in account 2 haar-like types, but it can change in the future
%
% by now we assume than the basic type is one pixel by one pixel
% but that may change in the future. this is the structure with 2
% rectangles, one on the top of the other
classdef haar_like
    properties (Constant)    
        % general constants
        % more like limitations
        % original not limited version commented:
        
        % img_min_pos=1;
        % img_max_pos=24;
        %
        % min_size_rec = 1; % max possible is 1
        % max_size_allowed = 24 % max possible is 24
        %
        % type_max_size_rec_height  = [12 24 24];  % type 1: 12*2 = 24 - to remove limitations change 22 to 24
        % type_max_size_rec_width   = [24 12  8];
        
        % limitations: in this case we will ignore the border of the
        % windows
        img_min_pos=2; % our min position is 2, 2
        img_max_pos=23; % our max position is 23, 23
        
        min_size_rec = 2; % max possible is 1
        max_size_allowed = 24 % max possible is 24
        

        % type 1: 12*2 = 24 - to remove limitations change 22 to 24
        % type 2: 12*2 = 24
        % type 3:  4*3 = 24
        
        
        type_max_size_rec_height  = [10 20 20];  % type 1: 12*2 = 24 - to remove limitations change 22 to 24
        type_max_size_rec_width   = [20 10  7];  % type 2: 12*2 = 24
%                                                  % type 3:  4*3 = 24

        % ################################################################
        % properties type 1 - rectangle on the top rectangle on the bottom
        % this properties are in the position 1 of the type variables
        %
        % properties type 2 - rectangle on the left rectangle on the right
        % this properties are in the position 2 of the type variables
        %
        % properties type 3 - - white-black-white - OPTIONAL
        % this properties are in the position 3 of the type variables
        %
        %                   [   ]
        %                   [#]    [   ][#]    [  ][#][  ]
        %                 type 1   type 2      type 3
        %
        % ################################################################
        
        type_height_mult = [2 1 1] % basically, the number of rectangles stack on the top of the other that there are in the haar-like feature
        type_width_mult  = [1 2 3] % basically the number of rectangles next one of another that you can find in the haar-like feature
        
        % the max sizes allowed for each type of haar-like feature
        

        type_allowed = [1 2 3]; % the types of haar like features we allow
        type_num_white_rec = [1 1 2];
        type_num_black_rec = [1 1 1]
    end
    
    properties
        
        % type of the haar-like feature
        type = 1;
        
        % is it valid? 0 = No, 1 = Yes
        valid = 0;
        
        % here define the haar-like rectangles
        % start_point is the point where the first rectangle starts. It is
        % saved in a [x y] fashion. by default the origin point is stored
        start_point = [1 1]; % the point in where the rectangles starts.
        end_point = [1 1]
        
        % the width and height of the rectangles (we will use equal sizes
        % rectangles for all the rectangles we will create here)
        my_width = 1; % the width of the individual rectangle
        my_height = 1; % the height of the individual rectangle
    end
    
    methods
        
        %% creation of the object
        function obj=haar_like(start_point, my_one_rec_width, my_one_rec_height, my_type)
            %
            % start_point: where the haar-like figure should start
            % my_one_rec_with: the width of one of the harr like figures
            % my_one_rec_height: the height of one of the harr like figures
            % my_type: one of the 3 types of harr_like figures we will use.
            %
            % a verification needs to be done - the square must be inside 
            % a 24x24 grid: the start point must be greather than [0 0] and
            % start_point + [my_one_rec_width*width_mult my_one_rec_height*height_mult] must be smaller than
            % [24 24], and of course, integer
            
            % the representation of this haar-like feature is according the
            % rectangle that will be outside, so instead of using the 24 as
            % a limit, we use 24 + 5. this we will ensure that we dont left
            % the last pixels of the square whitout attending
            
            x = 1; % we define this as sintactic sugar
            y = 2;
            
            if any(obj.type_allowed == my_type)
                % the type selected is an allowed type
                % we calcule the end point to be used as a reference in the
                % following comparation, and also in other operations
                % around the haar-like class
                obj.type = my_type;
                my_end_point = [
                    start_point(x) + my_one_rec_width * obj.type_width_mult(my_type) ...
                    start_point(y) + my_one_rec_height * obj.type_height_mult(my_type) ...
                    ];
                
                % we calculate the end point and verify it doesnt go
                % outside the end of the windows - 24x24 - and that the
                % start point doesnt go outside the start of the windows
                % 1x1
                if ( my_end_point(x) > obj.img_max_pos + 1 || ... % the coordiantes are saved adding 1 ...
                     my_end_point(y) > obj.img_max_pos + 1 || ... % ... to the width the last pixel is not selected
                     start_point(x) < obj.img_min_pos || ...
                     start_point(y) < obj.img_min_pos    ...
                    )
                    obj.valid = 0;
                else
                    % we can initializate the variables
                    obj.valid = 1;
                    
                    % with the start and end point we can figure how the
                    % full shape of the haar-like figure looks like.
                    obj.start_point = start_point;
                    obj.end_point = my_end_point;

                    obj.my_width = my_one_rec_width;
                    obj.my_height = my_one_rec_height;
                end

            else
                % the type selected isn't an allowed type
                obj.valid = 0;
            end

        end
        
        %% black_rec
        % in this implementation we dont have any haar-like feature with
        % more than a black rectangle, but we wanted to keep the posibility
        % for the future. In this case, we return only one variable, but
        % from now on we will access to the black square 
        function res=black_rec(obj)
            x = 1;
            y = 2;
            
            switch obj.type
                case 1
                    res = create_rectangle(obj,...
                                        obj.start_point(x),...
                                        obj.start_point(y) + obj.my_height);
                    
                otherwise % both cases 2 and 3 are fundamentally the same
                    res = create_rectangle(obj,...
                                        obj.start_point(x) + obj.my_width,...
                                        obj.start_point(y));
                
            end
        end
        
        %% white_rec
        % the white rectangle is at the top of the black rectangle
        function res=white_rec(obj)
            x = 1;
            y = 2;
            % there is always this white square
            res = create_rectangle(obj, obj.start_point(x), obj.start_point(y));
            
            switch obj.type                  
                case 3
                    % if we are in the case 3, there are 2 white rectangles
                    % [ ][#][ ]. the second triangle starts after the black
                    % (second) triangle, that is my_width * 2. WE ARE USING
                    % MULTIDIMENSIONAL ARRAYS - 3D ARRAY - SO CHECK THE WAY
                    % WE ACCESS TO IT!!!
                    % again, new_rect works as sintactic sugar for not
                    % having a long line in the sect_rect_list part
                    
                    new_rect = create_rectangle( ...
                                    obj, ...
                                    obj.start_point(x) + obj.my_width * 2, ...
                                    obj.start_point(y));
                                
                    res = obj.set_rect_list(res, new_rect, 2);
            end
            
            
        end
        

        %% create_rectangle
        % in order to not to repeat code, we have defined here an standard
        % function to create one square.
        function res=create_rectangle(obj, start_x, start_y)
            res = obj.create_base_rectangle(start_x, ...
                                     start_y, ...
                                     obj.my_width, ...
                                     obj.my_height); % if using a basic type, check the type before deciding to multiply this one or the other
        end
        
        
        %% calculate Haar value
        % calculate Haar value of a grayscale image
        function res=calc_haar(obj, my_image)
            % If this dont work, check that is an integer and not an 
            % unsigned integer
            
            if obj.valid
                res = obj.calc_haar_rec(obj.white_rec, obj.num_white_rec, my_image)...
                    - obj.calc_haar_rec(obj.black_rec, obj.num_black_rec, my_image);
            else
                res = -1;
            end
        end

        
        
        %% calculate Haar value Integral
        % calculate Haar value of a grayscale integral image
        function res=calc_haar_integral(obj, my_ii)
            if obj.valid
                res = obj.calc_haar_rec_integral(obj.white_rec, obj.num_white_rec, my_ii);
                res = res - obj.calc_haar_rec_integral(obj.black_rec, obj.num_black_rec, my_ii);
            else
                res=-1;
            end
        end
        
        
        %% calc_haar_rec_integral
        % calculates the value of one type of square using an integral
        % image. in particular, this function checks if there are more than
        % one rectangle in the variable and calcules the number of all the
        % rectangles
        function res = calc_haar_rec_integral(obj, my_rec, num_rect, my_image)
             res = 0;

            if num_rect == 1
                res = obj.calc_haar_rec_integral_individual(my_rec, my_image);
            else
                for i=1:num_rect
                    % MULTIDIMENSIONAL ARRAY, WE SHOULD ACCESS TO EACH
                    % MATRIX IN A PROPER WAY!!!
                    res = res + obj.calc_haar_rec_integral_individual(obj.get_rect_list(my_rec, i), my_image);
                end
            end
        end
        
        
        %% calc_haar_rec
        % calculates the value of one type of square using a grayscale
        % image. in particular, this function checks if there are more than
        % one rectangle in the variable and calcules the number of all the
        % rectangles
        function res=calc_haar_rec(obj, my_rec, num_rect, my_image)
             res = 0;

            if num_rect == 1
                res = obj.calc_haar_rec_individual(my_rec, my_image);
            else
                for i=1:num_rect
                    % MULTIDIMENSIONAL ARRAY, WE SHOULD ACCESS TO EACH
                    % MATRIX IN A PROPER WAY!!!
                    res = res + obj.calc_haar_rec_individual(obj.get_rect_list(my_rec, i), my_image);
                end
            end
        end
        
        %% calc_haar_rec_individual
        % calculates the value of one square using a grayscale image
        function res=calc_haar_rec_individual(obj, my_rect, my_image)
            % We must be note that the
            % representation of the image 24x24 with the haar-like features
            % starts with the coordinate [0 0] and ends in the coordinate
            % [23,23]. As matlab uses vectors and matrix that are indexes
            % starting 1, a correction must be used when we access to the
            % image (adding 1).
            
            % note: images are uint8, that means they have a limit of 255.
            % take this in account when you have to add the values in res
            
            my_start_point = my_rect(1,:);
            res = 0;
            my_x = 1;
            my_y = 2;

            for i = my_start_point(my_x):my_start_point(my_x) + obj.my_width-1
                for j = my_start_point(my_y):my_start_point(my_y) + obj.my_height-1
                    res = res + int32(my_image(j, i)); % must make the conversion, if not  its from 0 to 256
                end
            end

        end
        
        function res = return_grid_rectangle(obj)
             % main grid
            res=[1                     1;
                (obj.img_max_pos + 1)  1
                (obj.img_max_pos + 1) (obj.img_max_pos + 1)
                1                     (obj.img_max_pos + 1)
                1                      1];

        end
       
        
        %% plot rectangle
        % plots the haar-like rectangles in a 24x24 grid. we can chose
        % which one to plot, the black or the white. Must note that the
        % plots and areas used in this fuctions uses X, Y type parameters,
        % but the Images themselves use coordinates in the type Y, X
        function my_plot = plot_rectangle(obj)
            recToPlot='haar like figure';
            
            % haar-like rectangles
            my_rec_black = obj.black_rec();
            my_rec_white = obj.white_rec();
  
            % main grid
            main_square = obj.return_grid_rectangle();
            
            % plot everything
            figure
            
            % an square symbolizing the image
            my_plot = plot( main_square(:,1), main_square(:,2),...
                  'LineWidth',2); 
            hold on;
           	grid on;

            % the white rectangle
            for i=1:obj.get_rect_size(my_rec_white)
                % print all the white rectangles. as much we will have 2
                obj.get_rect_size(my_rec_white)
                my_uni_rec = obj.get_rect_list(my_rec_white, i);
                plot(my_uni_rec(:,1), my_uni_rec(:,2),...
                     'color', 'black',...   
                     'LineWidth',2);    
            end

             
            % the black rectangle
            for i=1:obj.get_rect_size(my_rec_black) 
                % in every iteration, print a black retangle
                % actually is not expected to have more than one rectangle,
                % but in the future the system can be extended to have more
                % than 3 harr-like feature, with several black squares
                % combinations.
                my_uni_rec = obj.get_rect_list(my_rec_black, i);
                plot(my_uni_rec(:,1), my_uni_rec(:,2),...
                     'color', 'black',...   
                     'LineWidth',2);
                 
                fill(my_uni_rec(:,1), my_uni_rec(:,2), 'k'); % in the original this was "area" but it doesnt work, because it does the actual area, not the inside area of the rectangle we print.
            end
                        
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
        %
        % #################################################################
        % **WARNING** this function will erase the data from the
        % haar-like-1 object
        % #################################################################
        %
        % num_haar: num of type 1 haar-like features that exist inside a
        % 24x24 window.
        % data_haar: vector with [x,y,width,height, type_of_haar] components that
        % describes all the possible haar-like features
        %
        function [num_haar, data_haar]=count_all_haar_like(obj)
            num_haar=0;
            data_haar = [0, 0, 0, 0, 0];
            num_haar_like_types = size(obj.type_allowed);
            num_haar_like_types = num_haar_like_types(2);
            current_type = obj.type;
            
            % with this we try all the haar-like rectangles size
            % combinations
            % for current_type=1:num_haar_like_types
                for width_x = obj.min_size_rec:obj.max_size_rec_width()
                    for height_y = obj.min_size_rec:obj.max_size_rec_height()
                        % here we try all the start position possible
                        for x = obj.img_min_pos:obj.img_max_pos
                            for y = obj.img_min_pos:obj.img_max_pos
                                obj = haar_like([x,y], width_x, height_y, current_type);

                                if obj.valid == 0 % is only valid when is 1
                                    % its placed outside the image window, so its
                                    % not valid. we dont count this one.
                                    % *NOTE* Originally it was intented to be
                                    % checked directed in here, but in the end
                                    % the class' "valid" property was already
                                    % implemented so we used it insted to avoid
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
            %end
        end
        
                
        %% Getters of the rectangles
        % num of white and black rectangles than the haar-like feature have
        % this will be useful to calculate the values in a general way,
        % whitout caring of if there are more than one white rectangle or
        % not      
        function res = num_white_rec(obj)
            res = obj.type_num_white_rec(obj.type);
        end
        
        function res = num_black_rec(obj)
            res = obj.type_num_black_rec(obj.type);
        end
        
        %% Getters of the multipliers
        % the multiplicators to calculate the final points. They represent
        % the number of stacked rectangles, in the case of the heigh and
        % the number of line up rectangles in the case of the width. in
        % this case we dont care about the rectangle's colors
        function res = height_mult(obj)
            res = obj.type_height_mult(obj);
        end
        
        function res = width_mult(obj)
            res = obj.type_width_mult(obj);
        end

        %% Getters of the max sizes allowed for each type of haar-like feature
        function res = max_size_rec_height(obj)
            res = obj.type_max_size_rec_height(obj.type);
        end
        
        function res = max_size_rec_width(obj)
            res = obj.type_max_size_rec_width(obj.type);
        end
    end
    
    methods(Static)
        
        %% rectangle list getters and setters
        % of a 3d matrix used to store haar-like features
        
        % returns a group like rect_group but with a rectangle new_rect
        % inside rect_group(:,:,my_index).
        function rect_group = set_rect_list(rect_group, new_rect, my_index)
            rect_group(:,:, my_index) = new_rect;
        end
        
        % returns the rectangle that was inside rect_group(:, :, my_index)
        function res = get_rect_list(rect_group, my_index)
            res = rect_group(:,:, my_index);
        end
        
        function res = get_rect_size(rect_group)
            my_size = size(rect_group);
            size_of_size = size(my_size);
            
            if size_of_size(2) == 2
                res = 1;
            elseif size_of_size(2) > 2
                res = my_size(3);
            else
                res = 0;
            end
        end
        
        
        
        %% create_base_rectangle
        % in order to not to repeat code, we have defined here an standard
        % function to create one square.
        function res=create_base_rectangle(start_x, start_y, width_x, height_y)
            x_increment = start_x + width_x;
            y_increment = start_y + height_y;
            
            res=[start_x     start_y;
                 x_increment start_y;
                 x_increment y_increment;
                 start_x     y_increment;
                 start_x     start_y];
        end
        
        %% calc_haar_rec_integral
        % calculates the value of one (random) square using an integral 
        % image
        % my_rect: coordinates of an square.
        % my_ii: integral image as it was made by the Matlab instruction
        % integralImage()
        function res=calc_haar_rec_integral_individual(my_rect, my_ii)
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
            if ((my_rect(sq_top_left, sq_x) == 1) &&...
                (my_rect(sq_top_left, sq_y) == 1))
                % case we are in the top left. Then the third component of
                % the square applied to the integral image have the value
                % we want
                % note: check if all this calculations would be better
                % be done when we create the haar-like feature intead of
                % here
                res = my_ii(my_rect(sq_bottom_right, sq_y),...
                            my_rect(sq_bottom_right, sq_x));
                
            elseif (my_rect(sq_top_left, sq_x) == 1)
                % case we are in the left, but not in the top. In this
                % case we only have to substract the top part that doesnt
                % belong to our square
                res = my_ii(my_rect(sq_bottom_right, sq_y),...
                            my_rect(sq_bottom_right, sq_x))...
                    -...
                      my_ii(my_rect(   sq_top_right, sq_y),...
                            my_rect(   sq_top_right, sq_x));
                  
            elseif (my_rect(sq_top_left, sq_y) == 1)
                % case we are in the top, but not in the left. In this
                % case we only have to substract the left part that doesnt
                % belong to our square
                'case 3';
                res = my_ii(my_rect(sq_bottom_right, sq_y),...
                            my_rect(sq_bottom_right, sq_x))...
                    -...
                      my_ii(my_rect( sq_bottom_left, sq_y),...
                            my_rect( sq_bottom_left, sq_x));
                  
            else
                % case we are in the top left
                % rest of the cases, we do the 4 operations, substract the
                % top part, substract the left part, and add the top-left
                % part
                res = my_ii(my_rect(sq_bottom_right, sq_y),...
                            my_rect(sq_bottom_right, sq_x))...
                    - ...
                      my_ii(my_rect(   sq_top_right, sq_y),...
                            my_rect(   sq_top_right, sq_x))...
                    - ...
                      my_ii(my_rect( sq_bottom_left, sq_y),...
                            my_rect( sq_bottom_left, sq_x))...
                    + ...
                      my_ii(my_rect(    sq_top_left, sq_y),...
                            my_rect(    sq_top_left, sq_x));
                  
            end
        end
        
    end    
end

