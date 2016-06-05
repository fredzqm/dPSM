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
    
end