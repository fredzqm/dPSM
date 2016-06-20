% problem = DefaultProblem({1 0 1}, 0 , 0, ...
%     [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
%     rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
%         rel(3, -1, 0, [3 3]) ]);
classdef test_circuit_problem < AbstractProblem
    properties
        y
        yd
        ydd
    end
    
    properties (Constant)
        seglen = 1/100;
        initOrder = 100;
        intOrder = 30
    end
    
    methods
        function u = test_circuit_problem(last, simulator)
            segLen = test_circuit_problem.segLen;
            u.o = test_circuit_problem.intOrder;
            delaySeg = 1 / segLen;
            if nargin == 0
                u.t = 0;
                order = 0:test_circuit_problem.initOrder;
                x = mod(order, 2) .* ((-1).^(mod(order,4)==3)) ./ factorial(order);
                u.y = Poly(u.o, [x; x .* 2 .^ order;x .* 3 .^ order]);
            elseif simulator.len() == 0
                u.t = segLen * simulator.len();
                u.y = Poly(u.o, calc(last.y, 0, 0));
                u.yd = delay(last.y, segLen);
                u.ydd = deriv(u.yd);
            else
                u.t = segLen * simulator.len();
                u.y = Poly(u.o, calc(last.y, segLen, 0));
                [delayToComp, isInitComp] = simulator.lastComp(delaySeg);
                if isInitComp
                    u.yd = delay(delayToComp.y, (delaySeg - simulator.len())*segLen);
                else
                    u.yd = delayToComp.y;
                end
                u.ydd = deriv(u.yd);
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
            a = L * t.y(:, t.o);
            b = M * t.yd(:, t.o);
            c = N * t.ydd(:, t.o);
            r = a + b + c;
            t.y(:, t.o+1) = r / t.o;
        end
        
        function v = mainVariable(this)
            v = this.y(1, :);
        end
        
        function unit = createCompUnit(last, simulator)
            unit = test_circuit_problem(last, simulator);
        end
    end
    
end