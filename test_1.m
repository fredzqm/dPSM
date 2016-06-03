% x(t) = sin(t)
%% initialize
clear;
s = simulator( [0 1] , 0 , 1 , ...
   [rel( 1 , 1 , 0 , 2 ) ...
    rel( 2 , -1, 0 , 1 ) ] );

%% compute
s.setAccuracyParameters(0.001, 4);
s.compute(20);

%% display
figure(1)
hold off
answer = @(x) sin(x);
t = 0 :0.01: 10 ;
s.plot( t , answer );
s.plotDeriv( t , 1);

%% plot error
figure(3)
s.plotError(t,answer);
