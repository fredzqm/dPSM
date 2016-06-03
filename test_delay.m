 %% initialize sqrt(x+1)*cos(x^2)
clear;
s = simulator([1], 0 , 1, ...
   [rel(1,1, 0, 1, 1) ] );

%% compute
s.setAccuracyParameters(1, 5);
s.compute(20);

%% plot taylor
figure(1)
hold off
answer = @(x) sqrt(x+1).*cos(x.^2);
t = 0 :0.01: 20;
s.plot( t , answer );

figure(2)
s.plotDeriv( t , 6);

%% plot error
figure(3)
s.plotError(t,answer);