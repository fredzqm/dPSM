%% y' =1/100*(1-y(t-1)) * y(t-1)
% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
clear;
problem = test_propaganda_problem;
s = simulator( problem );

%% compute
test_propaganda_problem.order(36);
s.compute(30);

%% plot taylor
figure(1)
tt = linspace(-0.1, 30, 1000);
plot(tt, s.calc(tt), 'b');
% legend('find value', 'exact value');
% title('y’ = y y^*, delay = 1, initial history constant = 1.  Segment length = 1, order of integration 36 error -0.0093');

%% find error at t = 3
% error e-2 e-4  CPU time and order
% number 3


