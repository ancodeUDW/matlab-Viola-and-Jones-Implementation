function show_training_result( faces_values, no_faces_values, alpha_value, threshold_value, title_stuff);
%SHOW_TRAINING_RESULT Summary of this function goes here
%   Detailed explanation goes here
    %% show the weights in a visual way
    % close all
    size_faces = ones(length(faces_values))*0.5;
    size_no_faces =  ones(length(no_faces_values))*1.5;
    
    x_thres = [1 1] * threshold_value;
    y_thres = [-1 3];

    if alpha_value < 0 % paint red the non faces
        my_limit = max([max(faces_values), max(no_faces_values)]);
    else
        my_limit = min([max(faces_values), min(no_faces_values)]);
    end

    my_area_x = [threshold_value my_limit my_limit threshold_value];
    my_area_y  = [-1 -1 3 3];


    figure;
    a = area(my_area_x, my_area_y);
    non_faces_area_color = [255/255 214/255 214/255];
    a.FaceColor = non_faces_area_color;
    a.EdgeColor = non_faces_area_color;
    hold on;
    show_std_deviation(faces_values, 'b--');
    show_std_deviation(no_faces_values, 'r--');
    plot(faces_values, size_faces, 'b--o', no_faces_values, size_no_faces, 'r--o', x_thres, y_thres, 'g--');
    % text(faces_values, size_faces, num2str(faces_values));
    title(title_stuff);
    ylim([-1 3]);

end

function show_std_deviation(group_values, my_color)
    x_lin_base = [1 1];
    y_lin_base = [-1 3];
    std_dev = std(group_values, 1)*1.05;
    
    center_point = mean(group_values);
    
    plot(x_lin_base*(center_point + std_dev), y_lin_base, my_color, x_lin_base*(center_point - std_dev), y_lin_base, my_color)
end

