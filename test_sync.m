 %% initialize sqrt(x+1)*cos(x^2)
% clear;
problem = test_sync_problem;
s = simulator(problem);

%% compute
til = s.compute(20000)

%% plot taylor
figure(1)
hold off
answer = @(x) sqrt(x+1).*cos(x.^2);
t = 0 :0.01: 10;
s.plot( t  );

