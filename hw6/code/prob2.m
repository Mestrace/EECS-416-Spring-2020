Q1 = [
    10 8 7 6
    8 10 8 7
    7 8 10 8
    6 7 8 10
];
Q2 = [
    3 2 1 0
    2 3 2 1
    1 2 3 2
    0 1 2 3
];

Q3 = [
    2 1 0 0
    1 2 1 0
    0 1 2 1
    0 0 1 2
];
Q4 = eye(4);

q1 = [1; -1; 2; -2];
q2 = zeros(4, 1);
q3 = [2;2;-4;4];
q4 = zeros(4, 1);

Q = [
    Q1 Q2 Q3 Q4
    Q2 Q1 Q2 Q3
    Q3 Q2 Q1 Q2
    Q4 Q3 Q2 Q1
];

q = [q1;q2;q3;q4];

A = [Q3 Q2 Q1 Q4];
b = [1; 14; 3; -4];

% verify that the problem is strictly convex by checking all principal
% minors
assert(all(arrayfun(@(x) det(Q(1:x, 1:x)) > 0, 1:16)))

% solve with lagrange multiplier
lam = -inv(A * inv(Q) * A.') * (A * inv(Q) * q + b);
x = -inv(Q) * (q + A.' * lam);




