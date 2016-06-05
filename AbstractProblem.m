classdef AbstractProblem < handle
    properties (Abstract)
        t
    end
    
    methods (Abstract)
        unit = createFirstCompUnit(this, simulator)
        unit = createCompUnit(this, simulator, initTime)
        
        repeatCompute(unit, order)
        v = calc(this, time, order)
    end
    
    methods     
        function addIntegTo(t, dest, value)
            dest.c(t.o+1) = value / (t.o+1);
        end
        
        function v = get(t, src)
            v = src.c(t.o);
        end
        
        function v = mainVariable(this)
            v = this.a;
        end
        
        function v = calc(this, t, order)
            poly = this.mainVariable();
            v = poly.calc(t, order);
        end
    end
end