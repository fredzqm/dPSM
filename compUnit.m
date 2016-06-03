classdef compUnit
     properties (SetAccess = public)
        t;
        adder;
        multer;
        delay;
     end
    
    methods
        % create a computational unit with initial value provided with 
        % this.simulatorValue(), which return the accurate function value
        % if known, otherwise estimate with PSM.
        function unit = compUnit(simulator, initTime)
            unit.t = initTime;
            s = size(simulator.initValue, 2);
            unit.adder = Adder();
            for i = 1 : s
                unit.adder(i) = Adder( simulator.calc(i, initTime, 0) );
            end
            
            s = size(simulator.delayRel, 2);
            if s > 0
                unit.delay = Delayer();
                for i = 1 : s
                    if simulator.initTime == initTime
                        poly = zeros(simulator.minOrder, 1);
                        poly(1) = simulator.initValue(1);
                    else
                        time = initTime - simulator.delay;
                        x = simulator.findIndex(time);
                        poly = 1;
                        for l = simulator.delayRel(i).list
                            % wrong
                            poly = conv(simulator.f(x).adder(x).taylor2, x , 'same');
                        end
                    end
                    unit.delay(i) = Delayer(poly);
                end
            end
            
            s = size(simulator.multRel, 2);
            if s > 0
                unit.multer = Multipler();
                for i = 1 : s
                    mult = simulator.multRel(i);
                    a = extractComp(unit, mult.a);
                    b = extractComp(unit, mult.b);
                    unit.multer(i) = Multipler(a, b);
                end
            end
            
            for i = 1 : size(simulator.adderRel, 2)
                for k = simulator.adderRel(i).list
                    if k.multer.t
                        comps = unit.multer(k.multer.i);
                    else
                        comps = unit.adder(k.multer.i);
                    end
                    for order = 0 : k.order
                        unit.adder(i).addR(k.coefficient*nchoosek(k.order,order)...
                            *initTime^order , k.order - order ,  comps );
                    end
                end
            end
        end
        
        function x = extractComp(unit, a)
            if a.t == 0
                x = unit.adder(a.i);
            elseif a.t == 1
                x = unit.multer(a.i);
            else
                x = unit.delay(a.i);
            end
        end
        
        function repeatCompute(unit, order)
            for k = 1 : order
                for i = unit.multer
                    i.compute();
                end
                for i = unit.adder
                    i.compute();
                end
            end
        end
        
    end
        
end