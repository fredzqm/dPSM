function Q = dmpsynca(IV,ord,m,tau,K,om)

%   The function 'dmpsynca' implements qPSM for delayed Kuramoto.  
%
%   It accepts 6 inputs:
%
%        IV - row vecrtor of initial values at t = 0 
%
%       ord - number of iterations of Picard's
%
%         m - number of tau blocks covered
%
%         tau - lag
%
%           K - coupling strength
%
%          om - row vector of initial frequencies
%
%   Output is CPU time in secs, along with a plots of approximation.
%
%   Author: V. M. Isaia


    it = cputime; Ntmp = size(om); N = Ntmp(2);
    T = zeros(N,ord+1); To = zeros(N,ord+1); M = zeros(N,ord);
    for k = 1:N
        M(k,:) = 1:ord;
    end
    global FLAG
    U = zeros(N^2,ord+1); V = zeros(N^2,ord+1); W = zeros(N,ord+1); 
%     SV = zeros(N,m+1); SV2 = zeros(N^2,m+1); SV3 = zeros(N^2,m+1);
    ts = 0:0.01:tau; ev = zeros(1,N-1);
    cv = ['b' 'k' 'r' 'g' 'b' 'k' 'r' 'g' 'b' 'k' 'r' 'g'];
    sv = [':' ':' ':' ':' '-' '-' '-' '-' ':' ':' ':' ':'];
    %if FLAG == 2
    %   cv = ['b' 'k' 'r' 'g' 'm' 'y' 'r' 'g' 'b' 'k' 'm' 'y'];
    %   sv = ['o' 'o' 'o' 'o' 'o' 'o' '-' '-' '-' '-' '-' '-'];
    %end
    syms x
    for j = 1:N
        To(j,1:2) = [IV(1,j) om(j)];
        T(j,1:2) = [IV(1,j) om(j)];
        SV(j,1) = poly2sym(T(j,2:-1:1));
    end
    for i = 1:N
        ii = (i-1)*N;
        for j = 1:N
            U(j+ii,1) = sin(subs(SV(j,1),x,-1*tau)-subs(SV(i,1),x,0)); 
            V(j+ii,1) = cos(subs(SV(j,1),x,-1*tau)-subs(SV(i,1),x,0));
        end
    end
    for z = 1:m
        Tpo = [To(:,2:ord+1).*M zeros(N,1)];
        for zz = 1:ord
            for i = 1:N
                W(i,:) = [om(i) zeros(1,ord)] + K/N*sum(U(1+(i-1)*N:i*N,:),1); 
                T(i,zz+1) = W(i,zz)/zz;
                ii = (i-1)*N;
                for j = 1:N
                    convo1 = conv(V(j+ii,1:zz),(Tpo(j,1:zz)-W(i,1:zz))); 
                    U(j+ii,zz+1) = convo1(zz)/zz;
                    convo3 = conv(U(j+ii,1:zz),(Tpo(j,1:zz)-W(i,1:zz))); 
                    V(j+ii,zz+1) = -1*convo3(zz)/zz;
                end 
            end
        end
        t = ts + (z-1)*tau;
        for j = 1:N
            SV(j,z+1) = poly2sym(T(j,ord+1:-1:1),x);
        end
        figure(1); hold on
        for i = 1:N-1
            subplot(2,1,FLAG);
            xx = ts;
            for j = 1 : size(ts, 2)
                xx(j) = subs(SV(i,z+1)-SV(i+1,z+1),x,ts(j));
            end
            plot(t,xx,strcat(cv(i),sv(i))); hold on;
        end 
        for i = 1:N
            ii = (i-1)*N;
            for j = 1:N
                SV2(j+ii,z+1) = poly2sym(U(j+ii,ord+1:-1:1),x); 
                SV3(j+ii,z+1) = poly2sym(V(j+ii,ord+1:-1:1),x);
            end
        end
        To(:,ord+1:-1:1) = T(:,ord+1:-1:1);
        for j= 1:N
            T(j,:) = [double(subs(SV(j,z+1),x,tau)) zeros(1,ord)];
        end
        for i = 1:N
            ii = (i-1)*N;
            for j = 1:N
                U(j+ii,:) = [double(subs(SV2(j+ii,z+1),x,tau)) zeros(1,ord)];
                V(j+ii,:) = [double(subs(SV3(j+ii,z+1),x,tau)) zeros(1,ord)];
            end
        end
    end
    for i = 1:N-1
        v = subs(SV(i,m+1)-SV(i+1,m+1),x,ts); 
        sev = size(v); ss = sev(1,2); ev(i) = double(v(1,ss));
    end
    if N > 6
       strcat('error = ',num2str(ev(1:N/2)))
       strcat('error = ',num2str(ev(N/2+1:N-1)))
    else
        strcat('error = ',num2str(ev))
    end
    strcat('CPUtime was: ',num2str(cputime-it),' sec')
   
    Q = 1;