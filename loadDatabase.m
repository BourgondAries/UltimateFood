%{
    Loads the database from foods.txt.
    foods.txt will contain the structure
    for the parsing algorithm.
%}
function [nutrient_names, food_names, food_nutrients] = loadDatabase(path)

    if ~exist('path', 'var')
        path = 'foods.txt';
    end
    
    food_nutrients = load(path);
    fileID = fopen(path);
    
    nutrient_names = {};
    food_names = {};
    
    line = '%';
    while strcmp(line(1), '%')
       line = fgets(fileID);
    end

    line = fgets(fileID);
    line = line(2:length(line)-2);
    
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