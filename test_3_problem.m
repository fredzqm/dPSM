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
        function u = test_3_problem(o, t, a, b, c)
            if nargin > 0
                u.o = o;
                u.t = t;
                u.a = a;
                u.b = b;
                u.c = c;
                return;
            end
            u.o = 7;
            u.t = -0.001;
            u.a = Poly(u.o, 1);
            u.b = Poly(u.o, 0);
            u.c = Poly(u.o, 1);
        end
        
        function unit = createCompUnit(last, simulator)
            segLen = 0.001;
            a = Poly(last.o, last.a.calc(segLen, 0));
            b = Poly(last.o, last.b.calc(segLen, 0));
            c = Poly(last.o, last.c.calc(segLen, 0));
            unit = test_3_problem(last.o, last.t + segLen, a , b, c);
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

    end
    
end