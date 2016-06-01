function mat = integrateTransMat(n)
    mat =[zeros(n, 1)  diag(1 ./ (1:n))];
end