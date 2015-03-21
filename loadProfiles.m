function [profile_names, values] = loadProfiles( )

profile_names = {};
profiles = [];
source = 'profiles.txt';
values = load(source);
fileID = fopen(source);

line = '%';
while strcmp(line(1), '%')
   line = fgets(fileID);
end

while ~feof(fileID)

    line = fgets(fileID);
    line = line(2:end);
    if length(profiles) == 0
        profiles = [profiles line];
    else
        profiles = [profiles ' ' line];
    end
    fgets(fileID);
    fgets(fileID);
end

profile_names = strsplit(profiles, '\n');
profile_names = strtrim(profile_names);

profile_names(length(profile_names)) = [];
fclose(fileID);

end

