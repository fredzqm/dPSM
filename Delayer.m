 classdef Delayer < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        rel ; % relationship to other component
        taylor3 ; % taylor series, log(|coe|), coe*k^n/n!,
        taylor2 ; % use for derivative
        len ; % taylor3(:,1) store log(|coe|), while taylor3(:,2) store sign(coe)
    end
    
    methods
        % init is the initial value of comp unit
        function newComp = Delayer( poly )
            newComp.taylor3 = [log(abs(poly)) sign(poly)];
%             newComp.rel = [];
%             newComp.taylor3(1,2) = sign(init);
%             if sign(init) ~= 0
%                 newComp.taylor3(1,1) = log(abs(init));
%             end
%             newComp.len = 1;
        end
           
        
    end       
end
