classdef compUnit
     properties (SetAccess = public)
        t;
        adder;
        multer;
     end
    
    methods
        % create a computational unit with initial value provided with 
        % this.simulatorValue(), which return the accurate function value
        % if known, otherwise estimate with PSM.
        function unit = compUnit(simulator, initTime)
            unit.t = initTime;
            unit.adder = Adder(0);
            for i = 1 : size(simulator.initValue, 2)
                unit.adder(i) = Adder( simulator.calc(i, initTime, 0) );
            end
%             delay
            for i = 1 : size(simulator.delayRel, 2)
                time = initTime - simulator.delay;
                x = simulator.findIndex(time);
                poly = 1;
                for l = simulator.delayRel(i).list
                    poly = conv(simulator.f(x).adder(x), x , 'same');
                end
                unit.delay(i) = Delayer(poly);
            end
            unit.multer = Multipler(unit.adder(1), unit.adder(1));
            for i = 1 : size(simulator.multRel, 2)
                mult = simulator.multRel(i);
                a = extractComp(unit, mult.a);
                b = extractComp(unit, mult.b);
                unit.multer(i) = Multipler(a, b);
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