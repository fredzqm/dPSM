% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
classdef test_delay_problem < AbstractProblem
    properties
        a
        d
    end
    
    methods
        function u = test_delay_problem(o, t, a, d)
            if nargin > 0
                u.o = o;
                u.t = t;
                u.a = a;
                u.d = d;
                return;
            end
            u.o = 10;
            u.t = -1;
            u.a = Poly(u.o, 1);
            u.d = Poly(u.o, 1);
        end
        
        function unit = createCompUnit(last, simulator)
            segLen = 1;
            a = Poly(last.o, last.a.calc(segLen, 0));
            d = last.a;
            unit = test_delay_problem(last.o, last.t + segLen, a , d);
        end
        
        function computeOneItr(t)
            t.addIntegTo(t.a, t.multiple(t.a, t.d));
        end
        
        function v = mainVariable(this)
            v = this.a;
        end

    end
    
end