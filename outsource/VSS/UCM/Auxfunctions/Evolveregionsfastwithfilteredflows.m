function predictedMask=Evolveregionsfastwithfilteredflows(mask,flowatframe,printonscreen)

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=true; %The function displays images by default
end

dimIi=size(mask,1);
dimIj=size(mask,2);

if (printonscreen)
    figure(10)
    set(gcf, 'color', 'white');
    imagesc(mask);
    title ('Mask of selected area');
end


predictedMask=zeros(dimIi,dimIj);


avgxs=flowatframe.Up(mask);
avgys=flowatframe.Vp(mask);
[avgxs,xminus,xplus]=Adjustthematrix(avgxs,1,dimIj);
[avgys,yminus,yplus]=Adjustthematrix(avgys,1,dimIi);


for k=1:numel(avgxs)
    predictedMask(yplus(k),xplus(k))= predictedMask(yplus(k),xplus(k))+...
        (avgxs(k)-xminus(k))*(avgys(k)-yminus(k));
    predictedMask(yminus(k),xminus(k))= predictedMask(yminus(k),xminus(k))+...
        (xplus(k)-avgxs(k))*(yplus(k)-avgys(k));
    predictedMask(yplus(k),xminus(k))= predictedMask(yplus(k),xminus(k))+...
        (xplus(k)-avgxs(k))*(avgys(k)-yminus(k));
    predictedMask(yminus(k),xplus(k))= predictedMask(yminus(k),xplus(k))+...
        (avgxs(k)-xminus(k))*(yplus(k)-avgys(k));
end
%The instructions below are faster but slighlty different
%The instructions above update serially, needed for repeated indexes
% ind=sub2ind([dimIi,dimIj],yplus,xplus);
% predictedMask(ind)= predictedMask(ind)+...
%     (avgxs-xminus).*(avgys-yminus);
% ind=sub2ind([dimIi,dimIj],yminus,xminus);
% predictedMask(ind)= predictedMask(ind)+...
%     (xplus-avgxs).*(yplus-avgys);
% ind=sub2ind([dimIi,dimIj],yplus,xminus);
% predictedMask(ind)= predictedMask(ind)+...
%     (xplus-avgxs).*(avgys-yminus);
% ind=sub2ind([dimIi,dimIj],yminus,xplus);
% predictedMask(ind)= predictedMask(ind)+...
%     (avgxs-xminus).*(yplus-avgys);


if (printonscreen)
    figure(117)
    set(gcf, 'color', 'white');
    imagesc(predictedMask);
    title ('Mask of predicted area');
end



function [matrix,vminus,vplus]=Adjustthematrix(matrix,minlimit,maxlimit)

vminus=zeros(size(matrix));
vplus=zeros(size(matrix));

whichbiggermin=(matrix>=minlimit);
whichsmallermax=(matrix<=maxlimit);

whichboth=whichbiggermin&whichsmallermax;
vminus(whichboth)=floor(matrix(whichboth));
vplus(whichboth)=ceil(matrix(whichboth));

whichonlysmaller=(~whichboth)&whichsmallermax;
whichonlybigger=(~whichboth)&whichbiggermin;

matrix(whichonlysmaller)=minlimit;
vminus(whichonlysmaller)=minlimit;
vplus(whichonlysmaller)=vminus(whichonlysmaller)+1;

matrix(whichonlybigger)=maxlimit;
vplus(whichonlybigger)=maxlimit;
vminus(whichonlybigger)=vplus(whichonlybigger)-1;

whichareequal=(vplus==vplus);
[indareequal]=find(whichareequal);
equalandsmaller=(vplus(indareequal)<maxlimit);
vplus(indareequal(equalandsmaller))=vminus(indareequal(equalandsmaller))+1;
vminus(indareequal(~equalandsmaller))=vplus(indareequal(~equalandsmaller))-1;



