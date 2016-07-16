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