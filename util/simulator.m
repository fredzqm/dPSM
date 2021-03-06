classdef simulator < handle
    
    properties (SetAccess = public)
        % represent the computational units in this simulator
        problem;
        f;
    end
    
    methods
        % take three terms -- funct (the function of comps)
        %                  -- initTime (the time to start compute)
        %                  -- relation (the relation of comps)
        function created = simulator(problem)
            created.problem = problem;
        end
              
          
        % compute a certain time given the resetTime and minorder 
        function compute(this , time)
            this.f = this.problem.createCompUnit(this);
            this.f(end).compute();
            startTime = this.problem.t;
            til = startTime;
            status = 0;
            fprintf('Start computing\n');
            while til < time
                unit = this.f(end).createCompUnit(this);
                unit.compute();
                this.f(end+1) = unit;
                til = unit.t;
                curStatus = (til-startTime)/(time-startTime);
                if curStatus - status > 0.01
                    status = curStatus;
                    diff = unit.checkSegDiff();
                    segLen = unit.getSegLen();
                    fprintf('Computing ... %2d%% error ~= %e in segLen of %e\n', uint8(curStatus*100), diff, segLen);
                end
            end
            fprintf('Computed %d segments in total, up to %d\n', size(this.f, 2), til);
            fprintf('Finish computing\n');
        end
        
        function [comp, isInitComp] = lastComp(this, numBack)
            numBack = int16(numBack - 1);
            if size(this.f, 2) > numBack
                comp = this.f(end - numBack);
                isInitComp = 0;
            else
                comp = this.problem;
                isInitComp = 1;
            end
        end
        
        function l = len(this)
            l = size(this.f, 2);
        end
        
        % note that tt should be a time array in ascending order
        function vv = calc(this, tt, order)
            if size(tt, 2) == 0
                vv = tt;
                return;
            end
            if nargin < 3
                order = 0;
            end
            vv = zeros(size(tt));
            i = 1;
            if size(this.f, 2) == 0
                vv = this.problem.calc(tt, order);
                return;
            elseif tt(1) <= this.f(1).t
                if tt(end) < this.f(1).t
                    vv = this.problem.calc(tt, order);
                    return;
                end
                while tt(i) < this.f(1).t
                    i = i + 1;
                end
                vv(1:i-1) = this.problem.calc(tt(1:i-1), order);
                index = 1;
            elseif tt(1) >= this.f(end).t
                vv = this.f(end).calc(tt, order);
                return;
            else
                low = 1; high = size(this.f, 2) - 1;
                while 1
                    index = floor((low+high)/2);
                    if  tt(1) < this.f(index).t
                        high = index;
                    elseif this.f(index+1).t <= tt(1)
                        low = index + 1;
                    else
                        break; 
                    end
                end
            end
            tLen = size(tt, 2);
            fLen = size(this.f, 2);
            while i <= tLen
                while index < fLen && this.f(index + 1).t <= tt(i) 
                    index = index + 1;
                end
                if index == fLen
                    vv(i:end) = this.f(end).calc(tt(i:end), order);
                    return;
                end
                j = i + 1;
                while j <= tLen && tt(j) < this.f(index + 1).t
                    j = j + 1;
                end
                vv(i:j-1) = this.f(index).calc(tt(i:j-1), order);
                index = index + 1;
                i = j ;
            end
        end
        
        
        % plot the function and make comparasion
        function plot(this , tt , compare, compareVal)
            if nargin == 3
                tts = min(tt): (max(tt)-min(tt))/70 : max(tt);
                plot( tt , this.calc(tt, 0) , '-'  , tts , compare(tts) , '.');
            elseif nargin == 4
                i = find(compare < tt(end));
                plot( tt , this.calc(tt, 0) , '-'  , compare(i) , compareVal(i) , '.');
            elseif nargin == 2
                plot( tt , this.calc(tt, 0) , '-');
            end
        end
        
        % plot the comparative error
        function plotError(this , tt , compare)
            err(tt, this.calc(tt, 0) , compare);
        end
               
        % plot the derivative
        function plotDeriv(this , tt , order)
            plot( tt , this.calc(tt, order) , 'ro');  
        end

    end
    
end

