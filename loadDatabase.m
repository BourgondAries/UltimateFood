%{
    Loads the database from foods.txt.
    foods.txt will contain the structure
    for the parsing algorithm.
%}
function [nutrient_names, food_names, food_nutrients] = loadDatabase()

    food_nutrients = load('foods.txt');
    fileID = fopen('foods.txt');
    
    nutrient_names = [];
    food_names = [];
    
    line = '%';
    while strcmp(line(1), '%')
       line = fgets(fileID);
    end

    line = fgets(fileID);

    % Need to remove tabs:
    %{
    for i=1:(length(line)-2)

        if line(i) && line(i+1)
            line = [line(1:i-1) line(i+2:end)];
        end
    end
    %}
    
    %nutrient_names = strsplit(line, '\t');     For cell to be returned
    nutrient_names = line;
    
    while ~feof(fileID)
        nut = fgets(fileID);
        nut = nut(2:length(nut)-2);
        food_names = [food_names ' '];
        food_names = [food_names nut];
        fgets(fileID);
        fgets(fileID);
    end

    fclose(fileID);

end