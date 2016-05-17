function allcodes=Bmdetectallclusternumbers(theDir)

iids = dir(fullfile(theDir,'C*.txt'));
allcodes=cell(0);
for i=1:numel(iids)
    
    theclustercode=Findtheclustercode(iids(i).name);
    
    [allcodes]=Findandaddclustercode(allcodes,theclustercode); %,thepos
end
