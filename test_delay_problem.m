% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
classdef test_delay_problem < AbstractProblem
    properties
        t
        o
        a
        d
    end
    
    methods
        
        function unit = createFirstCompUnit(this, simulator)
            order = simulator.minOrder;
            unit = test_delay_problem;
            unit.t = 0;
            unit.a = Poly(order, 1);
            unit.d = Poly(order, 1);
        end
        
        function unit = createCompUnit(this, simulator, initTime)
            order = simulator.minOrder;
            unit = test_delay_problem;
            unit.t = initTime;
            lastComp = simulator.f(end);
            unit.a = Poly(order, lastComp.a.calc(initTime - lastComp.t, 0));
            dcomp = simulator.findComp(initTime - 1);
            unit.d = Poly(0);
            unit.d.c = dcomp.a.c * expandTransMat(order, initTime - 1 - dcomp.t);
        end
        
        
        function computeOneItr(t)
            t.addIntegTo(t.a, t.multiple(t.a, t.d));
        end
        
        function v = mainVariable(this)
            v = this.a;
        end

    end
    
end