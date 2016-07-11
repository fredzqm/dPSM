% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
classdef test_delay_problem < AbstractProblem
    properties
        a
        d
    end
    
    methods
        function u = test_delay_problem(last, simulator)
            u.o = test_delay_problem.order();
            if nargin == 0
                u.t = -1;
                u.a = Poly(u.o, 1);
                u.d = Poly(u.o, 1);
            else
                segLen = 1;
                u.t = simulator.len();
                u.a = Poly(u.o, calc(last.a, segLen, 0));
                u.d = last.a;
            end
        end
        
        function unit = createCompUnit(last, simulator)
            unit = test_delay_problem(last, simulator);
        end
        
        function computeOneItr(t)
            t.a(:, t.o+1) = t.multiple(t.a, t.d) / t.o;
        end
        
        function v = mainVariable(this)
            v = this.a;
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