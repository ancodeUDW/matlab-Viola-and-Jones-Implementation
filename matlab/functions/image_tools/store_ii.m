%% Creation of the integral images
% * *Autor*: Jose Ramon Raindo Portillo
% * *Date last modification*: 18/01/2015
% * *Version*: 1.0

%% STORE_II
% stores integral image in a binary file
function store_ii(file_name, my_variable )
    my_ii=my_variable;
    save(file_name, 'my_ii');
end

