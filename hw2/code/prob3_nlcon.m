function [c, ceq] = prob1_nlcon(X)
    %  X = [r_1, r_2, r_3, x_1, x_2, x_3, y_1, y_2, y_3]
    r=X(1:3); x=X(4:6); y=X(7:9);
    ceq = [];
    % non-overlapping circle: 3
    % in-bound circle: 5 for each, total 5 * 3 = 15
    % c = zeros(18,1);

    % permutations
    perm = nchoosek(1:3, 2);
    % non-overlapping circle
    for i = 1:3
        a = perm(i, 1);
        b = perm(i, 2);
    
        c(i) = (r(a) + r(b))^2 - (x(a) - x(b))^2 - (y(a) - y(b))^2;
    end

    for i = 1:3
        j = i;
        c((i - 1) * 5 + 4)   = r(j) - y(j);
        c((i - 1) * 5 + 4 + 1) = sqrt(37) * r(j) - 6 * x(j) + y(j);
        c((i - 1) * 5 + 4 + 2) = sqrt(17) * r(j) + 4 * x(j) + y(j) - 280;
        c((i - 1) * 5 + 4 + 3) = sqrt(13) * r(j) + 3 * x(j) + 2 * y(j) - 235;
        c((i - 1) * 5 + 4 + 4) = sqrt(53) * r(j) + 2 * x(j) + 7 * y(j) - 440;
    end
end