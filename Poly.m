classdef Poly < handle
    properties
        c
    end
    
    methods
        function this = Poly(order, init)
            if nargin == 0
                return;
            end
            this.c = zeros(1, order);
            if nargin >= 2
                s = size(init, 2);
                this.c(1:s) = init;
            end
        end
        
        function v = calc(poly, t, order)
            if order == 0
                if t == 0
                    v =  poly.c(1);
                    return;
                end
                v = t;
                v(:) = poly.c(end);
                for i = size(poly.c, 2)-1 : -1 : 1
                    v = v .* t;
                    v = v + poly.c(i);
                end
            else
                if order > size(poly.c, 2)
                    v = 0;
                    return;
                end
                c2 = poly.c .* factorial(0:size(poly.c, 2)-1);
                if t == 0
                    v = c2(1+order);
                    return;
                end
                v = t;
                v(:) = c2(end);
                for i = size(c2, 2)-1 : -1 : 1 + order
                    v = v .* t / (i - order);
                    v = v + c2(i);
                end
            end
        end
         
        function npoly = deriv(poly)
            npoly = Poly();
            len = size(poly.c, 2);
            npoly.c = poly.c(2:end) ./ (1:len-1);
            npoly.c(end+1) = 0;
        end
    end
    
end