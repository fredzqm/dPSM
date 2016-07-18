% problem = DefaultProblem({1 0 1}, 0 , 0, ...
%     [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
%     rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
%         rel(3, -1, 0, [3 3]) ]);
% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
classdef test_sync_problem < AbstractProblem
    properties
        th
        v
        u
        thd
        thw
    end
    
    properties (Constant)
        N = 12
        wo = pi/2
    end
    
    methods
        function u = test_sync_problem(last, simulator)
            N = test_sync_problem.N;
            segLen = test_sync_problem.tau();
            intOrder = test_sync_problem.intOrder();
            if nargin == 0
                u.o = intOrder;
                u.t = 0;
                [T, V, U] = test_sync_problem.initData();
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
                u.thw = zeros(N^2, u.o);
            end
        end
        
        function computeOneItr(t)
            N = test_sync_problem.N ;
            wo = test_sync_problem.wo;
            K = test_sync_problem.K();
            for i = 1: N
                % get appropriate index
                a = N*(i-1)+1; b = N*i;
                % get w_i
                w = sum(t.u( a:b , t.o)) / N * K + t.const(wo);
                % update t.thw -- theta_j - w_i
                t.thw( a:b , t.o ) = t.thd( : , t.o) - w;
                % update t.th
                t.th( i , t.o+1 ) = w / t.o;
            end
            for i = 1: N
                % get appropriate index
                a = N*(i-1)+1; b = N*i;
                t.u(a:b, t.o+1) = t.multiple(t.v(a:b, :), t.thw(a:b, :)) / t.o ;
                t.v(a:b, t.o+1) = - t.multiple(t.u(a:b, :), t.thw(a:b, :)) / t.o ;
            end
        end
        
        function v = mainVariable(this)
            x = test_sync_problem.whichVar();
            v = this.th(x, :);
        end
        
        function unit = createCompUnit(last, simulator)
            unit = test_sync_problem(last, simulator);
        end
        
        function v = getSegLen(this)
            v = test_sync_problem.tau();
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
        function x = K(x)
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
                num = 20;
            end
            if nargin == 1
                num = x;
            else
                x = num;
            end
        end
        function [T, V, U] = initData(T, V, U)
            persistent num;
            persistent num2;
            persistent num3;
            if isempty(num)
                num = 0;
                num2 = 0;
                num3 = 0;
            end
            if nargin == 3
                num = T;
                num2 = V;
                num3 = U;
            else
                T = num ;
                V = num2 ;
                U = num3 ;
            end
        end
        
        
    end
end
