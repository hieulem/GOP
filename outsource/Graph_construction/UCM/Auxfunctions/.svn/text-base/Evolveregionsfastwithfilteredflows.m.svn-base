function predictedMask=Evolveregionsfastwithfilteredflows(mask,flowatframe,printonscreen)
%mask=themask;
%flowatframe=flows.flows{frame};

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










function Test_part() %#ok<DEFNU>



    Init_figure_no(1), imagesc(avgxs);
    Init_figure_no(11), imagesc(avgxs);
    Init_figure_no(2), imagesc(xminus);
    Init_figure_no(3), imagesc(xplus);
    Init_figure_no(5), imagesc(avgys);
    Init_figure_no(55), imagesc(avgys);
    
    [X,Y]=meshgrid(1:size(mask,2),1:size(mask,1));
    Init_figure_no(20), imagesc(avgxs-X(mask));
    Init_figure_no(21), imagesc(avgxs-X(mask));
    
    Init_figure_no(30), imagesc(flowatframe.Up-X);
    Init_figure_no(31), imagesc(flowatframe.Vp-Y);
    



%for debugging
m=logical([ 0   0   0   0   0   0   0   0
            0   0   1   1   1   0   0   0
            0   0   0   1   0   0   0   0
            0   0   0   1   0   0   0   0
            0   0   0   0   0   0   0   0
]);
mm=logical([0   0   0   0   0   0   0   0
            0   0   0   1   1   1   1   0
            0   0   0   0   1   0   0   0
            0   0   0   0   1   0   0   0
            0   0   0   0   1   0   0   0
]);
mask=m;
flowatframe=flows.flows{1};
printonscreen=true;
predictedMask=Evolveregionsfastwithfilteredflows(mask,flowatframe,printonscreen);
predictedMask=EvolveRegionFast(mask,flowatframe,[],[],[],printonscreen);
similarity=Measuresimilarity(mm,predictedMask)
velUp=repmat(1.5,size(mask));
velVp=repmat(0,size(mask));
velUm=velUp;



%U horizontal speed, same as X coord

mask=m;
[X,Y]=meshgrid(1:size(mask,2),1:size(mask,1));
velUp=repmat(1.5,size(mask));
velVp=repmat(0,size(mask));
velUm=(-velUp); velVm=(-velVp);
flowatframe.Up=velUp+X;
flowatframe.Vp=velVp+Y;
flowatframe.Um=velUm+X;
flowatframe.Vm=velVm+Y;
predictedMask=Evolveregionsfastwithfilteredflows(mask,flowatframe,printonscreen);
predictedMask2=EvolveRegionFast(mask,flowatframe,[],[],[],printonscreen);

Init_figure_no(4), imagesc(predictedMask2);
Init_figure_no(3), imagesc(predictedMask);
Init_figure_no(2), imagesc(mask);

sum(mask(:)), sum(predictedMask(:))
