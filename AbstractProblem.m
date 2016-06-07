classdef AbstractProblem < handle
    properties
        t
        o
    end
    
    methods (Abstract)
        unit = createCompUnit(this, simulator)
        
        computeOneItr(unit)
        v = mainVariable(this)
    end
    
    methods
        function compute(t)
            order = t.o;
            for k = 1 : order
                t.o = k;
                t.computeOneItr();
            end
        end
                
        function v = calc(this, t, order)
            poly = this.mainVariable();
            v = poly.calc(t - this.t, order);
        end
        
        
        function addIntegTo(t, dest, value)
            dest.c(t.o+1) = value / t.o;
        end
        
        function v = get(t, src)
            v = src.c(t.o);
        end
        
        function v = multiple(t, a, b)
            x = a.c(1:t.o);
            y = fliplr(b.c(1:t.o));
            v = sum(x .* y);
        end
        
        function v = multiplePoly(t, a, p)
            len = min(size(p, 2), t.o) - 1;
            p = p * expandTransMat(size(p, 2), t.t);
            p = fliplr(p);
            v = sum( a.c(t.o-len:t.o) .* p(end-len:end) );
        end
        
    end
end
