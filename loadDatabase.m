%{
    Loads the database from foods.txt.
    foods.txt will contain the structure
    for the parsing algorithm.
%}
function [nutrient_names, food_names, food_nutrients] = loadDatabase()

    food_nutrients = load('foods.txt');
    fileID = fopen('foods.txt');
    
    nutrient_names = {};
    food_names = {};
    
    line = '%';
    while strcmp(line(1), '%')
       line = fgets(fileID);
    end

    line = fgets(fileID);
    line = line(2:length(line)-2);
    
    nutrient_names = strsplit(line, '\t');     %For cell to be returned
    
    nutrients = [];
    while ~feof(fileID)
        
        nut = fgets(fileID);
        nut = nut(2:length(nut)-2);
 
        if length(nutrients) == 0
            nutrients = [nutrients nut];
        else
            nutrients = [nutrients ' '];
            nutrients = [nutrients nut];
        end
        
        fgets(fileID);
        fgets(fileID);
        
    end
    
    food_names = strsplit(nutrients, ' ');

    fclose(fileID);

end