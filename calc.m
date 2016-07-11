function v = calc(mat, t, order)
    v = zeros(size(mat, 1), size(t, 2));
    if order == 0
        for i = 1 : size(mat, 1)
            v(i, :) = calcZeroOrder(mat(i, :), t);
        end
    else
        mat = mat * diag(factorial(0:size(mat, 2)-1));
        mat = mat(:, order+1:end);
        for i = 1 : size(mat, 1)
            v(i, :) = calcDeriv(mat(i, :), t);
        end
    end
end

function vv = calcZeroOrder(coef, tt)
    vv = ones(size(tt)) * coef(end);
    for i = size(coef, 2)-1 : -1 : 1
        vv = vv .* tt;
        vv = vv + coef(i);
    end
end
function vv = calcDeriv(coef, tt)
    vv = ones(size(tt)) * coef(end);
    for i = size(coef, 2)-1 : -1 : 1
        vv = vv .* tt / i;
        vv = vv + coef(i);
    end
end

%         vv = ones(size(tt)) * coef(end);
%         for i = size(coef, 1)-1 : -1 : 1
%             vv = vv .* tt;
%             vv = vv + coef(i);
%         end
%         c2 = coef * diag(factorial(0:s(2)-1));
%         v = tt;
%         v(:) = c2(end);
%         for i = size(c2, 2)-1 : -1 : 1 + order
%             v = v .* tt / (i - order);
%             v = v + c2(i);
%         end
%     end
%     if order == 0
%         x = (tt.^(0:this.len-1)) .* this.taylor1;
%         v = sum(x);
%     else
%         x = this.taylor2(1+order:end);
%         x = x .* (tt.^(0:this.len-order-1)) ./ factorial(0:this.len-order-1);
%         v = sum(x);
%     end
%     if order == 0
%         if tt == 0
%             v =  coef(:, 1);
%             return;
%         end
%         v = tt;
%         v(:) = coef(:, end);
%         for i = s(2)-1 : -1 : 1
%             v = v .* tt;
%             v = v + coef(:, i);
%         end
%     else
%         if order > s(2)
%             v = zeros(s(1), 0);
%             return;
%         end
%         if tt == 0
%             v = coef(:, 1+order) * factorial(order);
%             return;
%         end
%         c2 = coef * diag(factorial(0:s(2)-1));
%         v = tt;
%         v(:) = c2(end);
%         for i = size(c2, 2)-1 : -1 : 1 + order
%             v = v .* tt / (i - order);
%             v = v + c2(i);
%         end
%     end
% end