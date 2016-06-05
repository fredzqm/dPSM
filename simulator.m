classdef simulator < handle
    
    properties (SetAccess = public)
        f ;
        
        % represent the computational units in this simulator
        problem;
        
        % initial values
%         initTime
%         initValue  % A cell array of initValues (Can be polynomials)
%         delay
        
        % configuration for computing
        resetTime = 0.05; % resetTime*delaySeg is one delay time.
        minOrder = 5    ; % default minOrder
    end

    methods
        % take three terms -- funct (the function of comps)
        %                  -- initTime (the time to start compute)
        %                  -- relation (the relation of comps)
        function created = simulator(problem, config)
            created.resetTime = config.resetTime;
            created.minOrder = config.order;
            created.problem = problem;
            created.f = created.problem.createFirstCompUnit(created);
        end
              
          
        % compute a certain time given the resetTime and minorder 
        function compute(this , time)
            this.f(end).repeatCompute(this.minOrder);
            u = ceil( time / this.resetTime );
            status = 0;
            fprintf('Start computing\n');
            startTime = this.f(end).t;
            for x = 1 : u
                unit = this.problem.createCompUnit(this, startTime + x * this.resetTime);
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
        function vv = calc(this, tt, order)
            vv = zeros(size(tt));
            i = 1;
            len = size(tt, 2);
            while i <= len
                [compUnit until] = this.findComp(tt(i:end));
                j = i + until - 1;
                vv(i:j) = compUnit.calc(tt(i:j), order);
                i = j + 1;
            end
        end
        
        function [compUnit, until] = findComp(this, t)
            if size(t, 2) == 0
                error('Should not send in a empty t');
            end
            i = floor((t(1) - this.f(1).t ) / this.resetTime) + 1;
            if i >= size(this.f, 2)
                i = size(this.f, 2);
                compUnit = this.f(i);
                until = 1;
            else
                compUnit = this.f(i);
                if nargout >= 2
                    if size(t, 2) == 1
                        until = 1;
                    else
                        untilTime = compUnit.t + this.resetTime;
                        i = floor((untilTime - t(1)) / (t(2)-t(1))) + 1;
                        if i >= size(t, 2)
                            until = size(t, 2);
                        else
                            while t(i) > untilTime
                                i = i - 1;
                            end
                            while t(i + 1) < untilTime
                                i = i + 1;
                            end
                            until = i;
                        end
                    end
                end
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

