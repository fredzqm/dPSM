function mat = delay(mat, d)
    n = size(mat, 2);
    if n == 1 || d == 0
        return;
    end
    if size(d, 2) < n
        d(n) = 0;
    end
    d(2) = d(2) + 1;
    x = zeros(n, n);
    x(1, 1) = 1;
    for i = 2 : n
        x(i, :) = conv(x(i-1,:) , d, 'same');
    end
    mat = mat * x;
end
