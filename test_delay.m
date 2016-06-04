 %% initialize sqrt(x+1)*cos(x^2)
clear;

config.resetTime = 1;
config.order = 10;
s = simulator({1}, 0 , 1, ...
   [rel(1,1, 0, [1], 1) ], config);

%% compute
s.compute(2);

%% plot taylor
figure(1)
hold off
answer = @(x) exp(x);
t = 0 :0.01: 1.5;
s.plot( t , answer );

