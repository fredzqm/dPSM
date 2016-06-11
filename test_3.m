 %% initialize sqrt(x+1)*cos(x^2)
% clear;

% problem = DefaultProblem({1 0 1}, 0 , 1, ...
%     [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
%     rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
%         rel(3, -1, 0, [3 3]) ]);
problem = test_3_problem;
s = simulator(problem);

%% compute
until = s.compute(20)

%% plot taylor
figure(1)
hold off
answer = @(x) sqrt(x+1).*cos(x.^2);
t = linspace(0, 10, 1000);
s.plot( t , answer );

figure(2)
s.plotDeriv(t , 1);

%% plot error
figure(3)
s.plotError(t,answer);