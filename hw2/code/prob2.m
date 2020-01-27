% cost coefficient
C = [
    150 / 300 + 200 * 0.9 / 450 + 180 * 0.9 * 0.95 / 250 + 0.9 * 0.95 * 0.85 * 220 / 400;
    150 / 300 + 200 * 0.9 / 450 + 180 * 0.9 * 0.95 / 250 + 0.9 * 0.95 * 0.85 * 250 / 350;
    300 / 500 + 0.9 * 250 / 480 + 0.9 * 0.85 * 240 / 400;
];

% price
P = [20; 20; 18];

% final production coefficient
o = [0.9*0.95*0.85*0.8; 0.9*0.95*0.85*0.75; 0.9*0.85*0.8];

% raw material cost
R = [5; 5; 6];

% maximum daily sales constraint 
% inequality
max_daily_sales_lhs = [
    o(1:2).' 0
    0 0 o(3)
];

max_daily_sales_rhs = [1700; 1500];

% shipping facility limit
% inequality
shipping_lhs = [o.';];
shipping_rhs = [2500;];

% facility hour limit
hours_lhs = [
    % x1                      % x2              % x3
    1/300                     1/300             1/500               % f 1
    0.9/450+0.9*0.95*0.85/400 0.9/450           0                   % f 2
    0                         0.9*0.95*0.85/350 0.9/480             % f 3
    0.9*0.95/250              0.9*0.95/250      0.9*0.85/400        % f 4
];

hours_rhs = [16; 12; 12; 16];

[x, f] = linprog(-(P.*o - C - R), [max_daily_sales_lhs;shipping_lhs;hours_lhs], ...
                    [max_daily_sales_rhs;shipping_rhs;hours_rhs], [], [], zeros(3, 1), []);
       
