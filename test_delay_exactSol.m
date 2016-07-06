%% calculate the acurate result
N = 10000000;
M = 3;
tt = linspace(0, 1, N);
dt = tt(2) - tt(1);
% dt = dt*2;
poly = tt;
poly(:) = 1;
% coefficient = zeros(M, N-1);
start = 1;
for i = 1 : M 
    for j = 2 : N
        poly(j) = poly(j-1) + dt * poly(j);
    end
    poly = exp(poly) / exp(poly(1)) * start;
%     coefficient(i, :) = poly(1:end-1);
    start = poly(end);
end
% tt = linspace(0, M, (N-1) * M );
% coefficient = reshape(coefficient', 1, (N-1) * M);