% problem = DefaultProblem({0 1} , 0 , 1 , ...
%     [rel( 1 , 1 , 0 , 2 ) rel( 2 , -1, 0 , 1 ) ]);
classdef test_1_problem < AbstractProblem
    properties
        a
        b
    end
    
    methods
        function u = test_1_problem(last, simulator)
            if nargin == 0
                u.t = 0;
                u.o = 4;
                u.a = Poly(u.o, 0);
                u.b = Poly(u.o, 1);
            else
                segLen = 0.001;
                u.o = 4;
                u.t = segLen * simulator.len();
                u.a = Poly(u.o, calc(last.a, segLen, 0));
                u.b = Poly(u.o, calc(last.b, segLen, 0));
            end
        end
        
        function unit = createCompUnit(last, simulator)
            unit = test_1_problem(last, simulator);
        end
        
        function computeOneItr(t)
            t.a(:, t.o+1) = t.b(:, t.o)/t.o;
            t.b(:, t.o+1) = -t.a(:, t.o)/t.o;
%             t.addIntegTo(t.a, t.get(t.b) * 1);
%             t.addIntegTo(t.b, t.get(t.a) * -1);
        end
        
        function v = mainVariable(this)
            v = this.a;
        end

    end
    
end