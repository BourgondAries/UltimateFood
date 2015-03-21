function [ food_amount_array, deviation ] = computeOptimalFood( food_nutrients, desired_nutrients )
    food_amount_array = lsqnonneg(food_nutrients, desired_nutrients);
    deviation = food_nutrients * food_amount_array - desired_nutrients;
end

