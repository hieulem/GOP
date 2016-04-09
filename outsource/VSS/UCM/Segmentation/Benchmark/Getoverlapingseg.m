function overlapseg=Getoverlapingseg(confcountssized,maxgtlabelsngt)
%Compute the best overlapping area between the gt and machine segment for each machine segment, repeated
%over the available gts
%overlapseg= [nsegs x ngts]

ngts=numel(maxgtlabelsngt);

overlapseg= zeros( size(confcountssized,1) , ngts);

if (size(confcountssized,1)<1)
    return;
end

cnt=0;
for i=1:ngts
    if (maxgtlabelsngt(i)>0)
        overlapseg(:,i)= max ( confcountssized(:,cnt+1:cnt+maxgtlabelsngt(i)) , [] , 2);
    end
    cnt=cnt+maxgtlabelsngt(i);
end
