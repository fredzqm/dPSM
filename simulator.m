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
        function compute(this , numSeg)
            this.f = this.problem.createCompUnit(this);
            this.f(end).compute();
            status = 0;
            fprintf('Start computing\n');
            for x = 1 : numSeg
                unit = this.f(end).createCompUnit(this);
                unit.compute();
                this.f(end+1) = unit;
                if x/numSeg - status > 0.01
                    status = x/numSeg;
                    fprintf('Computing ... %2d %%\n', uint8(status*100));
                end
            end
            fprintf('Finish computing\n');
        end
        
        function [comp, isInitComp] = lastComp(this, numBack)
            if size(this.f, 2) > numBack + 1
                comp = this.f(end - numBack);
                isInitComp = 0;
            else
                comp = this.problem;
                isInitComp = 0;
            end
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
            if tt(1) <= this.f(1).t
                if tt(end) < this.f(1).t
                    vv = this.problem.calc(tt, order);
                    return;
                end
                while tt(i) < this.f(1).t
                    i = i + 1;
                end
                vv(1:i-1) = this.f(1).calc(tt(1:i-1), order);
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
                    j = j + 1;s
                end
                vv(i:j-1) = this.f(index).calc(tt(i:j-1), order);
                index = index + 1;
                i = j ;
            end
        end
        
        
        % plot the function and make comparasion
        function plot(this , tt , compare)
            tts = min(tt): (max(tt)-min(tt))/70 : max(tt);
            plot( tt , this.calc(tt, 0) , '-'  , tts , compare(tts) , '.');             
        end
        
        % plot the comparative error
        function plotError(this , tt , compare)
            err(tt, this.calc(tt, 0) , compare);
        end
               
        % plot the derivative
        function plotDeriv(this , tt , order)
            hold on
            plot( tt , this.calc(tt, order) , 'y');  
        end

    end
    
end

