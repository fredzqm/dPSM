% problem = DefaultProblem({0 1} , 0 , 1 , ...
%     [rel( 1 , 1 , 0 , 2 ) rel( 2 , -1, 0 , 1 ) ]);
classdef test_1_problem < AbstractProblem
    properties
        t
        a
        b
        o
    end
    
    methods
        
        function unit = createFirstCompUnit(this, simulator)
            order = simulator.minOrder;
            
            unit = test_1_problem;
            unit.t = 0;
            unit.a = Poly(order, 0);
            unit.b = Poly(order, 1);
        end
        
        function unit = createCompUnit(this, simulator, initTime)
            unit = test_1_problem;
            unit.t = initTime;
            lastComp = simulator.f(end);
            unit.a = Adder( lastComp.a.calc(initTime - lastComp.t, 0) );
            unit.b = Adder( lastComp.b.calc(initTime - lastComp.t, 0) );
        end
        
        function repeatCompute(t, order)
            for k = 1 : order
                t.o = k;
                
                t.addIntegTo(t.a, t.get(t.b) * 1);
                t.addIntegTo(t.b, t.get(t.a) * -1);
            end
        end

    end
    
end