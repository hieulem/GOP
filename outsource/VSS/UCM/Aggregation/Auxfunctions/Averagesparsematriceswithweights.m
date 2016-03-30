function [cc,wcmatrix]=Averagesparsematriceswithweights(aa,bb,wamatrix,wbmatrix,domultiply)
%Is it correct to include exclusive points without weighting?
%The function is symmetric in the two input
%The weight matrices do not need be normalized, and the wcmatrix is not
%normalized either (it is just a sum of wamatrix and wbmatrix)

if ( (~exist('domultiply','var')) || (isempty(domultiply)) )
    domultiply=false;
end

%Sum the two matrices
%This sum gives the exclusive values
cc=aa+bb;

%To divide by 2
commonelements=find(aa&bb);

if (domultiply)
    
    cc(commonelements)=aa(commonelements).*bb(commonelements)./...
        ( aa(commonelements).*bb(commonelements) + (1-aa(commonelements)).*(1-bb(commonelements)) );

else
    
%     aelem=find(aa);
%     belem=find(bb);

    if ( (~exist('wamatrix','var')) || (isempty(wamatrix)) )
        wamatrix=0.5;
    end
    if ( (~exist('wbmatrix','var')) || (isempty(wbmatrix)) )
        wbmatrix=0.5;
        
    end
    if (numel(wamatrix)==1) %if wamatrix is just a scalar
        tmp=wamatrix;
        wamatrix=aa;
        wamatrix(aa~=0)=tmp;
%         wamatrix(aelem)=tmp;
    end
    if (numel(wbmatrix)==1) %if wbmatrix is just a scalar
        tmp=wbmatrix;
        wbmatrix=bb;
        wbmatrix(bb~=0)=tmp;
%         wbmatrix(belem)=tmp;
    end

    wcmatrix=wamatrix+wbmatrix;
    
    cc(commonelements)= ( aa(commonelements).*wamatrix(commonelements)+bb(commonelements).*wbmatrix(commonelements) ) ...
        ./ wcmatrix(commonelements);
    
end

if ( (~exist('wcmatrix','var')) || (isempty(wcmatrix)) )
    wcmatrix=1;
end

%To include as sums
% xor(aa,bb)

%Checks
% numel(find(aa))
% numel(find(bb))
% numel(find(aa&bb))
% numel(find(xor(aa,bb)))
% numel(find(cc))
% numel(find(xor(aa,bb)))+numel(find(aa&bb))



function cc=Averagesparsematrices_no_weighting(aa,bb) %#ok<DEFNU>

cc=aa+bb;

%To divide by 2
divelements=find(aa&bb);

cc(divelements)=cc(divelements)/2;

function Testthisfunction()

aa=sparse([0.1,0;0.2,0]);
bb=sparse([0.3,0.4;0,0]);

wamatrix=1;
wbmatrix=3;

domultiply=false;
[cc,wcmatrix]=Averagesparsematriceswithweights(aa,bb,wamatrix,wbmatrix,domultiply);

bb=sparse(2,2);
wbmatrix=0;
[cc,wcmatrix]=Averagesparsematriceswithweights(aa,bb,wamatrix,wbmatrix,domultiply);

[cc,wcmatrix]=Averagesparsematriceswithweights(cc,aa,wcmatrix,wamatrix,domultiply);
[cc,wcmatrix]=Averagesparsematriceswithweights(cc,bb,wcmatrix,wbmatrix,domultiply);


