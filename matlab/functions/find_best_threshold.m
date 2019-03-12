%% function find_best_threshold
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 16/04/2016
% * *Version*: 1.1
%
% this function was texted and fixed at 16/04/2016 to simplify the processs
% and check from errors.
%
% there are a lot of methods to find a suitable threshold, depending of the
% stadistics values of the faces and non faces, but in this project I have
% decided to keep it simple, so the threshold will be around the middle
% point between the biggest value from one of the groups and the smallers
% value of the other group. There is a special case, though, in where the
% values are "fuzzy", so in that case a special threshold value would be
% used.

% NOTE: study if to introduce this in the weak classifier function so its
% automated using that class.
function [ my_alpha, my_threshold, sort_faces, sort_no_faces ] = find_best_threshold(FACES, NO_FACES)
    % sort the values to find the threshold
    sort_faces = sort(FACES);
    sort_no_faces = sort(NO_FACES);
    
    [ my_alpha, my_threshold] = find_best_threshold_cases(sort_faces, sort_no_faces);
    
    if my_alpha == 0
        % the groups are mixed, but it could be due outliers, so we get rid
        % of them and try again
        % process outliers
        sort_faces_out = erase_outliers(FACES);
        sort_no_faces_out = erase_outliers(NO_FACES);
        % check if we have better luck with outliers out
        [ my_alpha, my_threshold] = find_best_threshold_cases(sort_faces_out, sort_no_faces_out);
        
        
    end
    
    if my_alpha == 0
        % at this point we know that the groups are mixed, so we will use
        % another method to find the threshold and the alpha
        [my_alpha, my_threshold] = hard_case_solver(FACES, NO_FACES);
    end
    
%     datafeatures = [FACES NO_FACES];
%     dataclass = [ones(size(FACES)) ones(size(NO_FACES))*-1];
%     total_length = length(datafeatures);
%     dataweight=ones(total_length,1)/total_length;
%     [estimateclass,err,h] = WeightedThresholdClassifier(datafeatures,dataclass,dataweight);
%     my_threshold = h.threshold ; 
%     my_alpha = h.direction;

end


function [ my_alpha, my_threshold ] = hard_case_solver(FACES, NO_FACES)
% simple metohd to solve the threshold problem. in the case some of the
% elements are mixed, we will search for the mean values and do the middle
% point between them.
    faces_are_bigger  =  1;
    faces_are_smaller = -1;
    first_element = 1;
        
    % organization of faces non faces gave me a big bug before, so we will
    % do it here.
    
    % experimental! get rid of the outliers
   
   mean_faces = mean(FACES);
   mean_no_faces = mean(NO_FACES);
   
   my_threshold = (mean_faces + mean_no_faces)/2;
   my_alpha = mean_faces >= mean_no_faces;
   
   if my_alpha ==0
       my_alpha = -1;
   end
   
end

function [ my_alpha, my_threshold ] = find_best_threshold_cases(FACES, NO_FACES)
%FIND_BEST_THRESHOLD finds the best threshold
%   given two haar-like feature value result groups, gives the best
% treshold. my_A are the "faces" and my_B are the "non faces".
% Prerequisite: both are ordererd lists!!
%
% by threshold we mean the number that will be the limit to decide if the
% image is a face or not.
% 
%           if a value falls:
%
%          belongs to A                                    belongs to B
%               V                                                       V
%    values classification A  | threshold | values classification B
%
%
% if threshold works as a limit to classify in the group A or the group B,
% my_alpha works as the identificator of witch group is each of the 2 sides
% of the classification values. this means the following
%
% * if FACES <= threshold <= NO FACES,    alpha is -1
% * FACES >= threshold >= NO FACES,       alpha is  1

% note: the default behavior of the comparator is 
%
% isface = value_to_check >= threshold
    
    faces_are_bigger  =  1;
    faces_are_smaller = -1;
    first_element = 1;
    my_alpha = 0;
    my_threshold = 0;
    
    % organization of faces non faces gave me a big bug before, so we will
    % do it here.
    FACES = sort(FACES);
    NO_FACES = sort(NO_FACES);
    
    % experimental! get rid of the outliers
    % NOTE: do this only in the hard cases
    % FACES = erase_outliers(FACES);
    % NO_FACES = erase_outliers(NO_FACES);

    if NO_FACES(end) <= FACES(first_element)
                %
        %
        %     faces =                              [ a b c d e f g h i]
        %     non_faces=  [j k l m n o p q r s]
        %
        
        %  NO FACES <= threshold <= FACES
        %
        % FACES is essentially bigger than NO FACES
        % 
        % this is the expected default result, FACE values must be bigger
        % than NO FACES. So in this case, alpha should be 1 and
        %
        % isface = value_to_check >= threshold
        %
        my_alpha = faces_are_bigger;
        my_threshold = get_middle_point_th(FACES(first_element), NO_FACES(end)); % we find the optimal threshold
        
    elseif FACES(end) <= NO_FACES(first_element)
        %  FACES <= threshold <= NO FACES
        %
        % NO FACES is essentially bigger than FACES
        %
        % this is the oposite case of the default, so we have
        % 
        % is_face = value_to_check <= threshold
        %
        % in this case, we should multiply both sides by -1 so we can make
        % 
        % is_face = -value_tocheck >= -threshold
        %
        % this -1 we multiply is the alpha
        %
        %
        %     faces = [ a b c d e f g h i]
        %     non_faces                    [j k l m n o p q r s]
        %
        
        
        my_alpha = faces_are_smaller;
        my_threshold = get_middle_point_th(FACES(end), NO_FACES(first_element)); % we use that one as optimal theshold
        
    end
        % A intersection B exist and its several numbers. Another approach
        % is necessary.
        %
        %
        %
        %     faces = [ a b c d e f g h i]
        %     non_faces            [j k l m n o p q r s]
        %
        %
        %
        %     faces =                           [ a b c d e f g h i]
        %     non_faces            [j k l m n o p q r s]
        %
        %
        %
        %
        %     faces =               [ a b c d e f g h i]
        %     non_faces      [j  k  l  m  n  o  p  q  r  s]
        %
        %
        %
        %     faces =            [ a  b  c  d  e  f  g  h  i]
        %     non_faces            [j k l m n o p q r s]
        %
        
        % [my_alpha, my_threshold] = find_best_threshold_mixed_groups(FACES, NO_FACES);
    
    % note: my_alpha denotes if the values of the faces must be bigger or
    % smaller than the threshold. this way we can say that: 
    %
    % my_alpha*result > my_alpha*thres
    %
    % if the faces are bigger: my_alpha  =  1
    % if the faces are smaller: my_alpha = -1
    % 
    % cuz we check always if the result is minor than the threshold
    % in this case pos_is_bigger = alpha
end


function [ faces_are_bigger, my_threshold ] = ... 
                               find_best_threshold_mixed_groups(FACES, NO_FACES)
    % after thinking about it, this function need to be improved.
    % First of all we need to get what is the common group from both sides
    
    first_element = 1;
    is_true  =  1;
    is_false = -1;
    faces_are_bigger = is_true;
        
    if FACES(first_element) < NO_FACES(first_element)
        disp(1)
        %
        %
        %     faces = [ a b c d e f g h i]
        %     non_faces            [j k l m n o p q r s]
        %
        
        % get all the elements from faces that are bigger than the first
        % element of no faces
        shared_in_faces = FACES(FACES>=NO_FACES(first_element));
        % get all the elements of no faces that are smaller than the last
        % element of faces
        shared_in_no_faces = NO_FACES(NO_FACES <= FACES(end));
        faces_are_bigger = is_false; % actually faces are smaller

        % note: there is also the following case:
        %     faces =      [ a b c d e f g h i]
        %     non_faces            [j k l m]
        % 
        % in this case we will have a bad weak classifier. But in all
        % honestly it was going to be bad anyway because this haar like
        % feature makes no difference between the two groups
        
    elseif NO_FACES(first_element) < FACES(first_element)
        disp('2')
        %
        %     faces =                        [ a b c d e f g h i]
        %     non_faces      [j k l m n o p q r s]        %
        %
        
        % get all the elements from faces that are smaller than the last
        % element of nonfaces
        shared_in_faces = FACES(FACES <= NO_FACES(end));
        % get all the element from no faces that are bigger than the first
        % element that faces
        shared_in_no_faces = NO_FACES(NO_FACES >= FACES(first_element));
        % we assume that faces are bigger, and is the default value
        
        % note: there is also the following case:
        %     faces =           [c d e f g h i]
        %     non_faces   [j k l m n o p q r s t]
        % 
        % in this case we will have a bad weak classifier. But in all
        % honestly it was going to be bad anyway because this haar like
        % feature makes no difference between the two groups


    else
        disp('else');
        % in this case, the faces and non_faces are all in the same range
        shared_in_faces = FACES;
        shared_in_no_faces = NO_FACES;       
        
        % in this case we should check the mean of both to see if the faces
        % tend to be bigger or not
        mean_faces = mean(shared_in_faces);
        mean_no_faces = mean(shared_in_no_faces);
        
        % we dont know if faces are bigger or not, so we check the mean
        % value of both vectors and compare witch one is bigger
        if mean_faces < mean_no_faces
            faces_are_bigger = is_false;
        end
    end
       
    mean_faces = median(shared_in_faces);
    mean_no_faces = median(shared_in_no_faces);
    my_threshold = get_middle_point_th(mean_faces, mean_no_faces);
    
end


%% old version of this function
function [ pos_is_bigger, my_threshold ] = ... 
                               find_best_threshold_mixed_groups_old(FACES, NO_FACES)
    % easy awnser: get the mean of both, and then get the middle point.
    
    % not-so easy awnser, get the mean of both, and then get the one with
    % the bigger mean and check how many numbers are mixed and how many are
    % actually bigger from one group to the other.
    
    % but that can be troublesome if there are outlier values. In order to
    % fix that, may be interesting compare the mean with the median.
    
    % must point out, our top priority is not to separate both groups in
    % an equal way. Instead is more important to chose a threshold that get
    % a correct classification of the my_A group, and then minimize the
    % number of errors in group_B. this is cuz group_B will be more random
    % by its own nature of "non-faces"
    
    % maybe the best approach is not to get the middle point of the mean,
    % but rather, get the mean, compare both of them, and then make the
    % threshold the biggest or smallest number of the 'faces' depending
    % witch mean is bigger.
    
    % yet, this is a weak classificator, so we have to ensure that its
    % better than chance, but it doestn need to be VEEEERY good. its the
    % combination of weak classifiers the one that will be strong. so
    % following this reasonment I reach the conclusion that the middle
    % point of both means is a correct - if not perfect - approach.
    
    %
    % actually the approach discussed before might not be the best one, so
    % I will try to make the mean of the SHARED group of values.
    
    is_true  =  1;
    is_false = -1;
    
    tf = ismember(FACES,NO_FACES);
    shared_in_faces = FACES(tf);
    tf = ismember(NO_FACES,FACES);
    shared_in_no_faces = NO_FACES(tf);
    
   

    mean_FACES = mean(shared_in_faces);
    mean_NO_FACES = mean(shared_in_no_faces);
    
    if mean_NO_FACES <= mean_FACES
        % the average of the common factors in faces 
        pos_is_bigger = is_true;
        my_threshold = get_middle_point_th(mean_FACES, mean_NO_FACES);
    else
        pos_is_bigger = is_false;
        my_threshold = get_middle_point_th(mean_NO_FACES, mean_FACES);
    end
    
end


function res = get_middle_point_th(a, b)
%GET_MIDDLE_POINT from two points, gets the middle point
%   from two points, gets the middle point. in the case the points are the
%   same, return that value.
    if a == b
        res = a;
    else
        res = (a+b)/2;
    end
end

function several_values = erase_outliers(several_values)
% in this function we try to get rid of the outliers via standard deviation
    std_dev = std(several_values)*1.05; % standard deviation tends to get rid of the 5% of the set, being it outliers or not, so we will increase the value a bit to include some of them
    center_point = mean(several_values);
    pos_treshold = center_point + std_dev;
    neg_treshold = center_point - std_dev;
    
    several_values(several_values > pos_treshold) = [];
    several_values(several_values < neg_treshold) = [];

    
end

