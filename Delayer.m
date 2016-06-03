 classdef Delayer < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        rel ; % relationship to other component
        taylor1 ; % taylor series, log(|coe|), coe*k^n/n!,
        len ; % taylor3(:,1) store log(|coe|), while taylor3(:,2) store sign(coe)
    end
    
    methods
        % init is the initial value of comp unit
        function newComp = Delayer( poly )
            if nargin == 0
                return;
            end
            newComp.taylor1 = poly;
        end
           
        
    end       
end
