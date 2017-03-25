% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
classdef test_propaganda_problem < AbstractProblem
    properties
        a
        ad
        ax
    end
    
    methods
        function u = test_propaganda_problem(last, simulator)
            u.o = test_delay_problem.order();
            if nargin == 0
                u.t = 0;
                u.a = Poly(u.o, 0.001);
            else
                segLen = 2;
                u.t = simulator.len()*segLen;
                u.a = Poly(u.o, calc(last.a, segLen, 0));
                u.ax = zeros(1, u.o);
                u.ad = last.a;
            end
        end
        
        function unit = createCompUnit(last, simulator)
            unit = test_propaganda_problem(last, simulator);
        end
        
        function computeOneItr(t)
            t.ax(:, t.o) = t.const(1) - t.ad(t.o) ;
            t.a(:, t.o+1) = t.multiple(t.ax, t.ad) / t.o / 1;
        end
        
        function v = mainVariable(this)
            v = this.a;
        end
        
        function v = getSegLen(this)
            v = 1;
        end
        
    end
    
    methods (Static)
        function x = order(x)
            persistent num;
            if isempty(num)
                num = 10;
            end
            if nargin == 1
                num = x;
            else
                x = num;
            end
        end
    end
end