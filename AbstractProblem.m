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
            v = calc(poly, t - this.t, order);
        end
        
        
%         function addIntegTo(t, dest, value)
%             for i = 1 : size(value, 1)
%                 dest(i).c(1, t.o+1) = value(i) / t.o;
%             end
%         end
        
        function addTo(t, dest, value)
            dest.c(:, t.o) = value;
        end
        
%         function v = get(t, src)
%             mat = Poly.toMatrix(src);
%             v = mat(:,t.o);
%         end
        
        function v = const(t, con)
            if t.o < size(con, 2)
                v = con(:, t.o);
            else
                v = zeros(size(con, 2), 1);
            end
        end
        
        function v = multiple(t, a, b)
            x = a(1:t.o);
            y = fliplr(b(1:t.o));
            v = sum(x .* y);
        end
        
        function v = multiplePoly(t, a, p)
            len = min(size(p, 2), t.o) - 1;
            p = delay(p, t.t);
            p = fliplr(p);
            v = sum( a(t.o-len:t.o) .* p(end-len:end) );
        end
        
    end
end
