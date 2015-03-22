%{
    Loads the database from foods.txt.
    foods.txt will contain the structure
    for the parsing algorithm.
%}
function [nutrient_names, food_names, food_nutrients, units] = loadDatabase(path)

    if ~exist('path', 'var')
        path = 'foods.txt';
    end
    
    food_nutrients = load(path);
    fileID = fopen(path);
    
    nutrient_names = {};
    food_names = {};
    units = {};
    
    line = '%';
    i=1;
    while strcmp(line(1), '%')
       line = fgets(fileID);
       if strcmp(path, 'nutritional value.txt') && i == 2
           units = strsplit(line(2:end));
       end
    i = i + 1;       
    end

    line = fgets(fileID);
    line = line(2:length(line)-1);
    
    nutrient_names = strsplit(line, '\t');     %For cell to be returned
    
    food_names = {};
    while ~feof(fileID)
        
        nut = fgetl(fileID);
        nut = nut(2:length(nut));
 
        if length(food_names) == 0
            food_names = [food_names nut];
        else
            food_names = [food_names nut];
        end
        
        fgets(fileID);
        fgets(fileID);
        
    end

    fclose(fileID);

end