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
    
    
    methods
        function u = test_sync_problem(last, simulator)
            segLen = test_sync_problem.segLen();
            intOrder = test_sync_problem.intOrder();
            if nargin == 0
                u.o = intOrder;
                u.t = 0;
                thetaInit = [1/2 1 1/2; -1 1 1/2];
                u.th = Poly(u.o, thetaInit);
                u.v = Poly(u.o, [1;1;1;1]);
                u.u = Poly(u.o, [1;1;1;1]);
            else
                u.o = intOrder;
                u.t = segLen * simulator.len();
                u.th = Poly(u.o, calc(last.th, segLen, 0));
                u.v = Poly(u.o, calc(last.v, segLen, 0));
                u.u = Poly(u.o, calc(last.u, segLen, 0));
                u.thd = deriv(last.th);
                u.th1_w1 = zeros(1, u.o);
                u.th1_w2 = zeros(1, u.o);
                u.th2_w1 = zeros(1, u.o);
                u.th2_w2 = zeros(1, u.o);
            end
        end
        
        function unit = createCompUnit(last, simulator)
            unit = test_sync_problem(last, simulator);
        end
        
        function computeOneItr(t)
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
        
        function v = getSegLen(this)
            v = 1;
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
        function x = segLen(x)
            persistent num;
            if isempty(num)
                num = 1/5000;
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