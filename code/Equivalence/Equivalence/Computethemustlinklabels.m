function [uniquelabelswhichmustlink,maxuniquelabelalreadylabelled,maxnewlabelsalreadyassigned,previouslabelsbackmap]= Computethemustlinklabels(mustlinks,superpixelization)
% uniquelabelswhichmustlink = vector relabeling superpixels with unique
%   labels coming from mustlinks (for the segmented part) and with
%   progressive indexes (for the not yet segmented part)
%   - 1:maxuniquelabelalreadylabelled = those already labelled (compact and complete values from 1 to maxnewlabelsalreadyassigned)
%   - maxuniquelabelalreadylabelled+1:numberofsuperpixels = those still to label (progressive labels from maxnewlabelsalreadyassigned+1 for each superpixels)
%
% previouslabelsbackmap = vector backmapping the new labels (the new compact and complete ones of uniquelabelswhichmustlink) back to the
%   original labels (the values in mustlinks) JUST FOR THE SEGMENTED PART
%   Size is [1 x maxnewlabelsalreadyassigned], values are those of the original labels (thus potentially indefinitely large if the algorithm has been running for some time)



[uniquelabels,tmp,remappedlabels]=unique(mustlinks); %Remap mustlinks to get compact labels starting from 1
remappedlabels=reshape(remappedlabels,size(mustlinks)); %
maxnewlabelsalreadyassigned=max(remappedlabels(:)); %maxnewlabelsalreadyassigned will be propagated, not all labels are supposed to be assigned (first frames are cut)
if (isempty(maxnewlabelsalreadyassigned)), maxnewlabelsalreadyassigned=0; end



numberofsuperpixels=max(superpixelization(:)); %This are supposed to be complete (initial frames have been cut but renumbered)



%Cut excessive frames to speed up computation
labelledleveltmp=superpixelization(1:size(mustlinks,1),1:size(mustlinks,2),1:size(mustlinks,3)); %Assume that the labelled video is a part of superpixelization



%Compute uniquelabelswhichmustlink
%Assume that segments from mustlinks do not span multiple superpixels
uniquelabelswhichmustlink=Computeuniquelabelswhichmustlinkmex(remappedlabels,labelledleveltmp,numberofsuperpixels,maxnewlabelsalreadyassigned);



maxuniquelabelalreadylabelled=max(labelledleveltmp(:));
if (isempty(maxuniquelabelalreadylabelled)), maxuniquelabelalreadylabelled=0; end



%Label the other superpixels accordingly
maxnewlabel=(numberofsuperpixels-maxuniquelabelalreadylabelled+maxnewlabelsalreadyassigned);
uniquelabelswhichmustlink(maxuniquelabelalreadylabelled+1:numberofsuperpixels)= (maxnewlabelsalreadyassigned+1) : maxnewlabel;



% Create vector backmapping the new labels to the original labels (the values in mustlinks) FOR THE SEGMENTED PART
previouslabelsbackmap = reshape(uniquelabels,1,[]);
% Corresponds to uniquelabelsmustlinkbackmap(1:maxnewlabelsalreadyassigned)
%   - maxnewlabelsalreadyassigned+1:maxnewlabel = containing the superpixel indexes from superpixelization for the superpixels yet to label



% Create vector backmapping the new labels (those for the new unlabelled superpixels) to the original superpixel ids (from superpixelization)
superpixelidbackmap = maxuniquelabelalreadylabelled+1:numberofsuperpixels;
% Corresponds to uniquelabelsmustlinkbackmap(maxnewlabelsalreadyassigned+1:maxnewlabel)



uniquelabelsmustlinkbackmap=zeros(1,maxnewlabel);
uniquelabelsmustlinkbackmap(1:maxnewlabelsalreadyassigned)=uniquelabels;
uniquelabelsmustlinkbackmap(maxnewlabelsalreadyassigned+1:maxnewlabel)=maxuniquelabelalreadylabelled+1:numberofsuperpixels;
% Important assumption: both remappedlabels and superpixelization count
% from 1 in the temporal window; given the strict inclusion of superpixels
% in the previous labelling (no half pixel allowed to be labelled) it is
% possible to assume that:
% maxnewlabelsalreadyassigned<=maxuniquelabelalreadylabelled
% (equality holds when the previous segmentation assign a different label
% to each pixel)
% This guarantees that uniquelabelsmustlinkbackmap does not bear any clash
% in labeling
% It may however happen that
% uniquelabelsmustlinkbackmap(1:maxnewlabelsalreadyassigned) include values
% bigger than maxuniquelabelalreadylabelled, e.g. labels assigned to a long
% video sequence



