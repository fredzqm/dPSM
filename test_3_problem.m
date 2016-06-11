% problem = DefaultProblem({1 0 1}, 0 , 0, ...
%     [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
%     rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
%         rel(3, -1, 0, [3 3]) ]);
classdef test_3_problem < AbstractProblem
    properties
        a
        b
        c
    end
    
    methods
        function u = test_3_problem(last, simulator)
            u.o = 7;
            if nargin == 0
                u.t = 0;
                u.a = Poly(u.o, 1);
                u.b = Poly(u.o, 0);
                u.c = Poly(u.o, 1);
            else
                segLen = 0.001;
                u.t = segLen * simulator.len();
                u.a = Poly(u.o, calc(last.a, segLen, 0));
                u.b = Poly(u.o, calc(last.b, segLen, 0));
                u.c = Poly(u.o, calc(last.c, segLen, 0));
            end
        end
        
        function unit = createCompUnit(last, simulator)
            unit = test_3_problem(last, simulator);
        end
        
        % problem = DefaultProblem({1 0 1}, 0 , 0, ...
        %     [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
        %      rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
        %         rel(3, -1, 0, [3 3]) ]);
        function computeOneItr(t)
            t.a(:, t.o+1) = (1/2*t.multiple(t.a, t.c) - 2*t.multiplePoly(t.b, [0 1])) / t.o;
            t.b(:, t.o+1) = (1/2*t.multiple(t.b, t.c) + 2*t.multiplePoly(t.a, [0 1])) / t.o;
            t.c(:, t.o+1) = - t.multiple(t.c,t.c) / t.o;
        end
        
        function v = mainVariable(this)
            v = this.a;
        end

    end
    
end