function mat = delay(mat, d)
    n = size(mat, 2);
    if n == 1 || d == 0
        return;
    end
    x = diag(ones(1, n));
    x(:, 1) = 1;
    for i = 2 : n
        x(i, 1) = x(i-1, 1) * d;
        x(i, 2:i-1) = x(i-1, 1:i-2) + x(i-1, 2:i-1) * d;
    end
    mat = mat * x;
end