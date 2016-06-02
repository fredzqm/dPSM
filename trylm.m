clear;
numItr = 10;

v = variable(layer([0 1]));
for i = 2:numItr
    a = v(i-1).delay();
    b = v(i-1).copy();
    m = a.multiply(b);
    v(i) = m.integrate();
end
