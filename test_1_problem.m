% problem = DefaultProblem({0 1} , 0 , 1 , ...
%     [rel( 1 , 1 , 0 , 2 ) rel( 2 , -1, 0 , 1 ) ]);
classdef test_1_problem < AbstractProblem
    properties
        a
        b
    end
    
    methods
        function u = test_1_problem(o, t, a, b)
            if nargin > 0
                u.o = o;
                u.t = t;
                u.a = a;
                u.b = b;
                return;
            end
            u.o = 4;
            u.t = -0.001;
            u.a = Poly(u.o, 0);
            u.b = Poly(u.o, 1);
        end
        
        function unit = createCompUnit(last, simulator)
            segLen = 0.001;
            a = Poly(last.o, last.a.calc(segLen, 0));
            b = Poly(last.o, last.b.calc(segLen, 0));
            unit = test_1_problem(last.o, last.t + segLen, a , b);
        end
        
        
        function computeOneItr(t)
            t.addIntegTo(t.a, t.get(t.b) * 1);
            t.addIntegTo(t.b, t.get(t.a) * -1);
        end
        
        function v = mainVariable(this)
            v = this.a;
        end

    end
    
end