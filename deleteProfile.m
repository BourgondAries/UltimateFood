function deleteProfile(profile_name)

    fileID = fopen('profiles.txt');
    file_to_cell_row = textscan(fileID,'%s',Inf,'Delimiter','\n');
    fclose(fileID);
    
    file_to_cell = transpose(file_to_cell_row{1});
    index_pname = find(strcmp(file_to_cell, ['%' profile_name]));
    
    file_to_cell{index_pname(1):index_pname(1) + 2} = [];

    fileID = fopen('profiles.txt', 'w');
    fprintf(fileID, '%s\n', file_to_cell{1:end-1});
    fprintf(fileID, '%s', file_to_cell{end});
    
    fclose(fileID);
    
end

