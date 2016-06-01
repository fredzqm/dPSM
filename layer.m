classdef layer < handle
    properties (SetAccess = public)
        mat
    end
    
    methods
        function this = layer(init)
            this.mat = init;
        end
        
        function coeff = getCoef(this, order, taoMult)
            coeff = this.mat(order+taoMult,taoMult+1);
        end
        
        function setC(this, order, taoMult, value)
            this.mat(order+taoMult,taoMult+1) = value;
        end
        
        function new = copy(this)
            new = layer(this.mat);
        end
        
        function new = integrate(this)
            nMat = [];
            
            for i = 1 : size(this.mat, 1)
                for j = 1 : min(i, size(this.mat, 2))
                    nMat(i+1,j) = this.mat(i,j) / (i-j+2);
                end
            end
            new = layer(nMat);
        end
        
        function addWith(this, added)
            s1 = size(this.mat);
            s2 = size(added.mat);
            if s1(1) == 0
                this.mat = added.mat;
                return;
            elseif s2(1) == 0
                return;
            elseif s1(1) == s2(1) && s1(2) == s2(2)
            elseif s1(1) >= s2(1) && s1(2) >= s2(2)
                added.mat(s1(1), s1(2)) = 0;
            elseif s1(1) <= s2(1) && s1(2) <= s2(2)
                this.mat(s2(1), s2(2)) = 0;
            else
                added.mat(s1(1), s1(2)) = 0;
                this.mat(s2(1), s2(2)) = 0;
            end
            this.mat = this.mat + added.mat;
        end
        
        function new = multiple(a,b)
            aMat = a.mat;
            bMat = b.mat;
            sa = size(aMat);
            sb = size(bMat);
            if sa(1) == 0 || sb(1) == 0
                new = layer([]);
                return
            end
            newMat = zeros(sa(1)+sb(1), sa(2)+sb(2)-1);
            bMat(sa(1)+sb(1), sa(2)+sb(2)-1) = 0;
            for i = 1:sa(1)
                for j = 1:sa(2)
                    if aMat(i, j) ~= 0
                        newMat = newMat + circshift(bMat, [i j-1]) * aMat(i, j);
                    end
                end
            end
            new = layer(newMat);
        end
        
        function new = shift(this, d)
            s = size(this.mat, 1);
            if s == 0
                new = layer([]);
                return;
            end
            x = cell(1);
            for i = 1 : s
                x{i} = conv(this.mat(i,:), pascalTrig(i, d));
            end
            new = layer(zeros(s, size(x{s}, 2)));
            for i = 1 : s
                new.mat(i, 1:size(x{i}, 2)) = x{i};
            end
        end
    end
    
end

