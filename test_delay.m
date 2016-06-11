 %% initialize sqrt(x+1)*cos(x^2)
clear;

% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
problem = test_delay_problem;
s = simulator( problem );

%% compute
until = s.compute(3)

%% plot taylor
figure(1)
hold off
answer = @(x) exp(x);
t = 0 :0.01: 1.5;
s.plot( t , answer );

