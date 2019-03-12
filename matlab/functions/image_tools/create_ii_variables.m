%% create_ii_variables
% create a list of variables in the target_folder. returns the adress of
% the variables, to be used with load_ii
function [ii_list, ii_list_identifier] = create_ii_variables(target_folder, pos_image_list, pos_image_list_counter)
    ii_list = cell(1, pos_image_list_counter);
    ii_list_identifier = cell(1, pos_image_list_counter);

    for i=1:pos_image_list_counter
        % create the new file name
        target_adress = [target_folder num2str(i) '.mat'];
        % adds the new file name to the positive list
        ii_list{i} = target_adress;

        % loads the image and makes them ii
        my_image_adress = pos_image_list{:,i};
        [my_image, is_useful] = create_standard_image(my_image_adress);
        
        my_IImage = integralImage(my_image);

        % stores them in the hard drive 
        store_ii(target_adress, my_IImage); 
        
        % creaes the identifier
        aux_identifier = strsplit(my_image_adress, '/');
        ii_list_identifier{i} = aux_identifier(end);
    end
    
end