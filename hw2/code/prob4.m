% demand data
demand = [3; 10; 17; 5; 
          10; 15; 20; 8; 
          8; 10; 18; 12; 
          10; 12; 12; 5;];

% adjacency matrix
% g = sparse(...
% [1 1 2 2 3 3 4 5 5 6 6  7 7  8  9  9  10 10 11 11 12 13 14 15],...
% [2 5 3 6 4 7 8 6 9 7 10 8 11 12 10 13 11 14 12 15 16 14 15 16],...
% ones(1, 24),...
% 16, 16);

% incidence matrix
pm1 = @(i) (mod(i, 2) == 0) - (mod(i, 2) == 1);
inc = sparse(...
double(idivide(int16(2:49), 2)),...
[1 2 2 3 3 4 ... 
 1 5 2 6 3 7 ...
 4 8 5 6 6 7 ...
 7 8 5 9 6 10 ...
 7 11 8 12 9 10 ...
 10 11 11 12 9 13 ...
 10 14 11 15 12 16 ...
 13 14 14 15 15 16],...
pm1(1:48),...
24, 16);
clear pm1
% % for some reasons I had to transpose this
% inc = inc;

% the graph built
adj = inc2adj(inc);
inc = inc.';

% objective
i_cnt = 16; j_cnt = 24;
% y_i s_i e_i l_j p_j
objective = [100*ones(i_cnt, 1); 2*ones(i_cnt, 1);...
                zeros(i_cnt, 1); zeros(j_cnt, 1);...
                1.5*ones(j_cnt, 1)];
            
% generator presence
% -100y_i - s_i leq 0 foreach i
generator_presence_lhs = [-100*eye(i_cnt) eye(i_cnt) zeros(i_cnt, i_cnt + 2 * j_cnt)];
generator_presence_lhs = sparse(generator_presence_lhs);
generator_presence_rhs = zeros(i_cnt, 1);


% power output limit
% -s_i + e_i leq 0 foreach i
power_output_limit_lhs = [zeros(i_cnt) -eye(i_cnt) eye(i_cnt) zeros(i_cnt, 2*j_cnt)];
power_output_limit_lhs = sparse(power_output_limit_lhs);
power_output_limit_rhs = zeros(i_cnt, 1);

% absolute power transmission
% l_j - p_j leq 0 foreach j
% -l_j - p_j leq 0 foreach j
absolute_power_trans_up_lhs = [zeros(j_cnt, 3 * i_cnt) eye(j_cnt) -eye(j_cnt)];
absolute_power_trans_up_lhs = sparse(absolute_power_trans_up_lhs);
absolute_power_trans_lo_lhs = [zeros(j_cnt, 3 * i_cnt) -eye(j_cnt) -eye(j_cnt)];
absolute_power_trans_lo_lhs = sparse(absolute_power_trans_lo_lhs);

absolute_power_trans_lhs = [absolute_power_trans_lo_lhs; absolute_power_trans_up_lhs]; 
clear absolute_power_trans_lo_lhs absolute_power_trans_up_lhs;
absolute_power_trans_rhs = zeros(2*j_cnt, 1);

% generator in tile
% all y_s <= 1
l = sparse([1,1,1,1], [1,2,5,6], [1,1,1,1], 1, 96);
generator_in_tile_lhs = [
    l; circshift(l, 1); circshift(l, 2);
    circshift(l, 4); circshift(l, 5); circshift(l, 6);
    circshift(l, 8); circshift(l, 9); circshift(l, 10);
];
clear l;
generator_in_tile_rhs = ones(9, 1);

% generator coordinate line
% x, y <= 2 
x_coord = sparse([1,1,1,1], [1,2,3,4], [1,1,1,1], 1, 96);
y_coord = sparse([1,1,1,1], [1,5,9,13], [1,1,1,1], 1, 96);
generator_coordinate_line_lhs = [
    x_coord; circshift(x_coord, 4); circshift(x_coord, 8); circshift(x_coord, 12);
    y_coord; circshift(y_coord, 1); circshift(y_coord, 2); circshift(y_coord, 3);
];
clear x_coord y_coord;
generator_coordinate_line_rhs = 2 * ones(8, 1);

% energy equilibrium
% e + Bp = d
energy_equ_lhs = [zeros(i_cnt, 2*i_cnt) eye(i_cnt) inc zeros(i_cnt, j_cnt)];
energy_equ_lhs = sparse(energy_equ_lhs);
energy_equ_rhs = demand;

% finally the solve
[x, f] = intlinprog(...
    objective,...
    1:i_cnt,... % y_i is integer
    [generator_presence_lhs; power_output_limit_lhs; 
        absolute_power_trans_lhs;generator_in_tile_lhs],...
    [generator_presence_rhs; power_output_limit_rhs; 
        absolute_power_trans_rhs;generator_in_tile_rhs],...
    energy_equ_lhs, energy_equ_rhs,...
    [zeros(1, 3*i_cnt) -inf * ones(1, j_cnt) zeros(1, j_cnt)],...% lower bound
    [ones(1, i_cnt) inf*ones(1, 2*(i_cnt + j_cnt))]);

y = x(1:16).';
s = x(17:32).';
e = x(33:48).';
l = x(49:72).';
p = x(73:96).';
