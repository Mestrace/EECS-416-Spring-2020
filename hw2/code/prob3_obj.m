function v = prob1_obj(X)
    % the objective function for the optimization
    %  X = [r_1, r_2, r_3, x_1, x_2, x_3, y_1, y_2, y_3]
    r = X(1:3); % radius
    % maximization -> - minimization
    v = -pi*(r(1)^2 + r(2)^2 + r(3)^2);
end




