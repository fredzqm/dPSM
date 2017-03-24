assert(calc([1, 0], 1) == 1);
assert(calc([1, 1], 1) == 2);
assert(calc([1, 1], 10) == 11);
assert(calc([1, 1, 1], 10) == 111);
assert(calc([1, 1, 1], 10, 1) == 21);
assert(calc([1, 1, 1; 1 , 1, 1], [10, 11], 1) == 21);