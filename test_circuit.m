clear
problem = test_circuit_problem;
s = simulator(problem);

%% compute
test_circuit_problem.intOrder(50);
test_circuit_problem.segLen(1/70);
s.compute(5)

%% plot taylor
figure(2)
hold off
test_circuit_problem.whichVar(3);
t = linspace(-test_circuit_problem.segLen()*2, test_circuit_problem.segLen()*2, 1000);
c =  s.calc(t, 0);
plot( t , s.calc(t) , '-');
title('segment Length: 1/1000, integration order: 10');

%%
% figure(2)
% s.plotDeriv( t, 1);

% 
% figure(3)
% s.plotDeriv( t, 2);