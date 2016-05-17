function labelledvideo=Labelclusteredvideo(mapped,labelsfc,ucm2,Level,printonscreen)
%From clusters to labelled frames (each pixel gets a cluster code,
%possibly permuted for visualisation purposes)

if ( (~exist('Level','var')) || (isempty(Level)) )
    Level=1;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end


labels2 = bwlabel(ucm2{1} < Level);
labels = labels2(2:2:end, 2:2:end);
dimIi=size(labels,1);
dimIj=size(labels,2);
noFrames=numel(ucm2);

[framebelong,labelsatframe,numberofelements]=Getmappedframes(mapped);

labelledvideo=zeros(dimIi,dimIj,noFrames);
lastprocessedframe=0;
for indexx=1:numberofelements
    frame=framebelong(indexx);
    label=labelsatframe(indexx);
%     [frame,label]=find(mapped==indexx);
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
    for f=1:noFrames
        Init_figure_no(6,'Clusters');

        theframe=squeeze(labelledvideo(:,:,f));
        
        theframe(1,1)=min(labelledvideo(:));
        theframe(1,2)=max(labelledvideo(:));
        imagesc(theframe)
%         imshow(uint8((theframe-min(labelledvideo(:)))*255/(max(labelledvideo(:))-min(labelledvideo(:)))))
%         image((theframe-min(labelledvideo(:)))*255/(max(labelledvideo(:))-min(labelledvideo(:))))

        labels2 = bwlabel(ucm2{f} < Level);
        labels = labels2(2:2:end, 2:2:end);
        Init_figure_no(5,'Clusters');
        imagesc(labels)
        pause(1)
    end
end
