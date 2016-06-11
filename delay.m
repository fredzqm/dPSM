function mat = delay(mat, d)
    mat = mat * expandTransMat(size(mat, 2), d);
end