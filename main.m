% All edibles
Foods = load('foods.txt')

A = [];
array = [];

add_bananas = true;
add_avocado = true;
add_milk = true;

if add_bananas == true 
    A = [A; bananas];
end
if add_avocado == true 
    A = [A; avocado];
end
if add_milk == true 
    A = [A; milk];
end

A = transpose(A);

b = [0.34; 0.056; 0.07; 0.015];
disp(A);

%[x, resnorm, residual, exitflag, output, lambda]
x =  lsqnonneg(A, b);
disp(x);
%A * x - b