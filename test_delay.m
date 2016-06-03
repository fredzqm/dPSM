 %% initialize sqrt(x+1)*cos(x^2)
clear;
s = simulator({1}, 0 , 1, ...
   [rel(1,1, 0, [], 1) ] );

%% compute
s.setAccuracyParameters(1, 10);
s.compute(2);

%% plot taylor
figure(1)
hold off
answer = @(x) exp(x);
t = 0 :0.01: 2.3;
s.plot( t , answer );

