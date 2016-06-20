problem = test_circuit_problem;
s = simulator(problem);

%% compute
s.compute(8)

%% plot taylor
figure(1)
hold off
t = linspace(-5, 8, 1000);
s.plot( t );

%%
% figure(2)
% s.plotDeriv( t, 1);
% 
% figure(3)
% s.plotDeriv( t, 2);