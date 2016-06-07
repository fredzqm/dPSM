% problem = DefaultProblem({1 0 1}, 0 , 0, ...
%     [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
%     rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
%         rel(3, -1, 0, [3 3]) ]);
% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
classdef test_sync_problem < AbstractProblem
    properties
        a
        d
    end
    
    methods
        function u = test_sync_problem(last, simulator)
            if nargin == 0
                u.o = 10;
                u.t = -1;
                u.a = Poly(u.o, 1);
                u.d = Poly(u.o, 1);
            else
                segLen = 1;
                u.o = 10;
                u.t = last.t + segLen;
                u.a = Poly(last.o, last.a.calc(segLen, 0));
                u.d = last.a;
            end
        end
        
        function unit = createCompUnit(last, simulator)
            unit = test_sync_problem(last, simulator)
        end
        
        function computeOneItr(t)
            t.addIntegTo(t.a, t.multiple(t.a, t.d));
        end
        
        function v = mainVariable(this)
            v = this.a;
        end

    end
    
end