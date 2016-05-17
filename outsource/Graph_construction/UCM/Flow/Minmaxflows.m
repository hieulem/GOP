function [minflow, maxflow]=Minmaxflows(flows, printonscreen)
%Computation of min and maxflow

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

noFrames=numel(flows.flows);
minflow=Inf;
maxflow=-Inf;
for f=1:noFrames
    [velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});
    if (f>1)
        magnitude=sqrt(velUm.^2+velVm.^2);
        minflow=min( min(magnitude(:)) , minflow );
        maxflow=max( max(magnitude(:)) , maxflow );
    end
    if (f<noFrames)
        magnitude=sqrt(velUp.^2+velVp.^2);
        minflow=min( min(magnitude(:)) , minflow );
        maxflow=max( max(magnitude(:)) , maxflow );
    end
end
if (printonscreen)
    fprintf('Minflow %.10f, maxflow %0.10f\n', minflow, maxflow);
end
