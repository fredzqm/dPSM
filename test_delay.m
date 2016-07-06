%% y' = y*y(t-tau)
% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
problem = test_delay_problem;
s = simulator( problem );

%% compute
s.compute(3);


%% plot taylor
% hold off
% answer = @(x) exp(x);
% t = linspace(0, 3, 1000);
% s.plot( t , tt, coefficient );

%% find error at t = 3
% error e-2 e-4  CPU time and order
% number 3
error = (s.calc(3) - start)/start

