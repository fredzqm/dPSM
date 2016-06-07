 %% initialize sqrt(x+1)*cos(x^2)
% clear;

config.resetTime = 1;
config.order = 7;
problem = test_sync_problem;
s = simulator(problem, config );

%% compute
s.compute(20);

%% plot taylor
figure(1)
hold off
answer = @(x) sqrt(x+1).*cos(x.^2);
t = 0 :0.01: 10;
s.plot( t , answer );

figure(2)
s.plotDeriv( t , 6);

%% plot error
figure(3)
s.plotError(t,answer);