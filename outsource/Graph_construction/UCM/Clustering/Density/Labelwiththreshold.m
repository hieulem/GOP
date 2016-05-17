function [class,numberofclusters]=Labelwiththreshold(order,RD,th,npoints,printonscreen)
% npoints=size(x,1);

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('npoints','var')) || (isempty(npoints)) )
    npoints=numel(RD);
end



amargin=0.000001;
margth=(th-amargin);

class=ones(1,npoints).*(-2);
count=0;
toincrease=true;
for i=1:npoints
    iinorder=order(i);
    if (RD(iinorder)>margth)
        class(iinorder)=-1;
        toincrease=true;
        continue;
    end
    if (toincrease)
        count=count+1;
        toincrease=false;
    end
    class(iinorder)=count;
end

if (any(class==(-2)))
    fprintf('\nUnassigned points\n\n');
end

numberofclusters=numel(unique(class))-any(class==(-1));



if (printonscreen)
    fprintf('Labelwiththreshold: number of clusters %d (outlier present %d)\n',numberofclusters,any(class==(-1)));
    % sum(RD>margth)
end