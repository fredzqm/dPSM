 %% initialize sqrt(x+1)*cos(x^2)
clear;
test_sync_problem.K(1);
test_sync_problem.tau(1);
test_sync_problem.intOrder(20);
% prepare the initial data --- T, U & V
N = test_sync_problem.N;
tau = test_sync_problem.tau();
IV = 0.5-(0:11)*6/12; om = pi/2*ones(1,12);
T = zeros(N,1); U = zeros(N^2,1); V = zeros(N^2,1);             
for j = 1:N
    T(j,1:2) = [IV(1,j) om(j)];
end
for i = 1:N
    ii = (i-1)*N;
    for j = 1:N
        t = calc(T(j,:),-1*tau, 0)-calc(T(i,1),0, 0);
        U(j+ii,1) = sin( t );
        V(j+ii,1) = cos( t );
    end
end
init.T = T; init.U = U; init.V = V;
% end prepare the initial data --- T, U & V
problem = test_sync_problem(init);
s = simulator(problem);


%% compute
s.compute(50);

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
title('Kuramoto-N = 12, w_0 = \pi/2, K = 1, \tau = 1, order = 20')
% print -djpeg synchronized
