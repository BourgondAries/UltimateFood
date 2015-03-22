function [ index ] = isStringInArray( string, array )
    index = 1;
    while index <= numel(array)
        if strcmp(string, array{index})
            return;
        end
        index = index + 1;
    end
    index = 0;
end

