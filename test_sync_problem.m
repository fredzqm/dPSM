% problem = DefaultProblem({1 0 1}, 0 , 0, ...
%     [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
%     rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
%         rel(3, -1, 0, [3 3]) ]);
% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
classdef test_sync_problem < AbstractProblem
    properties
        th
        thd
        v
        u
        th1_w1
        th1_w2
        th2_w1
        th2_w2
    end
    
    properties (Constant)
        N = 12
        K = 1
    end
    
    methods
        function u = test_sync_problem(last, simulator)
            segLen = test_sync_problem.tau();
            N = test_sync_problem.N;
            intOrder = test_sync_problem.intOrder();
            if nargin == 0
                u.o = 1;
                u.t = 0;
                % prepare the initial data --- T, U & V
                tau = segLen;
                IV = 0.5-(0:11)*6/12; om = pi/2*ones(1,12);
                T = zeros(N,1); U = zeros(N^2,1); V = zeros(N^2,1);                
                for j = 1:N
                    T(j,1:2) = [IV(1,j) om(j)];
                end
                for i = 1:N
                    ii = (i-1)*N;
                    for j = 1:N
                        t = calc(T(j, 1:2),-1*tau) - T(j, 1);
                        U(j+ii,1) = sin( t );
                        V(j+ii,1) = cos( t );
                    end
                end
                % end prepare the initial data --- T, U & V
                
                u.th = Poly(u.o, T);
                u.v = Poly(u.o, V);
                u.u = Poly(u.o, U);
            else
                u.o = intOrder;
                u.t = segLen * simulator.len();
                
                u.th = Poly(u.o, calc(last.th, segLen, 0));
                u.v = Poly(u.o, calc(last.v, segLen, 0));
                u.u = Poly(u.o, calc(last.u, segLen, 0));
                u.thd = deriv(last.th);
                u.thw = zeros(N, u.o);
            end
        end
        
        function computeOneItr(t)
            w = (t.v(:, t.o) + t.v(:, t.o))/2 + t.const(1);
            w1 = (t.v(1, t.o) + t.v(2, t.o))/2 + t.const(1);
            w2 = (t.v(3, t.o) + t.v(4, t.o))/2 + t.const(1);
            t.th1_w1(1, t.o) = t.thd(1, t.o) - w1;
            t.th1_w2(1, t.o) = t.thd(1, t.o) - w2;
            t.th2_w1(1, t.o) = t.thd(2, t.o) - w1;
            t.th2_w2(1, t.o) = t.thd(2, t.o) - w2;
            t.th(1,t.o+1) = w1 / t.o;
            t.th(2,t.o+1) = w2 / t.o;
            t.u(1,t.o+1) = t.multiple(t.v(1, :), t.th2_w1) / t.o;
            t.u(2,t.o+1) = t.multiple(t.v(2, :), t.th1_w1) / t.o;
            t.u(3,t.o+1) = t.multiple(t.v(3, :), t.th2_w2) / t.o;
            t.u(4,t.o+1) = t.multiple(t.v(4, :), t.th1_w2) / t.o;
            t.v(1,t.o+1) = -t.multiple(t.u(1, :), t.th2_w1) / t.o;
            t.v(2,t.o+1) = -t.multiple(t.u(2, :), t.th1_w1) / t.o;
            t.v(3,t.o+1) = -t.multiple(t.u(3, :), t.th2_w2) / t.o;
            t.v(4,t.o+1) = -t.multiple(t.u(4, :), t.th1_w2) / t.o;
        end
        
        function v = mainVariable(this)
            x = test_sync_problem.whichVar();
            v = this.th(x, :);
        end
        
        function unit = createCompUnit(last, simulator)
            unit = test_sync_problem(last, simulator);
        end
        
        function v = getSegLen(this)
            v = test_sync_problem.tau(x)
        end
    end
    
    methods (Static)
        function x = whichVar(x)
            persistent num;
            if isempty(num)
                num = 1;
            end
            if nargin == 1
                num = x;
            else
                x = num;
            end
        end
        function x = tau(x)
            persistent num;
            if isempty(num)
                num = 1;
            end
            if nargin == 1
                num = x;
            else
                x = num;
            end
        end
        function x = intOrder(x)
            persistent num;
            if isempty(num)
                num = 60;
            end
            if nargin == 1
                num = x;
            else
                x = num;
            end
        end
        
    end
end