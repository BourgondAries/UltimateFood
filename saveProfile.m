function saveProfile(profile_name, nutrients, values )
    %Formatting:
    nut_str = '';
    for i=3:length(nutrients)
        if i == 3
            nut_str = [nut_str nutrients{i}];
        else
            nut_str = [nut_str ' ' nutrients{i}];
        end
    end
    values_str = '';
    for i=1:length(values)
        if i == 1
            values_str = [values_str num2str(values(i))];
        else
            values_str = [values_str sprintf('\t') num2str(values(i))];
        end
    end
    %End formating
        
    fileID = fopen('profiles.txt');
    file_to_cell_row = textscan(fileID,'%s',Inf,'Delimiter','\n');
    fclose(fileID);
    
    file_to_cell = transpose(file_to_cell_row{1});
    index_pname = find(strcmp(file_to_cell, ['%' profile_name]));  
      
    if numel(index_pname) == 0
        fileID = fopen('profiles.txt', 'a+');
    
        if (fileID ~= -1)
            fprintf(fileID, '\n%s%s', '%', profile_name);
            fprintf(fileID,'\n%s%s\n', '%', nut_str);
            fprintf(fileID, '%s', values_str);
        end
        
    else
        
        file_to_cell{index_pname(1)} = ['%' profile_name];
        file_to_cell{index_pname(1) + 2} = values_str;
        
        fileID = fopen('profiles.txt', 'w');
        fprintf(fileID, '%s\n', file_to_cell{1:end-1});
        fprintf(fileID, '%s', file_to_cell{end});

    end
      
fclose(fileID);
    
end