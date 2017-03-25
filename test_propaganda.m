%% y' =1/100*(1-y(t-1)) * y(t-1)
% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
clear;
problem = test_propaganda_problem;
s = simulator( problem );

%% compute
test_propaganda_problem.order(36);
s.compute(300);

%% plot taylor
figure(1)
tt = linspace(-0.1, 300, 1000);
plot(tt, s.calc(tt), 'b');

