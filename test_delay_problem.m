% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
classdef test_delay_problem < AbstractProblem
    properties
        a
        d
    end
    
    methods
        function u = test_delay_problem(last, simulator)
            u.o = 10;
            if nargin == 0
                u.t = -1;
                u.a = Poly(u.o, 1);
                u.d = Poly(u.o, 1);
            else
                segLen = 1;
                u.t = simulator.len();
                u.a = Poly(last.o, last.a.calc(segLen, 0));
                u.d = last.a;
            end
        end
        
        function unit = createCompUnit(last, simulator)
            unit = test_delay_problem(last, simulator);
        end
        
        function computeOneItr(t)
            t.addIntegTo(t.a, t.multiple(t.a, t.d));
        end
        
        function v = mainVariable(this)
            v = this.a;
        end

    end
    
end