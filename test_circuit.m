clear
problem = test_circuit_problem;
s = simulator(problem);

%% compute
s.compute(5)

%% plot taylor
figure(2)
hold off
t = linspace(-1, 5, 1000);
c =  s.calc(t, 0);
plot( t , s.calc(t) , '-');
title('segment Length: 1/1000, integration order: 10');

%%
% figure(2)
% s.plotDeriv( t, 1);

% 
% figure(3)
% s.plotDeriv( t, 2);