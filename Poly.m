function p = Poly(order, init)
    order = order + 1;
    s = size(init);
    if order > s
        p = [init zeros(s(1), order-s(2))];
    else
        p = init(:, 1:order);
    end
end

% classdef Poly < handle
%     properties
%         c
%     end
%     
%     methods
%         function this = Poly(order, init)
%             if nargin == 0
%                 return;
%             end
%             if nargin >= 2
%                 s = size(init);
%                 if order > s
%                     for i = 1 : s(1)
%                         this(i, 1).c = [init(i, :) zeros(1, order-s(2))];
%                     end
%                 else
%                     for i = 1 : s(1)
%                         this(i, 1).c = init(i, 1:order);
%                     end
%                 end
%             end
%         end
%         
%         function v = calc(poly, t, order)
%             mat = Poly.toMatrix(poly);
%             s = size(mat);
%             if order > 0
%                 x = order:s(2)-1;
%                 for i = 2 : order
%                     x = x .* (order+1-i:s(2)-i);
%                 end
%                 mat = mat(order+1:end) .* x;
%                 s = size(mat);
%             end
%             x = zeros(s(2), size(t,2));
%             x(1,:) = 1;
%             for i = 2:s(2)
%                 x(i,:) = x(i-1, :) .* t;
%             end
%             v = mat * x;
%         end
%          
%         function npoly = deriv(poly)
%             mat = Poly.toMatrix(poly);
%             s = size(mat);
%             mat = mat(:, 2:end) * diag(1:s(2)-1);
%             npoly = Poly.toPoly([mat zeros(s(1), 1)]);
%         end
%         
%         function npoly = delay(poly, d)
%             mat = Poly.toMatrix(poly);
%             mat = mat * expandTransMat(size(mat, 2), d);
%             npoly = Poly.toPoly(mat);
%         end
%     end
%     methods (Static)
%         function mat = toMatrix(poly)
%             mat(size(poly,1), size(poly(1).c, 2)) = 0;
%             for i = 1 : size(poly, 1)
%                 mat(i, :) = poly(i).c;
%             end
%         end
%         function poly = toPoly(mat)
%             s = size(mat);
%             poly(s(1) , 1) = Poly(s(2), mat(end, :));
%             for i = 1 : s(1) -1
%                 poly(i) = Poly(s(2), mat(i,:));
%             end
%         end
%     end
% end