 classdef Delayer < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        taylor ; % taylor series, log(|coe|), coe*k^n/n!,
    end
    
    methods
        % init is the initial value of comp unit
        function newComp = Delayer( poly )
            if nargin == 0
                return;
            end
            newComp.taylor = poly;
        end
           
        function vv = taylor1(this, ii)
            while size(this.taylor, 2) < ii(end)
                this.taylor = [this.taylor zeros(1, size(this.taylor, 2))];
            end
            vv = this.taylor(ii);
        end
    end       
end
