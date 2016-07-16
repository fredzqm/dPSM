function p = Poly(order, init)
    order = order + 1;
    s = size(init);
    if order > s(2)
        p = [init zeros(s(1), order-s(2))];
    else
        p = init(:, 1:order);
    end
end