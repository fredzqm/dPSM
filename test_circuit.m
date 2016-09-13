clear
problem = test_circuit_problem;
s = simulator(problem);

%% compute
intOrder = 10;
segLen = 1000;
test_circuit_problem.intOrder(intOrder);
test_circuit_problem.segLen(1/segLen);
s.compute(5)

%% plot taylor
figure(2)
hold off
t = linspace(-1, 5, 1000);
test_circuit_problem.whichVar(1);
plot( t , s.calc(t) , 'b');
hold on
test_circuit_problem.whichVar(2);
plot( t , s.calc(t) , 'b:');
test_circuit_problem.whichVar(3);
plot( t , s.calc(t) , 'b-.');
legend('1', '2', '3')
title(sprintf('segment Length: 1/%d, integration order: %d, compare', segLen, intOrder));
xlabel('t');ylabel('$\vec{y}$', 'interpreter','latex');
print -djpeg order-10-len-1000-compare

%%
% figure(2)
% s.plotDeriv( t, 1);

% 
% figure(3)
% s.plotDeriv( t, 2);