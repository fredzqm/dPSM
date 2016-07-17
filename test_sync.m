 %% initialize sqrt(x+1)*cos(x^2)
% clear;
problem = test_sync_problem;
s = simulator(problem);

%% compute
s.compute(50);

%% plot taylor
figure(1)
hold on
answer = @(x) sqrt(x+1).*cos(x.^2);
tt = 0 :0.01: 50;
for i = 1: test_sync_problem.N
    test_sync_problem.whichVar(i);
    plot( tt , s.calc(tt, 1) , '-');
end

