function [twcmergetuples,maxassignedlabel,previouslabelsbackmap]=Getmergingtuples(SCSolution,maxassignedlabel,previouslabelsbackmap,maxnewlabelsalreadyassigned)
%The merging tuples are computed for the segmentation previously provided
%and output in twcmergingtuples
%As soon as two labels are merged they are assigned a new label, equal to
%maxassignedlabel+1, which is then updated
%previouislabelbackmap reflects these label updates. Values corresponding
%to the labels being merged are changed to the new (max)assignedlabel


%Select the SCSolution part related to already labelled superpixels (already segmented video part)
labelsfcjustlocal=SCSolution(1:maxnewlabelsalreadyassigned);



uniqueclusterlabels=unique(labelsfcjustlocal);



%Output an empty array is no previously created cluster was merged
twcmergetuples=[];



%Return in case no new objects were defined
if (numel(uniqueclusterlabels)==numel(labelsfcjustlocal))
    return;
end



%Change previouslabelsbackmap(1:maxnewlabelsalreadyassigned) to
%reflect the new assigned labels to those merged previously created
%clusters
%
%Update twcmergetuples to keep track of merges
%
%Do not change SCSolution as its values are just placeholders meaning
%clustering 
for i=1:numel(uniqueclusterlabels)
    
    labelstomerge=find(labelsfcjustlocal==uniqueclusterlabels(i));
    
    if (numel(labelstomerge)>1)
        
        maxassignedlabel=maxassignedlabel+1;
        
        twcmergetuples{numel(twcmergetuples)+1}= [ maxassignedlabel, reshape(previouslabelsbackmap(labelstomerge),1,[]) ]; %#ok<AGROW>
        
        previouslabelsbackmap(labelstomerge)=maxassignedlabel;
    end
end


