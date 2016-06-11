classdef DefaultCompUnit
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
        function unit = DefaultCompUnit(factory, simulator, initTime)
            unit.t = initTime;
            s = size(factory.initValue, 2);
            unit.adder = Adder();
            if size(simulator.f, 2) == 0
                for i = 1 : s
                    unit.adder(i) = Adder( factory.initValue{i} );
                end
            else
                lastComp = simulator.f(end);
                for i = 1 : s
                    unit.adder(i) = Adder( lastComp.adder(i).calc(initTime - lastComp.t, 0) );
                end
            end
            
            s = size(factory.delayRel, 2);
            if s > 0
                unit.delay = Delayer();
                for i = 1 : s
                    poly = 1;
                    time = initTime - factory.delay;
                    if time < factory.initTime
                        for j = factory.delayRel(i).list
                            poly = conv(factory.initValue{j}, poly);
                        end
                        poly = poly * expandTransMat(size(poly, 2), time - factory.initTime);
                    else
                        comp = simulator.findComp(initTime - factory.delay);
                        for j = factory.delayRel(i).list
                            poly = conv(comp.adder(j).taylor1, poly , 'same');
                        end
                        poly = poly * expandTransMat(size(poly, 2), time - comp.t);
                    end
                    unit.delay(i) = Delayer(poly);
                end
            end
            
            s = size(factory.multRel, 2);
            if s > 0
                unit.multer = Multipler();
                for i = 1 : s
                    mult = factory.multRel(i);
                    a = extractComp(unit, mult.a);
                    b = extractComp(unit, mult.b);
                    unit.multer(i) = Multipler(a, b);
                end
            end
            
            for i = 1 : size(factory.adderRel, 2)
                for k = factory.adderRel(i).list
                    comps = extractComp(unit, k.multer);
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
        
        function v = calc(this, time, order)
            v = this.adder(1).calc(time - this.t, order);
        end
        
    end
        
end