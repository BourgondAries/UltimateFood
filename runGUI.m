function runGUI()

    window = figure...
    (...
        'Visible', 'off',...
        'Name', 'Food Finder',...
        'MenuBar', 'none',...
        'DockControls', 'off',...
        'Position', [500, 250, 1000, 500]...
    );

    food_stuffs_table = uitable...
    (...
            'ColumnFormat', {'numeric', 'logical', 'bank'},...
            'ColumnEditable', [true],...
            'ColumnWidth', 'auto',...
            'RowName', [],...
            'Position', [20 80 500 400],...
            'CellSelectionCallback', @selectFood...
    );
        
    desired = uitable...
    (...
        'ColumnName', {'Resource', 'Amount', 'Importance'},...
        'ColumnFormat', {'numeric', 'numeric', 'bank'},...
        'ColumnEditable', [false true true],...
        'ColumnWidth', {110, 60},...
        'RowName', [],...
        'Position', [540 80 200 400]...
    );
        
	result = uitable...
    (...
        'ColumnName', {'Food', 'Amount'},...
        'ColumnFormat', {'numeric', 'numeric', 'bank'},...
        'ColumnEditable', [false false],...
        'ColumnWidth', {120 100 'auto'},...
        'RowName', [],...
        'Position', [760 80 220 400]...
    );
      
    compute_button = uicontrol...
    (...
        'Style', 'pushbutton', 'String', 'Compute',...
        'Position', [760 10 220 65],...
        'Callback', @compute...
    );
    
    reload_button = uicontrol...
    (...
        'Style', 'pushbutton', 'String', 'Reload',...
        'Position', [20 10 70 65],...
        'Callback', @reloadDatabase...
    );

    new_entry = uicontrol...
    (...
        'Style', 'pushbutton', 'String', 'New Entry',...
        'Position', [90 10 90 65],...
        'Callback', @createNewFoodEntry...
    );

    delete_entry = uicontrol...
    (...
        'Style', 'pushbutton', 'String', 'Delete Entry',...
        'Position', [180 10 100 65],...
        'Callback', @deleteFoodEntry...
    );

    entry_selected = uicontrol...
    (...
        'Style', 'edit', 'String', 'Index to delete',...
        'Position', [280 10 100 65]...
    );

    profile_menu = uicontrol...
    (...
        'Style', 'popupmenu',...
        'Position', [540 15 200 20],...
        'Callback', @loadProfile...
    );

    profile_textbox = uicontrol...
    (...
        'Style', 'edit',...
        'Position', [540 35 200 20]...
    );

    profile_save = uicontrol...
    (...
        'Style', 'pushbutton',...
        'String', 'Save Profile As',...
        'Position', [540 55 100 20],...
        'Callback', @saveProfileCallback...
    );

    profile_delete = uicontrol...
    (...
        'Style', 'pushbutton',...
        'String', 'Delete Profile',...
        'Position', [640 55 100 20],...
        'Callback', @deleteProfileCallback...
    );

    database_save = uicontrol...
    (...
        'Style', 'pushbutton',...
        'String', 'Save Database',...
        'Position', [420 10 100 65],...
        'Callback', @saveDatabaseCallback...
    );

    profile_values = {};

    reloadDatabase();
    
    function saveProfileCallback(source, callbackdata)
        index = isStringInArray(profile_textbox.String, profile_menu.String);
        if index
            if strcmp(questdlg('The profile already exists. Do you want to overwrite this profile?'), 'Yes')
                profile_values(index, :) = transpose(cell2mat(desired.Data(:, 2)));
                profile_menu.Value = index;
            else
                return;
            end
        else
            profile_menu.String{numel(profile_menu.String) + 1} = profile_textbox.String;
            profile_values = [profile_values; transpose(cell2mat(desired.Data(:, 2)))];
            profile_menu.Value = numel(profile_menu.String);
        end
        saveProfile(profile_textbox.String, transpose(food_stuffs_table.ColumnName), transpose(cell2mat(desired.Data(:, 2))));
        
        loadProfile();
    end

    function deleteProfileCallback(source, callbackdata)
        if numel(profile_menu.String) == 1
            msgbox('You can not delete the last profile.', 'Profile Message');
        elseif profile_menu.Value == numel(profile_menu.String)
            profile_menu.String(profile_menu.Value) = [];
            profile_menu.String(~cellfun(@isempty, profile_menu.String));
            profile_values(profile_menu.Value, :) = [];
            
            profile_menu.Value = profile_menu.Value - 1;
            loadProfile();
        else
            profile_menu.String(profile_menu.Value) = [];
            profile_menu.String(~cellfun(@isempty, profile_menu.String));
            profile_values(profile_menu.Value, :) = [];
            
            loadProfile();
        end
        
        %deleteProfile(profile_textbox.String, food_stuffs_table.ColumnName, desired);
    end
    
    function loadProfile(source, callbackdata)
        desired.Data = {};
        number_of_rows = numel(food_stuffs_table.ColumnName);
        index = 1;
        while index <= number_of_rows - 2 % <- changed from 2 to 3
            food_stuffs_table.ColumnName
            desired.Data = [desired.Data; food_stuffs_table.ColumnName(index + 2) profile_values(profile_menu.Value, index) 1];
            index = index + 1;
        end
        profile_textbox.String = profile_menu.String{profile_menu.Value};
    end
   
    function createNewFoodEntry(source, callbackdata)
        new_data = cell(1, numel(food_stuffs_table.Data(1, :)));
        new_data{1} = 'Name';
        new_data{2} = [true];
        
        index = 3;
        number_of_columns = numel(new_data);
        while index <= number_of_columns
            new_data{index} = [0];
            index = index + 1;
        end
        food_stuffs_table.Data = [food_stuffs_table.Data; new_data];
    end

    function setOutputTable(food_amount_array, deviation)
        deviation = cell2mat(desired.Data(:,2)) .* deviation;
        
        result.Data = {};
        index = 1;
        while index <= numel(food_stuffs_table.Data(:, 1))
            result.Data = [result.Data; food_stuffs_table.Data(index, 1) food_amount_array(index)];
            index = index + 1;
        end
        
        index = 3; % skip 'Food' and 'Include'
        while index <= numel(food_stuffs_table.ColumnName)-1 %Why is -1 needed??
            result.Data(index - 2, 4) = food_stuffs_table.ColumnName(index);
            result.Data(index - 2, 5) = {deviation(index - 2)};
            result.Data(index - 2, 6) = {deviation(index - 2) / desired.Data{index - 2, 2}};
            index = index + 1;
        end
        
        result.ColumnWidth(3) = {20};
        result.ColumnWidth(4) = {120};
        result.ColumnName(3) = {''};
        result.ColumnName(4) = {'Deviation'};
        result.ColumnName(5) = {'Value'};
        result.ColumnName(6) = {'Percent'};
    end

    function compute(source, callbackdata)
        column_count = numel(food_stuffs_table.Data(1, :));
        row_count = numel(food_stuffs_table.Data(:, 1));
        input_nutrients = cell2mat(food_stuffs_table.Data(:, 3:column_count));
        required_nutrients = transpose(cell2mat(desired.Data(:,2)));
        
        index = 1;
        
        while index <= row_count
            col_index = 1;
            if food_stuffs_table.Data{index, 2}
                for j = required_nutrients
                    if j ~= 0
                        input_nutrients(index, col_index) = input_nutrients(index, col_index) / j;
                    else
                        input_nutrients(index, col_index) = 0;
                    end
                    col_index = col_index + 1;
                end
            else
                input_nutrients(index, :) = zeros(1, numel(input_nutrients(1, :)));
            end
            index = index + 1;
        end
        
        elements = ones(numel(desired.Data(:, 1)), 1);
        elements = elements .* cell2mat(desired.Data(:, 3));
        
        in_nutrients = transpose(input_nutrients);
        in_nutrients = bsxfun(@times, in_nutrients, elements);
        tic
        [ food_amount_array, deviation ] = computeOptimalFood( in_nutrients, elements );
        toc
        setOutputTable(food_amount_array, deviation);
    end

    function reloadDatabase(source, callbackdata)
        [nutrient_names, food_names, food_nutrients] = loadDatabase();
        [profile_names, profile_values] = loadProfiles();
        temporary = {};
        food_stuffs = cell(size(food_nutrients, 1), size(food_nutrients, 2) + 2);
        iterator = 1;
        for i = food_names
            temporary{numel(temporary) + 1} = i{1};
            temporary{numel(temporary) + 1} = true;
            
            for j = food_nutrients(iterator, :)
                temporary{numel(temporary) + 1} = j(1);
            end
           
            food_stuffs(iterator, :) = temporary;

            temporary = {};
            iterator = iterator + 1;
            
        end
        
        food_stuffs_table.ColumnName = {'Food', 'Include'};

        for i = nutrient_names
            food_stuffs_table.ColumnName{numel(food_stuffs_table.ColumnName) + 1} = i{1};
        end
        
        food_stuffs_table.Data = food_stuffs;
        
        profile_menu.String = profile_names;
        loadProfile();
    end

    function saveDatabaseCallback(source, callbackdata)
        saveDatabase(food_stuffs_table.Data, food_stuffs_table.ColumnName);
    end

    selected_food = 1;
    function selectFood(source, callbackdata)
        if isempty(callbackdata.Indices)
            return;
        end
        entry_selected.String = callbackdata.Indices(1);
        selected_food = callbackdata.Indices(1);
    end

    function deleteFoodEntry(source, callbackdata)
        if size(food_stuffs_table.Data, 1) >= selected_food
            food_stuffs_table.Data(selected_food, :) = [];    
        end
    end

    window.Visible = 'on';
end

