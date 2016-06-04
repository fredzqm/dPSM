classdef simulator < handle
    
    properties (SetAccess = public)
        f ;
        
        % represent the computational units in this simulator
        adderRel; % calculate adder relationship
        multRel; % calculate multipler relationship
        delayRel; % calculate delay relationship
        
        % initial values
        initTime
        initValue  % A cell array of initValues (Can be polynomials)
        
        
        % configuration for computing
        delay
        resetTime = 0.05; % resetTime*delaySeg is one delay time.
        minOrder = 5    ; % default minOrder
    end

    methods
        % take three terms -- funct (the function of comps)
        %                  -- initTime (the time to start compute)
        %                  -- relation (the relation of comps)
        function created = simulator(initValue , initTime, delay , relation, config)
            if ~isa(initValue, 'cell')
                error('initial values of elements should be given in the cell array');
            end
            created.initValue = initValue;
            created.delay = delay;
            created.initTime = initTime;
            if nargin >= 5
                created.resetTime = config.resetTime;
                created.minOrder = config.order;
            end
            [created.adderRel, created.multRel, created.delayRel] = rephraseRel(relation);
            created.f = compUnit(created, initTime);
        end
              
        function v = t(this, index)
            v = this.f(index).t;
        end
           
        % compute a certain time given the resetTime and minorder 
        function compute(this , time)
            this.f(end).repeatCompute(this.minOrder);
            u = ceil( time / this.resetTime );
            status = 0;
            fprintf('Start computing\n');
            startTime = this.f(end).t;
            for x = 1 : u
                unit = compUnit(this, startTime + x * this.resetTime);
                this.f(end+1) = unit;
                unit.repeatCompute(this.minOrder);
                if x/u - status > 0.01
                    status = x/u;
                    fprintf('Computing ... %2d %%\n', uint8(status*100));
                end
            end
            fprintf('Finish computing\n');
        end
                
        % note that tt should be a time array in ascending order
        function vv = calc(this, element, tt, order)
            vv = tt ;
            if size(this.f, 2) == 0
                vv(:) = this.initValue{element};
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
            high = size(this.f, 2);
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

