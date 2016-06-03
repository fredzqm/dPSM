classdef simulator < handle
    
    properties (SetAccess = public)
        f ;
        computeTill; % the last segment
        
        % represent the computational units in this simulator
        adderRel; % calculate adder relationship
        multRel; % calculate multipler relationship
        delayRel; % calculate delay relationship
        
        % initial values
        initTime
        initValue  % ideal function of each term
        
        
        % configuration for computing
        delay
        delaySeg
        resetTime = 0.05; % resetTime*delaySeg is one delay time.
        minOrder = 5    ; % default minOrder
    end

    methods
        % take three terms -- funct (the function of comps)
        %                  -- initTime (the time to start compute)
        %                  -- relation (the relation of comps)
        function created = simulator(initValue , initTime, delay , relation)
            if ~isa(initValue, 'double')
                error('initial values of elements should be given in the array');
            end
            created.initValue = initValue;
            created.delay = delay;
            created.initTime = initTime;
            [created.adderRel, created.multRel, created.delayRel] = rephraseRel(relation);
            created.computeTill = initTime;
            created.f = compUnit(created, initTime);
%             repeatCompute(created.f, );
        end
        
        function setAccuracyParameters(this, resetTime, minOrder)
            this.minOrder = minOrder;
            this.delaySeg = ceil( this.delay / resetTime );
            this.resetTime = this.delay / this.delaySeg;
        end
        
        function v = t(this, index)
            v = this.f(index).t;
        end
           
        % compute a certain time given the resetTime and minorder 
        function compute(this , time)
            [index, upper] = this.findIndex(this.computeTill);
            if upper ~= inf
                % those compUnits might not be accurate enough
                this.f(index+1:end) = []; 
            end
            this.f(size(this.f, 1)).repeatCompute(this.minOrder);
            u = ceil( time / this.resetTime );
            status = 0;
            fprintf('Start computing\n');
            for x = 1 : u
                unit = compUnit(this, this.computeTill + x * this.resetTime);
                this.f = [this.f ; unit];
                unit.repeatCompute(this.minOrder);
                if x/u - status > 0.01
                    status = x/u;
                    fprintf('Computing ... %2d %%\n', uint8(status*100));
                end
            end
            fprintf('Finish computing\n');
            this.computeTill = this.computeTill + u * this.resetTime;
        end
                
        % note that tt should be a time array in ascending order
        function vv = calc(this, element, tt, order)
            vv = tt ;
            if size(this.f, 2) == 0
                vv(:) = this.initValue(element);
                return;
            end
            [segn, upper] = this.findIndex(tt(1));
            for i = 1 : size(tt , 2)
                if tt(i) > upper
                    [segn, upper] = this.findIndex(tt(i), segn);
                end
                vv(i) = this.f(segn).adder(element).calc( tt(i) - this.t(segn), order);
                continue;
            end
        end
        
        function [index, upper] = findIndex(this, t, pre)
            high = size(this.f, 1);
            if nargin > 3 && pre + 2 <= high
                if this.t(pre+1) < t && this.t(pre+2) > t
                    index = pre + 1;
                    upper = this.t(pre+2);
                    return;
                end
            end
            if high == 1
                index = 1;
                upper = inf;
                return;
            end
            if t >= this.t(high)
                index = high;
                upper = inf;
                return;
            end
            if t < this.t(2)
                index = 1;
                upper = this.t(2);
                return;
            end
            low = 1;
            while(1)
                k = (high - low) / (this.t(high) - this.t(low));
                index = floor((t - this.t(low)) * k) + low;
                if index <= low || index >= high
                    while(t > this.t(index+1))
                        index = index + 1;
                    end
                    while(t < this.t(index))
                        index = index - 1;
                    end
                    upper = this.t(index + 1);
                    return;
                end
                if this.t(index) <= t
                    if this.t(index + 1) > t
                        upper = this.t(index + 1);
                        return;
                    end
                    low = index;
                else
                    if this.t(index - 1) <= t
                        index = index - 1;
                        upper = this.t(index);
                        return;
                    end
                    high = index - 1;
                end
            end
        end
        
        % plot the function and make comparasion
        function plot(this , tt , compare)
            tts = min(tt): (max(tt)-min(tt))/70 : max(tt);
            plot( tt , this.calc(1, tt, 0) , '-'  , tts , compare(tts) , '.');             
        end
        
        % plot the comparative error
        function plotError(this , tt , compare)
            err(tt, this.calc(1, tt, 0) , compare);
        end
               
        % plot the derivative
        function plotDeriv(this , tt , order)
            hold on
            plot( tt , this.calc(1, tt, order) , 'y');  
        end

    end
    
end


% repeat compute all comps order times.
% function repeatCompute(unit, order)
%     for k = 1 : order
%         for i = unit.multer
%             i.compute();
%         end
%         for i = unit.adder
%             i.compute();
%         end
%     end
%     
% end
