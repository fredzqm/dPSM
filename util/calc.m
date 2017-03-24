function v = calc(mat, t, order)
    s = size(mat);
    if nargin == 3 && order > 0
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
end

% function v = calc(mat, t, order)
%     v = zeros(size(mat, 1), size(t, 2));
%     if order == 0
%         for i = 1 : size(mat, 1)
%             v(i, :) = calcZeroOrder(mat(i, :), t);
%         end
%     else
%         mat = mat * diag(factorial(0:size(mat, 2)-1));
%         mat = mat(:, order+1:end);
%         for i = 1 : size(mat, 1)
%             v(i, :) = calcDeriv(mat(i, :), t);
%         end
%     end
% end
% 
% function vv = calcZeroOrder(coef, tt)
%     vv = ones(size(tt)) * coef(end);
%     for i = size(coef, 2)-1 : -1 : 1
%         vv = vv .* tt;
%         vv = vv + coef(i);
%     end
% end
% 
% function vv = calcDeriv(coef, tt)
%     vv = ones(size(tt)) * coef(end);
%     for i = size(coef, 2)-1 : -1 : 1
%         vv = vv .* tt / i;
%         vv = vv + coef(i);
%     end
% end