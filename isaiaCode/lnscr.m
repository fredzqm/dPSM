clear
no = 12; cnt = 1:no; IV = 0.5-(cnt-1)*2*3/no; om = pi/2*ones(1,no);
NR2 = 2; tau = [1 2];
NR = 1; ord = [20 10]; K = [1 1.25]; m = [40 30];
%NR2 = 1; tau = [6 3];
%NR = 1; ord = 10*[20 3 12]; K = [0.68 0.71 0.68]; m = [9 10 10];
% for tau = 3 N = 2, 4
%NR = 1; N = 10*[1.5 20 60 10 90]; K = [0.5 0.75 0.8 1 2.15]; m = [30 10 10 15 15];
% for tau = 1   N = 2
%NR = 5; N = 10*[2 1 2 10 90]; K = [0.5:0.5:2.0 2.15]; m = [30 15 15 15 15]; 

global FLAG

FLAG = 1;

for j = 1:NR2
    for i = 1:NR
        if FLAG == 2
            IV = IV + rand(1,no)*10^-1;
        end
        Q = dmpsynca(IV,ord(j),m(j),tau(j),K(j),om);
        FLAG = FLAG+1;
    end
end