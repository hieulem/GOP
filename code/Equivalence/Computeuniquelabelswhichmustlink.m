function uniquelabelswhichmustlink=Computeuniquelabelswhichmustlink(remappedlabels,labelledleveltmp,numberofsuperpixels,maxnewlabelsalreadyassigned)

uniquelabelswhichmustlink=zeros(1,numberofsuperpixels);
for i=1:maxnewlabelsalreadyassigned
    superpixelslabelledi=unique(labelledleveltmp(remappedlabels==i));
    
    uniquelabelswhichmustlink(superpixelslabelledi)=i;
    %sum(sum(sum(remappedlabels==i)))
    %numel(superpixelslabelledi)
end






function Prev_code()

%Compute uniquelabelswhichmustlink
%Assume that segments from twsegmentation do not span multiple superpixels
uniquelabelswhichmustlink=zeros(1,numberofsuperpixels);
for i=1:maxnewlabelsalreadyassigned
    superpixelslabelledi=unique(labelledleveltmp(remappedlabels==i));
    
    uniquelabelswhichmustlink(superpixelslabelledi)=i;
    %sum(sum(sum(remappedlabels==i)))
    %numel(superpixelslabelledi)
end

%This version should be much faster in a c implementation
%Compute uniquelabelswhichmustlink
%Assume that segments from twsegmentation do not span multiple superpixels
uniquelabelswhichmustlink=zeros(1,numberofsuperpixels);
for j=1:numel(remappedlabels)
    
    i=remappedlabels(j);
    if ( (i>=1) && (i<=maxnewlabelsalreadyassigned) )
        uniquelabelswhichmustlink(labelledleveltmp(j))=i;
    end
end
