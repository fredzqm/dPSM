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
            newComp.rel = [];
            newComp.taylor1 = init;
%             newComp.taylor3(1,2) = sign(init);
%             if sign(init) ~= 0
%                 newComp.taylor3(1,1) = log(abs(init));
%             end
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
%                 if coefficient < 0
%                     newAdd.coeNeg = 1;
%                 else
%                     newAdd.coeNeg = 0;
%                 end
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
%             if size(this.rel, 2) ~= 1
%                 next = zeros( size(this.rel, 2), 2);
%                 for i = 1 : size(this.rel, 2)
%                     [v, s] = this.computeItem( this.rel(i) );
%                     next(i, 1) = v;
%                     next(i, 2) = s;
%                 end
%                 ave = max(next(:,1));
%                 next(:,1) = next(:,1) - ave;
%                 next(:,1) = exp(next(:,1)) .* next(:,2);
%                 value = sum(next(:,1));
%                 this.add(log(abs(value)) + ave , sign(value) );
%             else
%                 [v, s] = this.computeItem( this.rel(1) );
%                 this.add( v , s );
%             end
        end
        
        % compute the result of one relation
        function v = computeItem( this ,  k )
            o = this.len - k.order;
            if o < 1
                v = 0;
                return;
            end
            v = k.comps.taylor1(o) * k.coeVal;
%             v = k.comps.taylor3(o , 1);
%             s = k.comps.taylor3(o , 2);
%             v = v + k.coeVal;
%             if k.coeNeg
%                 s = -s;
%             end
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
