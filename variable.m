classdef variable < handle
    properties (SetAccess = public)
        cub
    end
    
    methods
        function this = variable(init)
            this.cub = init;
        end
                
        function s = size(this)
            s = [size(this.cub, 1) size(this.cub(1))];
        end
        
        function coeff = getCoef(this, delay,order,taoMult)
            coeff = this.cub(delay).getCoef(order,taoMult);
        end
        
        function setC(this,delay,order,taoMult,value)
            this.cub(delay).setC(order,taoMult, value);
        end
        
        function new = delay(this)
            new = variable( [ layer([]) , this.cub ]);
        end
        
        function new = copy(this)
            c = this.cub;
            for i = 1:size(c,2)
                c(i) = c(i).copy();
            end
            new = variable(c);
        end
        
        function new = integrate(this)
            c = this.cub;
            for i = 1:size(c,2)
                c(i) = c(i).integrate();
            end
            c(1).addWith(layer([0 1]));
            new = variable(c);
        end
        
        function new = multiply(a,b)
            if size(a.cub, 2) < size(b.cub, 2)
                new = multiple(b,a);
                return;
            end
            nCub = layer([]);
            for i = 1: size(b.cub, 2)
                nCub(i) = multiple(a.cub(i),b.cub(i));
                nCub(i).addWith(a.cub(i));
                nCub(i).addWith(b.cub(i));
                for j = 1:i-1
                   nCub(i).addWith(multiple(a.cub(i),b.cub(j).shift(i-j))); 
                   nCub(i).addWith(multiple(a.cub(j).shift(i-j),b.cub(i))); 
                end
            end
            for i = size(b.cub, 2) + 1 : size(a.cub, 2)
                nCub(i) = a.cub(i).copy();
                for j = 1:size(b.cub, 2)
                   nCub(i).addWith(multiple(a.cub(i),b.cub(j).shift(i-j)));
                end
            end
            new = variable(nCub);
        end
    end
end