function [mapped,framebelong,noallsuperpixels,maxnolabels]=Mappedfromlabels(labelledvideo,printonscreen)
%mapped provides the index transformation from (frame,label) to similarities
%for inverse mapping
%[frame,label]=find(mapped==indexx);
%or
%[framebelong,labelsatframe,numberofelements]=Getmappedframes(mapped);
%framebelong(label)=frame at which it occurs
%noallsuperpixels=number of labels from the all video sequence
%maxnolabels=maximum number of labels at a frame across all video frames
%The required labelledvideo is computed with labelledvideo=Labellevelframes(ucm2,Level,noFrames,printonscreen);
%The function is related to
% [framebelong,labelsatframe,numberofelements]=Getmappedframes(mapped)



if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

noFrames=size(labelledvideo,3);

noallsuperpixels=0;
maxnolabels=0;
for frame=1:noFrames    
    labels = labelledvideo(:,:,frame);
%     labels2 = bwlabel(ucm2{frame} < Level);
%     labels = labels2(2:2:end, 2:2:end);
    nolabels=max(max(labels));
    
    noallsuperpixels=noallsuperpixels+nolabels;
    
    maxnolabels=max(maxnolabels,nolabels);
    % mask=Getthemask(ucm2{frame},Level,label); %%%since labels and labels2 are already computed above
%     for label=uint32(1):uint32(nolabels)
%         mask=(label==labels);
%         ll=find(mask);
%     end
end

mapped=zeros(noFrames,maxnolabels);
framebelong=zeros(1,noallsuperpixels);
assignedindex=0;
for frame=1:noFrames
    labels = labelledvideo(:,:,frame);
%     labels2 = bwlabel(ucm2{frame} < Level);
%     labels = labels2(2:2:end, 2:2:end);
    nolabels=max(max(labels));
    
    mapped(frame,1:nolabels)=(assignedindex+1):(assignedindex+nolabels);
    framebelong((assignedindex+1):(assignedindex+nolabels))=frame;
    assignedindex=assignedindex+nolabels;
end

if (printonscreen)
    Init_figure_no(1), imagesc(mapped);
end






function Code_for_mapping_some_frames(mapped,noFrames) %#ok<DEFNU>

    framestoconsider=1:noFrames; %all frames are considered altogether
    
    tmpconsideredmapped=mapped(framestoconsider,:);
        %the indexes are in agreement with similarities and must be translated to consideredsimilarities
    
    %elements of consideredmapped are already ordered and order should not count anyway
    tmpmapped=tmpconsideredmapped';
    indexestoconsider=tmpmapped(tmpmapped~=0); %indexes of position in the similarities matrix
    
    consideredsimilarities=similarities(indexestoconsider,indexestoconsider); %#ok<NASGU>
    
    noconsideredindexes=numel(indexestoconsider);
    
    consideredmapped=tmpconsideredmapped;
    for i=1:noconsideredindexes
        consideredmapped(tmpconsideredmapped==indexestoconsider(i))=i;
    end
    %for inverse mapping
    %[k,label]=find(consideredmapped==indexx); frame=framestoconsider(k);
    
    %For comparison
%     isequal(consideredsimilarities,similarities2)
%     consideredmapped2=consideredmapped(:,1:792);
%     isequal(consideredmapped2,mapped2)    
