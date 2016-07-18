 %% initialize sqrt(x+1)*cos(x^2)
% clear;
problem = test_sync_problem;
s = simulator(problem);
test_sync_problem.K(1.25);
test_sync_problem.tau(2);
test_sync_problem.intOrder(10);


%% compute
s.compute(50);

%% plot taylor
figure(1)
hold on
tt = 0 :0.01: 50;
for i = 1: test_sync_problem.N
    test_sync_problem.whichVar(i);
    plot( tt , s.calc(tt, 1) , '-');
end
print -djpeg velocity

%% plot position
figure(2)
hold off
plot(1, 1)
hold on
tt = 0 :0.01: 50;
% test_sync_problem.whichVar(1);
for i = 1: test_sync_problem.N
    test_sync_problem.whichVar(i);
    var{i} = s.calc(tt);
end
for i = 1: test_sync_problem.N-1
    plot( tt , var{i}-var{i+1} , '-');
end
