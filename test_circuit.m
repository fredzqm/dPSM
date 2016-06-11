problem = test_circuit_problem;
s = simulator(problem);

%% compute
until = s.compute(2000)

%% plot taylor
figure(1)
hold off
t = -0.2 :0.0001: 2;
s.plot( t );

