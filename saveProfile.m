function saveProfile(profile_name, nutrients, values )

    fileID = fopen('profiles.txt', 'a+');
    
    if (fileID ~= -1)
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

            fprintf(fileID, '\n%s%s', '%', profile_name);
            fprintf(fileID,'\n%s%s\n', '%', nut_str);
            fprintf(fileID, '%s', values_str);
    else
        fprintf('Something went wrong');
    end

    fclose(fileID);
    
end