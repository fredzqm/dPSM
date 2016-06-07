% problem = DefaultProblem({1 0 1}, 0 , 0, ...
%     [rel(1,1/2, 0, [1 3]) rel(1,-2, 1, 2) ...
%     rel(2,1/2, 0, [2 3]) rel(2, 2, 1, 1) ...
%         rel(3, -1, 0, [3 3]) ]);
% problem = DefaultProblem({1}, 0 , 1, rel(1,1, 0, 1 , 1) );
classdef test_sync_problem < AbstractProblem
    properties
        th = Poly.empty
        thd = Poly.empty
        v = Poly.empty
        u = Poly.empty
        th1_w1
        th1_w2
        th2_w1
        th2_w2
    end
    
    methods
        function u = test_sync_problem(last, simulator)
            if nargin == 0
                u.o = 10;
                u.t = 0;
                u.th(1) = Poly(u.o, 1);
                u.th(2) = Poly(u.o, 1);
                u.v(1) = Poly(u.o, 1);
                u.v(2) = Poly(u.o, 1);
                u.v(3) = Poly(u.o, 1);
                u.v(4) = Poly(u.o, 1);
                u.u(1) = Poly(u.o, 1);
                u.u(2) = Poly(u.o, 1);
                u.u(3) = Poly(u.o, 1);
                u.u(4) = Poly(u.o, 1);
                u.thd(1) = Poly(u.o, 1);
                u.thd(2) = Poly(u.o, 1);
            else
                segLen = 0.001;
                u.o = 10;
                u.t = segLen * simulator.len();
                u.th(1) = Poly(u.o, last.th(1).calc(segLen, 0));
                u.th(2) = Poly(u.o, last.th(2).calc(segLen, 0));
                u.v(1) = Poly(u.o, last.v(1).calc(segLen, 0));
                u.v(2) = Poly(u.o, last.v(2).calc(segLen, 0));
                u.v(3) = Poly(u.o, last.v(3).calc(segLen, 0));
                u.v(4) = Poly(u.o, last.v(4).calc(segLen, 0));
                u.u(1) = Poly(u.o, last.u(1).calc(segLen, 0));
                u.u(2) = Poly(u.o, last.u(2).calc(segLen, 0));
                u.u(3) = Poly(u.o, last.u(3).calc(segLen, 0));
                u.u(4) = Poly(u.o, last.u(4).calc(segLen, 0));
                u.thd(1) = last.th(1).deriv();
                u.thd(2) = last.th(2).deriv();
            end
			u.th1_w1 = Poly(u.o);
        	u.th1_w2 = Poly(u.o);
        	u.th2_w1 = Poly(u.o);
        	u.th2_w2 = Poly(u.o);
        end
        
        function unit = createCompUnit(last, simulator)
            unit = test_sync_problem(last, simulator);
        end
        
        function computeOneItr(t)
            w1 = (t.get(t.v(1)) + t.get(t.v(2)))/2 + t.const(1);
            w2 = (t.get(t.v(3)) + t.get(t.v(4)))/2 + t.const(1);
            t.addTo( t.th1_w1 , t.get(t.thd(1)) - w1);
            t.addTo( t.th1_w2 , t.get(t.thd(1)) - w2);
            t.addTo( t.th2_w1 , t.get(t.thd(2)) - w1);
            t.addTo( t.th2_w2 , t.get(t.thd(2)) - w2);
            t.addIntegTo(t.th(1), w1);
            t.addIntegTo(t.th(2), w2);
            t.addIntegTo(t.u(1), t.multiple(t.v(1), t.th2_w1));
            t.addIntegTo(t.v(1), -t.multiple(t.u(1), t.th2_w1));
            t.addIntegTo(t.u(2), t.multiple(t.v(2), t.th1_w1));
            t.addIntegTo(t.v(2), -t.multiple(t.u(2), t.th1_w1));
            t.addIntegTo(t.u(3), t.multiple(t.v(3), t.th2_w2));
            t.addIntegTo(t.v(3), -t.multiple(t.u(3), t.th2_w2));
            t.addIntegTo(t.u(4), t.multiple(t.v(4), t.th1_w2));
            t.addIntegTo(t.v(4), -t.multiple(t.u(4), t.th1_w2));
        end
        
        function v = mainVariable(this)
            v = this.th(1);
        end

    end
    
end