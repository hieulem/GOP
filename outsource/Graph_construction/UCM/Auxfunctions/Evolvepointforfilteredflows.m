function [px,py]=Evolvepointforfilteredflows(x,y,flowatframe,isforward,printonscreen)
%x and y are the point or the array of points that we want to propagate,
%forward or backward depending on isforward
%mask is the region mask that they belong to, therefore the points must
%belong to the same mask
%The function returns -1 for both the predicted x and y if it could not
%predict their position, in agreement with the initializing value of px and
%py
%inputs <=0 are not considered valid and function returns -1 for px and py


if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=true; %The function displays images by default
end

dimIi=max(size(flowatframe.Up,1),size(flowatframe.Um,1));
dimIj=max(size(flowatframe.Up,2),size(flowatframe.Um,2));

[X,Y]=meshgrid(1:dimIj,1:dimIi);

% [velUm,velVm,velUp,velVp]=GetUandV(flowatframe);
if (isforward)
%     velU=flowatframe.Up-X;
%     velV=flowatframe.Vp-Y;
    velUwithx=flowatframe.Up;
    velVwithy=flowatframe.Vp;
else
%     velU=flowatframe.Um-X;
%     velV=flowatframe.Vm-Y;
    velUwithx=flowatframe.Um;
    velVwithy=flowatframe.Vm;
end
% clear velUm; clear velVm; clear velUp; clear velVp;


if (printonscreen)
    figure(10)
    set(gcf, 'color', 'white');
    imagesc(zeros(dimIi,dimIj));
    hold on
    plot(x,y,'.g');
    hold off
end


%initialization of the predicted positions
px=zeros(size(x));
py=zeros(size(y));

for k=1:numel(x)
    
    if ((x(k)<1)||(y(k)<1)||(x(k)>dimIj)||(y(k)>dimIi)) %it deos not really make sense to propagate a point out of the mask
        px(k)=-1; %in fact if x or y are less than 1 or more than dimI, interpolation of motion is NaN
        py(k)=-1;
%         fprintf('\nFunction has been passed out of image points to propagate\n\n');
        continue;
    end
    
    velUijwithx=interp2(X,Y,velUwithx,x(k),y(k));
    velVijwithy=interp2(X,Y,velVwithy,x(k),y(k));

    if (isnan(velUijwithx)||isnan(velVijwithy))
        px(k)=-1;
        py(k)=-1;
%         fprintf('\nEncountered a point much out of the mask or out of the mask and with dissimilar motion\n\n');
%         sumW
        continue;
    end
    
    px(k)=velUijwithx;
    py(k)=velVijwithy;
end

if (printonscreen)
    figure(10)
    hold on
    plot(px,py,'.r');
    hold off
end
