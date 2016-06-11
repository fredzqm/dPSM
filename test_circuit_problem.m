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
    methods
        function u = test_circuit_problem(last, simulator)
            segLen = 0.004;
            delay = 1;
            u.o = 10;
            delaySeg = delay / segLen;
            if nargin == 0
                u.t = 0;
                order = 0:u.o;
                x = mod(order, 2) .* ((-1).^(mod(order,4)==3)) ./ factorial(order);
                u.y(1, 1) = Poly(u.o, x);
                u.y(2, 1) = Poly(u.o, x .* 2 .^ order);
                u.y(3, 1) = Poly(u.o, x .* 3 .^ order);
            elseif simulator.len() == 0
                u.t = segLen * simulator.len();
                u.y = Poly(u.o, last.y.calc(0, 0));
                u.yd = last.y.delay(segLen);
                u.ydd = u.yd.deriv();
            else
                u.t = segLen * simulator.len();
                u.y = Poly(u.o, last.y.calc(segLen, 0));
                [delayToComp, isInitComp] = simulator.lastComp(delaySeg);
                if isInitComp
                    u.yd = delayToComp.y.delay((delaySeg - simulator.len())*segLen);
                else
                    u.yd = delayToComp.y;
                end
                u.ydd = u.yd.deriv();
            end
        end
        

        
        % problem = DefaultProblem({1 0 1}, 0 , 0, ...
        %     [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
        %      rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
        %         rel(3, -1, 0, [3 3]) ]);
        function computeOneItr(t)
            L = [-7 1 2; 3 -9 0; 1 2 -6];
            M = [1 0 -3; -0.5 -0.5 -1; -0.5 -1.5 0];
            N = [-1 5 2; 4 0 3; -2 4 1] /  72;
            a = L * t.get(t.y);
            b = M * t.get(t.yd);
            c = N * t.get(t.ydd);
            r = a + b + c;
            t.addIntegTo(t.y, r);
        end
        
        function v = mainVariable(this)
            v = this.y(1);
        end
        
        function unit = createCompUnit(last, simulator)
            unit = test_circuit_problem(last, simulator);
        end
    end
    
end