% problem = DefaultProblem({1 0 1}, 0 , 0, ...
%     [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
%     rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
%         rel(3, -1, 0, [3 3]) ]);
classdef test_circuit_problem < AbstractProblem
    properties
        y = Poly.empty
        yd
        ydd
    end
    properties (Constant)
        tau = 1
    end
    methods
        function u = test_circuit_problem(last, simulator)
            if nargin == 0
                u.o = 20;
                u.t = 0;
                order = 0:20;
                x = real(1i .^ (order) ./ factorial(order));
                u.y(1, 1) = Poly(u.o, x);
                u.y(2, 1) = Poly(u.o, x .* 2 .^ order);
                u.y(3, 1) = Poly(u.o, x .* 3 .^ order);
                u.yd = u.y.delay(test_circuit_problem.tau);
                u.ydd = u.yd.deriv();
            else
                segLen = 1;
                u.o = 100 - simulator.len();
                u.t = segLen * simulator.len();
                u.y = Poly(u.o, last.y.calc(segLen, 0));
                u.yd = last.y;
                u.ydd = last.y.deriv();
            end
        end
        

        
        % problem = DefaultProblem({1 0 1}, 0 , 0, ...
        %     [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
        %      rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
        %         rel(3, -1, 0, [3 3]) ]);
        function computeOneItr(t)
            L = [-7 1 2; 3 -9 0; 1 2 -6] * 100;
            M = [1 0 -3; -0.5 -0.5 -1; -0.5 -1.5 0] * 100;
            N = [-1 5 2; 4 0 3; -2 4 1] /  72;
            t.addIntegTo(t.y, L * t.get(t.y) + M * t.get(t.dy) + N * t.get(t.ddy)); 
%             t.addIntegTo(t.a, 1/2*t.multiple(t.a, t.c) - 2*t.multiplePoly(t.b, [0 1]));
%             t.addIntegTo(t.b, 1/2*t.multiple(t.b, t.c) + 2*t.multiplePoly(t.a, [0 1]));
%             t.addIntegTo(t.c, - t.multiple(t.c,t.c));
        end
        
        function v = mainVariable(this)
            v = this.a;
        end
        
        function unit = createCompUnit(last, simulator)
            unit = test_circuit_problem(last, simulator);
        end
    end
    
end