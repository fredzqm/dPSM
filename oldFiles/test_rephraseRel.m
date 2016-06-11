% clear;
relation = [ rel(1, 1, 0, 2)   rel(1, -2, 2,[2 2]) ...
     rel(2,-2, 1, [2 2]) rel(2, 10, 2, [1 1 1 1 1 1]) ...
     rel(3, 1, 1, [1 3 4]) rel(3, 1, 1, [2 2 2 3 3]) rel(3,1,2,[3 3 3 1 1 1 2]) ...
     ];

[adderRel, multRel] = rephraseRel( relation );

%%
clear;
relation = [ rel(1, 1, 0, [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1])...
              rel(2, 1, 0, [1 1])];

[adderRel, multRel] = rephraseRel( relation );


%%
clear;
relation = [ ...
            rel(1, 1, 0, [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]) ...
            rel(2, 1, 0, [1 1 1 1 1 1 1 1 1 2 2 2 2 2 2]) ...
%               rel(3, 1, 0, [1 1 1 1 ]) ...
%               rel(2, 1, 0, [1 1]) ...
            ];

[adderRel, multRel, delayRel] = rephraseRel( relation );

%%
relation = [rel(1, 1, 0, 1, 1)]

[adderRel, multRel, delayRel] = rephraseRel( relation );