clear
problem = test_circuit_problem;
s = simulator(problem);

%% compute
test_circuit_problem.intOrder(5);
test_circuit_problem.segLen(1/5000);
s.compute(5)

%% plot taylor
figure(2)
hold off
test_circuit_problem.whichVar(1);
t = linspace(0, 0.01, 1000);
c =  s.calc(t, 0);
vv = s.calc(t);
plot( t , vv , '-');
title('segment Length: 1/1000, integration order: 10');

%%
% figure(2)
% s.plotDeriv( t, 1);

% 
% figure(3)
% s.plotDeriv( t, 2);