function [inx,iny]=Gettheinnestpoint(mask)

SE = strel('diamond',1);
% SE = strel('square',3); %alternative method

first=1;
while (sum(sum(mask))>0)
    previousMask=mask;
    mask=imerode(mask,SE);
    if (first)
        mask(1,:)=0;
        mask(end,:)=0;
        mask(:,1)=0;
        mask(:,end)=0;
        first=0;
    end
end

[mask,no] = bwlabel(previousMask,8);

sizes=zeros(1,no);
for i=1:no
    sizes(i)=sum(sum(mask==i));
end
[c,r]=max(sizes);
mask=(mask==r);
% r=find(sizes==max(sizes));
% mask=(mask==r(1));

[y,x]=find(mask);
centroid=[mean(x),mean(y)];

inx=centroid(1);
iny=centroid(2);
