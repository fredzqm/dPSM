function mat = deriv(mat)
    s = size(mat);
    mat = mat(:, 2:end) * diag(1:s(2)-1);
    mat = [mat zeros(s(1), 1)];
end