classdef AbstractProblem < handle
    properties
        t
        o
    end
    
    methods (Abstract)
        unit = createCompUnit(this, simulator)
        
        computeOneItr(unit)
        v = mainVariable(this)
        v = getSegLen(this)
    end
    
    methods
        function compute(t)
            order = t.o;
            for k = 1 : order
                t.o = k;
                t.computeOneItr();
            end
        end

        function diff = checkSegDiff(t)
            destPt = t.t + t.getSegLen();
            a = t.calc(destPt, 0);
            t.o = t.o + 1;
            t.computeOneItr();
            b = t.calc(destPt, 0);
            diff = abs(b-a);
        end
        
        function v = calc(this, t, order)
            poly = this.mainVariable();
            v = calc(poly, t - this.t, order);
        end
                
        function v = const(t, con)
            if t.o <= size(con, 2)
                v = con(:, t.o);
            else
                v = zeros(size(con, 2), 1);
            end
        end
        
        function v = multiple(t, a, b)
            x = a(:, 1:t.o);
            y = fliplr(b(:, 1:t.o));
            v = sum(x .* y, 2);
        end
        
        function v = multiplePoly(t, a, p)
            len = min(size(p, 2), t.o) - 1;
            p = delay(p, t.t);
            p = fliplr(p);
            v = sum( a(t.o-len:t.o) .* p(end-len:end) );
        end
        
    end
end
