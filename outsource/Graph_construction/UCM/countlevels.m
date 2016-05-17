function region=countlevels(ucm2,frame,level,nofigure)
%In the 3D part, x is towards right, y is towards bottom, as for u and v
%Here ipos is towards bottom and jpos is towards right, as i and j

if nargin<4
    nofigure=10;
end

figure(11), title('Select a point');
[jpos,ipos]=ginput(1);
ipos=round(ipos);
jpos=round(jpos);
labels2 = bwlabel(ucm2{frame} < level);
labels = labels2(2:2:end, 2:2:end);

mask=(labels(ipos,jpos)==labels(:,:));

region.mask=mask;
region.coord=[ipos,jpos];
region.frame=frame;
region.level=level;
region.label=labels(ipos,jpos);

% pos=find(labels(ipos,jpos)==labels(:,:));
% mask=zeros(size(image,1),size(image,2));
% mask(pos)=1;

count=1;
for j=level+1:255 %min(255,level+5) %this way we count all levels
    labels2 = bwlabel(ucm2{frame} < j);
    labels = labels2(2:2:end, 2:2:end);
    
    mask2=(labels(ipos,jpos)==labels(:,:));
    
    if all(all(mask2==mask))
        count=count+1;
    else
        break;
    end
end
for j=level-1:-1: 1 %max(1,level-5) %this way we count all levels
    labels2 = bwlabel(ucm2{frame} < j);
    labels = labels2(2:2:end, 2:2:end);

    mask2=(labels(ipos,jpos)==labels(:,:));

    if all(all(mask2==mask))
        count=count+1;
    else
        break;
    end
end

figure(nofigure)
set(gcf, 'color', 'white');
imagesc(mask);
% set(gca,'xtick',[],'ytick',[]); 
title ('Mask of selected area');

fprintf('Region spans %d levels\n',count);

region.count=count;
