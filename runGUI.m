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
            'ColumnWidth', {60 60 120 'auto'},...
            'RowName', [],...
            'Position', [20 80 500 400]...
    );
        
    desired = uitable...
    (...
        'ColumnName', {'Resource', 'Amount', 'Importance'},...
        'ColumnFormat', {'numeric', 'numeric', 'bank'},...
        'ColumnEditable', [false true true],...
        'ColumnWidth', {100 80 120 'auto'},...
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
        'Position', [20 40 70 20],...
        'Callback', @compute...
    );
    
    reload_button = uicontrol...
    (...
        'Style', 'pushbutton', 'String', 'Reload',...
        'Position', [20 60 70 20],...
        'Callback', @reloadDatabase...
    );

    new_entry = uicontrol...
    (...
        'Style', 'pushbutton', 'String', 'New Entry',...
        'Position', [100 60 70 20],...
        'Callback', @createNewFoodEntry...
    );

    profile_menu = uicontrol...
    (...
        'Style', 'popupmenu',...
        'Position', [540 60 120 20],...
        'Callback', @loadProfile...
    );

    profile_values = {};

    reloadDatabase();

    function loadProfile(source, callbackdata)
        desired.Data = {};
        number_of_rows = numel(food_stuffs_table.ColumnName);
        index = 1;
        while index <= number_of_rows - 2
            desired.Data = [desired.Data; food_stuffs_table.ColumnName(index + 2) profile_values(profile_menu.Value, index) 1];
            index = index + 1;
        end
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
        format longG;
        disp('Deviation:');
        disp(cell2mat(desired.Data(:,2)) .* deviation);
        
        result.Data = {};
        index = 1;
        while index <= numel(food_stuffs_table.Data(:, 1))
            result.Data = [result.Data; food_stuffs_table.Data(index, 1) food_amount_array(index)];
            index = index + 1;
        end
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
                    input_nutrients(index, col_index) = input_nutrients(index, col_index) / j;
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
        
        [ food_amount_array, deviation ] = computeOptimalFood( in_nutrients, elements );
        setOutputTable(food_amount_array, deviation);
    end

    function reloadDatabase(source, callbackdata)
        [nutrient_names, food_names, food_nutrients] = loadDatabase();
        [profile_names, profile_values] = loadProfiles();
        temporary = {};
        food_stuffs = {};
        iterator = 1;
        for i = food_names
            temporary{numel(temporary) + 1} = i{1};
            temporary{numel(temporary) + 1} = true;
            for j = food_nutrients(iterator,:)
                temporary{numel(temporary) + 1} = j(1);
            end
            food_stuffs = [food_stuffs; temporary];

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

    window.Visible = 'on';
end

