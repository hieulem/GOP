function cexistenceframes=Getcontinuousframes(existenceframes)
%This function only returns existing frames
%TODO: test commented option on more complex sequence for speed

prevValue=existenceframes(1)-1;
currValue=1;
tmpexistenceframes=zeros(size(existenceframes));
for i=1:numel(existenceframes)
%     currValue=currValue+existenceframes(i)-prevValue-1;
    if ((existenceframes(i)-prevValue)~=1)
        currValue=currValue+1;
    end
    prevValue=existenceframes(i);
    tmpexistenceframes(i)=currValue;
end

mm=mode(tmpexistenceframes);
cexistenceframes=existenceframes(tmpexistenceframes==mm);




