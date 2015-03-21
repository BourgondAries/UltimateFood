% All edibles
loadDatabase();
while true
    [b] = runGUI();
    disp('derp');
    if false
        break;
    end
    % computeOptimalFood(b);
    if false
        a = loadDatabase();
    end
end
Foods = load('foods.txt')


%[x, resnorm, residual, exitflag, output, lambda]
x =  lsqnonneg(A, b);
disp(x);
%A * x - b