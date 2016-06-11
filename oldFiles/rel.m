classdef rel
    properties (SetAccess = public)
        addTo;
        coefficient;
        order;
        comps;
        delaycomps;
    end
    
    methods
        function newAdd =  rel(addTo, coefficient , order, comps, delaycomps)
            newAdd.addTo = addTo ;
            newAdd.coefficient = coefficient ;
            newAdd.order = order ;
            newAdd.comps = sort(comps);
            newAdd.delaycomps = [];
            if nargin == 5
                newAdd.delaycomps = sort(delaycomps);
            end
        end
                
        function r = normalize(r)
            if size(r.comps, 1) == 3
                return;
            end
            if size(r.comps, 1) == 2
                r.comps = [r.comps ; 0];
                return;
            end
            oldComps = sort(r.comps);
            newComps = [oldComps(1) ; 0; 0];
            for e = oldComps
                if newComps(1, size(newComps, 2)) == e
                    newComps(2, size(newComps, 2)) = newComps(2, size(newComps, 2)) + 1;
                else
                    newComps(1, size(newComps, 2) + 1) = e;
                    newComps(2, size(newComps, 2)) = 1;
                end
            end
            r.comps = newComps;
        end
    end
    
end