function saveProfile(profile_name, values )

fileID = fopen('profiles.txt', 'a+');

if (fileID ~= -1)
    fprintf(fileID, '\n%s%s', '%', profile_name);
    fprintf(fileID,'\n%sEnergy		Carbohydrates		Fat		Proteins	Fiber		Cholesterol','%');
    nbytes = fprintf(fileID,'\n%.0f\t\t%.3f\t\t\t\t%.3f\t%.3f\t\t%.3f\t\t%.4f', values(1),values(2),values(3),values(4),values(5),values(6));
    disp(nbytes)
else
    fprintf('Something went wrong');
end

fclose(fileID);
end