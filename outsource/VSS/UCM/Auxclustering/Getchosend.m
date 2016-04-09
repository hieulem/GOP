function [chosend,maxdim,maxdimd]=Getchosend(Y,dims)
%chosend=Getchosend(Y,3);
%The function returns chosend=[] in case of not defined manifold dimension
%maxdim is maximum dimension of the manifold and maxdimd is the
%corresponding index in Y.coords{index}



maxdim=-1;
maxdimd=0;
for i=1:numel(Y.coords)
    if ( size(Y.coords{i},1) > maxdim )
        maxdim=size(Y.coords{i},1);
        maxdimd=i;
    end
end



chosend=[];
for i=1:numel(Y.coords)
    if (size(Y.coords{i},1)==dims)
        chosend=i;
        return;
    end
end
