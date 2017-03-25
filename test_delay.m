%% y' = y*y(t-tau)
% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
clear;
test_delay_exactSol
problem = test_delay_problem;
s = simulator( problem );

%% compute
test_delay_problem.order(36);
s.compute(3);

%% plot taylor
figure(1)
plot(tt, s.calc(tt), 'b', tt, coefficient, 'bo');
legend('find value', 'exact value');
title('y’ = y y^*, delay = 1, initial history constant = 1.  Segment length = 1, order of integration 36 error -0.0093');

%% find error at t = 3
% error e-2 e-4  CPU time and order
% number 3

%% case 1:
error = (s.calc(3) - start)/start

