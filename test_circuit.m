problem = test_circuit_problem;
s = simulator(problem);

%% compute
s.compute(10/0.001);

%% plot taylor
figure(1)
hold off
answer = @(x) sqrt(x+1).*cos(x.^2);
t = -1 :0.01: 0;
s.plot( t );

