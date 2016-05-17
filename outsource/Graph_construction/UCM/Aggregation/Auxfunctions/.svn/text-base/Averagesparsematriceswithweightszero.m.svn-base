function [cc,wcmatrix]=Averagesparsematriceswithweightszero(aa,bb,wamatrix,wbmatrix,domultiply)
%Is it correct to include exclusive points without weighting?
%The function is symmetric in the two input
%The weight matrices do not need be normalized, and the wcmatrix is not
%normalized either (it is just a sum of wamatrix and wbmatrix)



if (isempty(find(bb,1)))
    cc=aa;
    wcmatrix=wamatrix;
    return;
end
if (isempty(find(aa,1)))
    cc=bb;
    wcmatrix=wbmatrix;
    return;
end



if ( (~exist('domultiply','var')) || (isempty(domultiply)) )
    domultiply=false;
end

cc= aa+bb; %This is only used for initialization
allelements=find(cc); %find(aa|bb)

if (domultiply)
    
    cc(allelements)=aa(allelements).*bb(allelements)./...
        ( aa(allelements).*bb(allelements) + (1-aa(allelements)).*(1-bb(allelements)) );

else
    
    if ( (~exist('wamatrix','var')) || (isempty(wamatrix)) )
        wamatrix=1;
    end
    if ( (~exist('wbmatrix','var')) || (isempty(wbmatrix)) )
        wbmatrix=1;
    end
    if (numel(wamatrix)==1) %if wamatrix is just a scalar
        tmp=wamatrix;
        wamatrix=aa;
        wamatrix(aa~=0)=tmp;
    end
    if (numel(wbmatrix)==1) %if wbmatrix is just a scalar
        tmp=wbmatrix;
        wbmatrix=bb;
        wbmatrix(bb~=0)=tmp;
    end
    
    wamatrix( bb & xor(aa~=0,bb~=0) )=1; %disp(full(wamatrix));
    wbmatrix( aa & xor(aa~=0,bb~=0) )=1; %disp(full(wbmatrix));
%     wamatrix( bb & (~aa) )=1; %disp(full(wamatrix));
%     wbmatrix( aa & (~bb) )=1; %disp(full(wbmatrix));
    
    wcmatrix=wamatrix+wbmatrix; %disp(full(wcmatrix)); disp(wcmatrix);
    
    cc(allelements)= ( aa(allelements).*wamatrix(allelements)+bb(allelements).*wbmatrix(allelements) ) ...
        ./ wcmatrix(allelements);
    
end

if ( (~exist('wcmatrix','var')) || (isempty(wcmatrix)) )
    wcmatrix=1;
end


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
bb=sparse(2,2);
disp(full(aa));
disp(full(bb));

wamatrix=1;
wbmatrix=3;

domultiply=false;
[ccz,wcmatrix]=Averagesparsematriceswithweightszero(aa,bb,wamatrix,wbmatrix,domultiply);
[cc,wcmatrix]=Averagesparsematriceswithweights(aa,bb,wamatrix,wbmatrix,domultiply);
disp(full(cc));
disp(full(ccz));


aa=sparse([0.1,0;0.2,0]);
bb=sparse([0.3,0.4;0,0]);
disp(full(aa));
disp(full(bb));

wamatrix=1;
wbmatrix=3;

domultiply=false;
[ccz,wcmatrix]=Averagesparsematriceswithweightszero(aa,bb,wamatrix,wbmatrix,domultiply);
[cc,wcmatrix]=Averagesparsematriceswithweights(aa,bb,wamatrix,wbmatrix,domultiply);
disp(full(cc));
disp(full(ccz));


