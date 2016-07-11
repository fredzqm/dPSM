function v = calc(mat, t, order)
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
end

function calchelper(mat, t, order)
    if order == 0
        x = (t.^(0:this.len-1)) .* this.taylor1;
        v = sum(x);
    else
        x = this.taylor2(1+order:end);
        x = x .* (t.^(0:this.len-order-1)) ./ factorial(0:this.len-order-1);
        v = sum(x);
    end


    if order == 0
        if t == 0
            v =  mat(:, 1);
            return;
        end
        v = t;
        v(:) = mat(:, end);
        for i = s(2)-1 : -1 : 1
            v = v .* t;
            v = v + mat(:, i);
        end
    else
        if order > s(2)
            v = zeros(s(1), 0);
            return;
        end
        if t == 0
            v = mat(:, 1+order) * factorial(order);
            return;
        end
        c2 = mat * diag(factorial(0:s(2)-1));
        v = t;
        v(:) = c2(end);
        for i = size(c2, 2)-1 : -1 : 1 + order
            v = v .* t / (i - order);
            v = v + c2(i);
        end
    end
end