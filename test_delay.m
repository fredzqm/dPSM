%% y' = y*y(t-tau)
clear;

% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
problem = test_delay_problem;
s = simulator( problem );

%% compute
s.compute(3);

%% calculate the acurate result
N = 100000;
M = 3;
tt = linspace(0, 1, N);
dt = tt(2) - tt(1);
poly = tt;
poly(:) = 1;
coefficient = zeros(M, N);
start = 1;
for i = 1 : M
    for j = 2 : N
        poly(j) = poly(j-1) + dt * poly(j);
    end
    poly = exp(poly) / exp(poly(1)) * start;
    coefficient(i, :) = poly;
    start = coefficient(i, end);
end
tt = linspace(0, M, (N-1) * M );
coefficient(:, end) = [];
coefficient = reshape(coefficient', 1, (N-1) * M);

%% plot taylor
hold off
answer = @(x) exp(x);
t = linspace(0, 2.8, 1000);
s.plot( t , tt, coefficient );

