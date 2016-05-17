function nearMask=Get_region_area_near_point_mask(mask,pointxy,radius,printonscreen,M,printM)

if ( (~exist('radius','var')) || (isempty(radius)) ) %defining the Gaussian for spatial neighbouring
    radius=10;
end

dimIi=size(mask,1);
dimIj=size(mask,2);

if ( (~exist('M','var')) || (isempty(M)) ) %so as not to have to produce the same gaussian always
    [XM,YM]=meshgrid(-radius:radius,-radius:radius);
    M=( (XM.^2+YM.^2) <= (radius^2) );
end

nearMask=false(dimIi,dimIj);

firstMi=max(pointxy(2)-radius,1);
firstGi=firstMi-pointxy(2)+radius+1;
endMi=min(pointxy(2)+radius,dimIi);
endGi=radius+1+endMi-pointxy(2);
firstMj=max(pointxy(1)-radius,1);
firstGj=firstMj-pointxy(1)+radius+1;
endMj=min(pointxy(1)+radius,dimIj);
endGj=radius+1+endMj-pointxy(1);

nearMask(firstMi:endMi,firstMj:endMj)=( M(firstGi:endGi,firstGj:endGj) & mask(firstMi:endMi,firstMj:endMj) );

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) || (printonscreen) ) %The function displays images by default
    
    figure(23)
    set(gcf, 'color', 'white');
    imagesc(mask);
    title ('Mask of selected area');
    hold on;
    plot(pointxy(1),pointxy(2),'w+');
    hold off;
    
    figure(27)
    set(gcf, 'color', 'white');
    imagesc(nearMask);
    title ('Mask of predicted area');
    
    if ( (exist('printM','var')) && (~isempty(printM)) && (printM) ) %The function does not display M by default
        figure(21),imagesc(M)
        set(gcf, 'color', 'white');
    end
end





