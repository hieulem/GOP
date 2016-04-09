function labelledvideo=Labelclusteredvideointerestframes(mapped,labelsfc,ucm2,Level,framestoconsider,printonscreen,reorder,randcolor,showcolorbar,nfigure)
%From clusters to labelled frames (each pixel gets a cluster code,
%possibly permuted for visualisation purposes)

% if (framedepth==0)
%     labelledvideo=Labelclusteredvideointerestframes(consideredmapped,consideredlabelsfc,considereducm2,Level,framestoconsider,printonscreeninsidefunction);
% else
%     labelledvideo=Labelclusteredvideointerestframes(consideredmapped,consideredlabelsfc,considereducm2,Level,frameofinterest,printonscreeninsidefunction);
% end
%labelledvideo=Labelclusteredvideo(consideredmapped,consideredlabelsfc,considereducm2,Level,printonscreeninsidefunction);

noFrames=numel(ucm2);

if ( (~exist('framestoconsider','var')) || (isempty(framestoconsider)) )
    framestoconsider=1:noFrames;
end
if ( (~exist('nfigure','var')) || (isempty(nfigure)) )
    nfigure=6;
end
if ( (~exist('showcolorbar','var')) || (isempty(showcolorbar)) )
    showcolorbar=false;
end
if ( (~exist('randcolor','var')) || (isempty(randcolor)) )
    randcolor=true;
end
if ( (~exist('Level','var')) || (isempty(Level)) )
    Level=1;
end
if ( (~exist('reorder','var')) || (isempty(reorder)) )
    reorder=false;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

if (reorder) %Relabel the sequence so that labels are assigned according to first frame and then propagated
    %labelsfcbk=labelsfc; labelsfc=labelsfcbk;
    newlabelsfc=labelsfc; newlabelsfc(:)=-100;
    count=0;
    for i=1:numel(newlabelsfc)
        if (newlabelsfc(i)==(-100))
            count=count+1;
            newlabelsfc(labelsfc==labelsfc(i))=count;
        end
    end
    labelsfc=newlabelsfc;
end

labels2 = bwlabel(ucm2{1} < Level);
labels = labels2(2:2:end, 2:2:end);
dimIi=size(labels,1);
dimIj=size(labels,2);
[framebelong,labelsatframe,numberofelements]=Getmappedframes(mapped);

labelledvideo=zeros(dimIi,dimIj,noFrames);
lastprocessedframe=0;
for indexx=1:numberofelements
    frame=framebelong(indexx);
    label=labelsatframe(indexx);
%     [frame,label]=find(mapped==indexx);
    if (~any(frame==framestoconsider))
        continue;
    end
    if (frame~=lastprocessedframe)
        if (lastprocessedframe>0)
            labelledvideo(:,:,lastprocessedframe)=frameatframe; %this completes the previous loop
        end
        
        lastprocessedframe=frame;
        labels2 = bwlabel(ucm2{frame} < Level);
        labels = labels2(2:2:end, 2:2:end);
    
        frameatframe=labelledvideo(:,:,frame);
    end
    frameatframe(labels==label)=labelsfc(indexx);
end
if (lastprocessedframe>0) %redundant check
    labelledvideo(:,:,lastprocessedframe)=frameatframe; %this completes the last loop
else
    fprintf('No label assigned on the frame of interest, the code should be checked\n');
end

if (printonscreen)
    Printthevideoonscreen(labelledvideo, printonscreen, nfigure, randcolor,showcolorbar,[],true);
%     for f=1:noFrames
%         Init_figure_no(6,'Clusters');
%         theframe=squeeze(labelledvideo(:,:,f));
%         theframe(1,1)=min(labelledvideo(:));
%         theframe(1,2)=max(labelledvideo(:));
%         imagesc(theframe)
% 
%         labels2 = bwlabel(ucm2{f} < Level);
%         labels = labels2(2:2:end, 2:2:end);
%         Init_figure_no(5,'Clusters');
%         imagesc(labels)
%         pause(0.3)
%     end
end
