 %% initialize sqrt(x+1)*cos(x^2)
% clear;
problem = test_sync_problem;
s = simulator(problem);

%% compute
s.compute(50);

%% plot position
figure(2)
hold on
tt = 0 :0.01: 50;
var1 = s.calc(tt);
for i = 2: test_sync_problem.N
    test_sync_problem.whichVar(i);
    plot( tt , s.calc(tt)-var1 , '-');
end
print -djpeg relativePos