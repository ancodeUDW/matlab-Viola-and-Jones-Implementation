%% Creation of the integral images
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 18/01/2015
% * *Version*: 1.0

%% load_ii
% loads integral image from a binary file
function res = load_ii(file_name)
%STORE_II stores integral image in a binary file
%   Detailed explanation goes here
    load(file_name, 'my_ii')
    res = my_ii;
end

