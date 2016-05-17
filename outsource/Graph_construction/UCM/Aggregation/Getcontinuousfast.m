function cexistenceframes=Getcontinuousfast(existenceframeslogical)
%This function only returns existing frames

tmpexistenceframes=zeros(size(existenceframeslogical));
prevaddvalue=0;
prevexistingvalue=false;
for i=1:numel(existenceframeslogical)
    tmpexistenceframes(i)=prevaddvalue+(~(existenceframeslogical(i)&&prevexistingvalue));
    prevaddvalue=tmpexistenceframes(i);
    prevexistingvalue=existenceframeslogical(i);
end

mm=mode(tmpexistenceframes(existenceframeslogical));
cexistenceframes=find(tmpexistenceframes==mm);


function cexistenceframes=Getcontinuousfastbackup_withbwconncomp(existenceframeslogical)
%This function only returns existing frames

cc = bwconncomp(existenceframeslogical);

areas=zeros(1,cc.NumObjects);
for i=1:cc.NumObjects
    areas(i)=numel(cc.PixelIdxList{i});
end

[val,idx]=max(areas);

cexistenceframes=cc.PixelIdxList{idx};


