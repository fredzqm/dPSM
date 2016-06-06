% problem = DefaultProblem({1 0 1}, 0 , 0, ...
%     [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
%     rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
%         rel(3, -1, 0, [3 3]) ]);
classdef test_3_problem < AbstractProblem
    properties
        t
        o
        a
        b
        c
    end
    
    methods
        
        function unit = createFirstCompUnit(this, simulator)
            order = simulator.minOrder;
            unit = test_3_problem;
            unit.t = 0;
            unit.a = Poly(order, 1);
            unit.b = Poly(order, 0);
            unit.c = Poly(order, 1);
        end
        
        function unit = createCompUnit(this, simulator, initTime)
            order = simulator.minOrder;
            unit = test_3_problem;
            unit.t = initTime;
            lastComp = simulator.f(end);
            unit.a = Poly(order, lastComp.a.calc(initTime - lastComp.t, 0));
            unit.b = Poly(order, lastComp.b.calc(initTime - lastComp.t, 0));
            unit.c = Poly(order, lastComp.c.calc(initTime - lastComp.t, 0));
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