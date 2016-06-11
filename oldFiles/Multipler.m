classdef Multipler < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        a ;
        b ; % two computational unit to be multiplie
        taylor1;
        len ; % taylor3(:,1) store log(|coe|), while taylor3(:,2) store sign(coe)
    end
    
    methods
        % init is the initial value of comp unit
        function newComp = Multipler(a, b)
            if nargin == 0
                return;
            end
            newComp.a = a;
            newComp.b = b;
            newComp.taylor1 = [];
            newComp.len = 0;
        end
  
        function this = add(this, v)
            this.taylor1(end+1) = v;
            this.len = size(this.taylor1, 2);
        end
                
        % compute all relatioins for this term and sum them up
        function [this] = compute(this)
            o = this.len + 1;
            x = this.a.taylor1(1:o);
            y = fliplr( this.b.taylor1(1:o) );
            this.add(sum(x.*y));
        end
        
    end       
end
