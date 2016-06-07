% problem = DefaultProblem({1 0 1}, 0 , 0, ...
%     [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
%     rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
%         rel(3, -1, 0, [3 3]) ]);
classdef test_circuit_problem < AbstractProblem
    properties
        y
        yd
        ydd
    end
    
    methods
        function u = test_circuit_problem(last, simulator)
            if nargin == 0
                u.o = 100;
                u.t = 0;
                u.y = Poly(u.o, 1);
                u.yd = Poly(u.o, 1);
                u.ydd = Poly(u.o, 1);
            else
                segLen = 1;
                u.o = 100 - simulator.len();
                u.t = segLen * simulator.len();
                u.y = Poly(u.o, last.y.calc(segLen, 0));
                u.yd = last.y;
                u.ydd = last.y.deriv();
            end
        end
        

        
        % problem = DefaultProblem({1 0 1}, 0 , 0, ...
        %     [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
        %      rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
        %         rel(3, -1, 0, [3 3]) ]);
        function computeOneItr(t)
            t.addIntegTo(t.a, 1/2*t.multiple(t.a, t.c) - 2*t.multiplePoly(t.b, [0 1]));
            t.addIntegTo(t.b, 1/2*t.multiple(t.b, t.c) + 2*t.multiplePoly(t.a, [0 1]));
            t.addIntegTo(t.c, - t.multiple(t.c,t.c));
        end
        
        function v = mainVariable(this)
            v = this.a;
        end
        
        function unit = createCompUnit(last, simulator)
            unit = test_circuit_problem(last, simulator);
        end
    end
    
end