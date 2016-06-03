 classdef Adder < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        rel ; % relationship to other component
        taylor1 ;
        taylor2 ; % use for derivative
        len ; % taylor3(:,1) store log(|coe|), while taylor3(:,2) store sign(coe)
    end

    methods
        % init is the initial value of comp unit
        function newComp = Adder( init )
            if nargin == 0
                return;
            end
            newComp.rel = [];
            newComp.taylor1 = init;
            newComp.len = 1;
        end
        
        function this = add(this, v)
            this.taylor1(end+1) = v;
            this.len = size(this.taylor1, 2);
        end
        
        function [this] = updateDerv(this)
            if size(this.taylor1, 2) > size(this.taylor2, 2)
                this.taylor2 = this.taylor1 .* factorial(0:this.len-1);
            end
        end
        
        % call comp.addR( coefficient , order , list of comps multiplied ] );
        % add a relationship term
        function [this] = addR(this , coefficient , order , comps )
            if coefficient ~= 0
                newAdd.coeVal = coefficient ;
                newAdd.order = order ;
                newAdd.comps = comps ;
                this.rel = [this.rel newAdd];
            end
        end
        
        % compute all relatioins for this term and sum them up
        function [this] = compute(this)
            v = 0;
            for k = this.rel
                v = v + this.computeItem(k);
            end
            this.add(v);
        end
        
        % compute the result of one relation
        function v = computeItem( this ,  k )
            o = this.len - k.order;
            if o < 1
                v = 0;
                return;
            end
            v = k.comps.taylor1(o) * k.coeVal;
        end
        
        function v = calc(this, t, order)
            if order == 0
                if t == 0
                    v =  this.taylor1(1, 1);
                    return;
                end
                x = (t.^(0:this.len-1)) .* this.taylor1;
                v = sum(x);
            else
                this.updateDerv();
                if t == 0
                    v = this.taylor2(1+order);
                    return;
                end
                x = this.taylor2(1+order:end);
                x = x .* (t.^(0:this.len-order-1)) ./ factorial(0:this.len-order-1);
                v = sum(x);
            end
        end
       
        
    end       
end
