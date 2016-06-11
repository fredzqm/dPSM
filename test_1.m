% x(t) = sin(t)
%% initialize
clear;

% problem = DefaultProblem({0 1} , 0 , 1 , ...
%     [rel( 1 , 1 , 0 , 2 ) rel( 2 , -1, 0 , 1 ) ]);
problem = test_1_problem();
s = simulator( problem );

%% compute
s.compute(20);

%% display
figure(1)
hold off
answer = @(x) sin(x);
t = linspace(0, 10, 1000);
s.plot( t , answer );
s.plotDeriv( t , 1);
s.plotDeriv( t , 2);
s.plotDeriv( t , 3);

%% plot error
figure(3)
s.plotError(t,answer);
