function [ error_rate, error_counter, list_size, image_error_list ] = test_list_with_sc( strong_class, folder_adress, is_face )
%TEST_LIST_WITH_SC test a list of images with an strong classifier
%   serves to check a big list of images against a strong classifier.
    images_test_list = get_image_list(folder_adress); 

    list_size = size(images_test_list);
    list_size = list_size(2);

    error_counter = 0;
    image_error_list = [];

    for i = 1:list_size
        % 
        test_image = get_image(images_test_list{i});
        my_result = strong_class.classify_image(test_image);
        if my_result~=is_face
            error_counter = error_counter + 1;
            image_error_list{error_counter} = images_test_list{i};
        end
    end
    
    error_rate = error_counter/list_size;
    
end

