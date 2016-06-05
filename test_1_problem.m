% problem = DefaultProblem({0 1} , 0 , 1 , ...
%     [rel( 1 , 1 , 0 , 2 ) rel( 2 , -1, 0 , 1 ) ]);
classdef test_1_problem < AbstractProblem
    properties
        t
        a
        b
    end
    
    methods
        
        function unit = createFirstCompUnit(this, simulator)
            unit = test_1_problem;
            unit.t = 0;
            unit.a = Adder(0);
            unit.b = Adder(1);
            unit.a.addR(1, 0, unit.b);
            unit.b.addR(-1, 0, unit.a);
        end
        
        function unit = createCompUnit(this, simulator, initTime)
            unit = test_1_problem;
            unit.t = initTime;
            lastComp = simulator.f(end);
            unit.a = Adder( lastComp.a.calc(initTime - lastComp.t, 0) );
            unit.b = Adder( lastComp.b.calc(initTime - lastComp.t, 0) );
            unit.a.addR(1, 0, unit.b);
            unit.b.addR(-1, 0, unit.a);
        end
        
        function repeatCompute(unit, order)
            for k = 1 : order
                unit.a.compute();
                unit.b.compute();
            end
        end
        function v = calc(this, time, order)
            v = this.a.calc(time - this.t, order);
        end
    end
    
end