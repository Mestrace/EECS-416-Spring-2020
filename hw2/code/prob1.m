% shipping cost 
C = [
    10; 13; % W1 -> M / G
    16; 11; % W2 -> M / G
    7;  6;  % M <-> G
    18; 15; % M  -> LA / NY
    15; 12; % G  -> LA / NY
    20; 20; % LA <-> NY
    25; 28; % W1 -> NY / LA
    24; 26; % W2 -> NY / LA
];

% port cleared  [equality]
% shape (2 10) from x1 - x10
port_cleared_lhs = [
    1 0 1 0 -1  1 -1 -1  0  0 % M
    0 1 0 1  1 -1  0  0 -1 -1 % G
]; 

port_cleared_lhs = [ port_cleared_lhs zeros(2, 6)];
port_cleared_rhs = zeros(2, 1);

% demand constraint [inequality]
% -1 bc greater
% shape (2 10) from x7 - x16
demand_lhs = -1 * [
    1 0 1 0 -1 1 0 1 0 1
    0 1 0 1 1 -1 1 0 1 0
];

demand_lhs = [zeros(2, 6) demand_lhs];
demand_rhs = -1 * [170;150];
    
% supply constraint
supply_lhs = [ 
    [
        1 1 0 0
        0 0 1 1
    ] zeros(2, 8) [
        1 1 0 0
        0 0 1 1
    ]
];

supply_rhs = [180; 210];

%
[x, f] = linprog(C, [demand_lhs; supply_lhs], [demand_rhs; supply_rhs], ...
                port_cleared_lhs, port_cleared_rhs, ...
                zeros(16, 1), []);