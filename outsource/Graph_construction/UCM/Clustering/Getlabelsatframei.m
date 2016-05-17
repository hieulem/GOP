function [labelsc,labelsv]=Getlabelsatframei(allGis,labels,Gif,frame)
%labelsc are for computing (they contain no empty label
%labelsv are for visualising (they are consistent over the computed frames)

g=find(Gif.frame==frame);
l=1;

%find all correspondences
mapTracToTrajectories=allGis.mapTracToTrajectories;
correspondences=zeros(1,numel(mapTracToTrajectories));
for k=1:numel(correspondences)
    correspondences(k)=Translatefromfirsttosecond(mapTracToTrajectories,k,Gif.Gis{g}.mapTracToTrajectories{l});
end

labelsv=zeros(1,numel(Gif.Gis{g}.mapTracToTrajectories{l}));
for k=1:numel(correspondences)
    if (correspondences(k))
        labelsv(correspondences(k))=labels(k);
    end
end

labelsc=labelsv;
nolabels=max(labelsc);
% decrease=0;
for k=nolabels-1:-1:1
    if ( ~any(any( labelsc==k )) )
        labelsc(labelsc>k)=labelsc(labelsc>k)-1;
%         decrease=decrease+1;
    end
end

% nolabels=nolabels-decrease;