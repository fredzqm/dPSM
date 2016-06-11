classdef Poly < handle
    properties
        c
    end
    
    methods
        function this = Poly(order, init)
            if nargin == 0
                return;
            end
            if nargin >= 2
                s = size(init);
                if order > s
                    for i = 1 : s(1)
                        this(i, 1).c = [init(i, :) zeros(1, order-s(2))];
                    end
                else
                    for i = 1 : s(1)
                        this(i, 1).c = init(i, 1:order);
                    end
                end
            end
        end
        
        function v = calc(poly, t, order)
            mat = Poly.toMatrix(poly);
            s = size(mat);
            if order > 0
                x = order:s(2)-1;
                for i = 2 : order
                    x = x .* (order+1-i:s(2)-i);
                end
                mat = mat(order+1:end) .* x;
                s = size(mat);
            end
            x = zeros(s(2), size(t,2));
            x(1,:) = 1;
            for i = 2:s(2)
                x(i,:) = x(i-1, :) .* t;
            end
            v = mat * x;
            
%             if order == 0
%                 x = (t.^(0:this.len-1)) .* this.taylor1;
%                 v = sum(x);
%             else
%                 x = this.taylor2(1+order:end);
%                 x = x .* (t.^(0:this.len-order-1)) ./ factorial(0:this.len-order-1);
%                 v = sum(x);
%             end
%             
%                         
%             if order == 0
%                 if t == 0
%                     v =  mat(:, 1);
%                     return;
%                 end
%                 v = t;
%                 v(:) = mat(:, end);
%                 for i = s(2)-1 : -1 : 1
%                     v = v .* t;
%                     v = v + mat(:, i);
%                 end
%             else
%                 if order > s(2)
%                     v = zeros(s(1), 0);
%                     return;
%                 end
%                 if t == 0
%                     v = mat(:, 1+order) * factorial(order);
%                     return;
%                 end
%                 c2 = mat * diag(factorial(0:s(2)-1));
%                 v = t;
%                 v(:) = c2(end);
%                 for i = size(c2, 2)-1 : -1 : 1 + order
%                     v = v .* t / (i - order);
%                     v = v + c2(i);
%                 end
%             end
        end
         
        function npoly = deriv(poly)
            mat = Poly.toMatrix(poly);
            s = size(mat);
            mat = mat(:, 2:end) * diag(1:s(2)-1);
            npoly = Poly.toPoly([mat zeros(s(1), 1)]);
%             if size(poly, 1) == 1
%                 npoly = Poly();
%                 npoly.c = [poly.c(2:end)./(1:len-1) 0];
%             else
%                 npoly(size(poly, 1), 1) = Poly();
%                 len = size(poly(1).c, 2);
%                 for i =  size(poly, 1): -1 :1
%                     npoly(i).c = [poly(i).c(2:end)./(1:len-1) 0];
%                 end
%             end
        end
        
        function npoly = delay(poly, d)
            mat = Poly.toMatrix(poly);
            mat = mat * expandTransMat(size(mat, 2), d);
            npoly = Poly.toPoly(mat);
%             if size(poly, 1) == 1
%                 npoly = Poly();
%                 npoly.c = poly.c * mat;
%             else
%                 npoly(size(poly, 1), 1) = Poly();
%                 for i =  size(poly, 1): -1 :1
%                     npoly(i).c = poly(i).c * mat;
%                 end
%             end
        end
    end
    methods (Static)
        function mat = toMatrix(poly)
            mat(size(poly,1), size(poly(1).c, 2)) = 0;
            for i = 1 : size(poly, 1)
                mat(i, :) = poly(i).c;
            end
        end
        function poly = toPoly(mat)
            s = size(mat);
            poly(s(1) , 1) = Poly(s(2), mat(end, :));
            for i = 1 : s(1) -1
                poly(i) = Poly(s(2), mat(i,:));
            end
        end
    end
end