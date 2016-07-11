clear
problem = test_circuit_problem;
s = simulator(problem);

%% compute
test_circuit_problem.intOrder(30);
test_circuit_problem.segLen(1/1000);
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
title('segment Length: 1/1000, integration order: 30, compare');
print -djpeg order-30-len-1000-compare

%%
% figure(2)
% s.plotDeriv( t, 1);

% 
% figure(3)
% s.plotDeriv( t, 2);