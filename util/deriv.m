function mat = deriv(mat, order)
    if nargin < 2
        order = 1;
    end
    mat = mat * derivMatrix(size(mat, 2), order);
end

function x = derivMatrix(n, order)
    x = diag(ones(n-order, 1));
    ls = ones(1, n-order);
    for i = 1 : order;
        ls = ls .* (i:i+n-order-1);
    end
    x = [[zeros(order, n-order); diag(ls)] zeros(n,order)];
end