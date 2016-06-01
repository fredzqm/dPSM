function a = pascalTrig(n, d)
    persistent data;
    if n > size(data,1)
        if size(data,1) == 0
            data{1} = [1 1];
        end
        for i = size(data,1) : n-1
            data{i+1} = conv(data{i}, [1 1]);
        end
    end
    a = data{n};
    a = a .* d .^ (0:n);
end