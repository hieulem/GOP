function [allthesegmentations,labelledvideo]=Initallsegmentations(framesize,numberofclusterings,includeoversegmentation,mapped,ucm2,Level,framerange)

printonscreen=false;

%Initialization of a cell array with all segmentations
if (includeoversegmentation)
    numberallsegmentations=numberofclusterings+1;
else
    numberallsegmentations=numberofclusterings;
end
allthesegmentations=cell(1,numberallsegmentations);
for ms=1:numberallsegmentations
    allthesegmentations{ms}=zeros(framesize,'uint8');
end
if (includeoversegmentation)
    labelledvideo=Labelclusteredvideointerestframes(mapped,1:sum(sum(mapped>0)),ucm2,Level,framerange,printonscreen);
    allthesegmentations{numberallsegmentations}=Uintconv(labelledvideo);
end
