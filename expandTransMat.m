function x = expandTransMat(n, d)
%     persistent data;
    x = pascal(n);
    x(x>=n) = 0;
    x = diag(d .^ (0:n-1)) * x;
    x = [x; zeros(1, n)];
    x = reshape(x , n , n+1);
    x = x(:, 1:n);
%     if n > size(data,1)
%         if size(data,1) == 0
%             data{1} = [1 1];
%         end
%         for i = size(data,1) : n-1
%             data{i+1} = conv(data{i}, [1 1]);
%         end
%     end
%     a = data{n};
%     a = a .* d .^ (0:n);
end
