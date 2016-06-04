function x = expandTransMat(n, d)
    if n == 1 || d == 0
        x = 1;
        return;
    end
    x = pascal(n);
    x(x>=n) = 0;
    x = diag(d .^ (0:n-1)) * x;
    x = [x; zeros(1, n)];
    x = reshape(x , n , n+1);
    x = x(:, 1:n);
end
