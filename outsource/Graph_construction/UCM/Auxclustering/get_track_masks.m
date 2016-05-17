function [dist_track_mask,mapTracToTrajectories]=get_track_masks(firstTrajectory,image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,printonscreen)
%The function obtains the region masks corresponding to the trajectories
%for use: image=cim{frame}

if (  (~exist('printonscreen','var'))  ||  (isempty(printonscreen))  )
    printonscreen=false;
end

if (printonscreen)
    figure(16)
    imshow(image)
    set(gcf, 'color', 'white');

    %initialisation of necessary parts (strel and frameEdge)
    SE=Getstrel();
    frameEdge=Getframeedge(size(image,1),size(image,2));
end

%This part counts the trajectories, for initialising the memory
noTracks=0;
for k=firstTrajectory:size(trajectories,2)
    if (isempty(trajectories{k}))
        continue;
    end
    if ( (trajectories{k}.startFrame>frame)||(trajectories{k}.endFrame<(frame+trackLength-1)) )
        continue;
    end
    noTracks=noTracks+1;
end

count=0;
mapTracToTrajectories=zeros(1,noTracks);
dist_track_mask=cell(trackLength,noTracks);
for k=firstTrajectory:size(trajectories,2)
    if (isempty(trajectories{k}))
        continue;
    end
    if ( (trajectories{k}.startFrame>frame)||(trajectories{k}.endFrame<(frame+trackLength-1)) )
        continue;
    end
    count=count+1;
    nopath=trajectories{k}.nopath;

    for f=1:trackLength %trajectories{k}.totalLength(nopath)
        ff=frame+f-1;
% % %         ff=frame-trajectories{k}.startFrame+1;
%         ff=f+trajectories{k}.startFrame-1;
        region=find(allregionpaths.nopath{ff}==nopath);
        dist_track_mask{f,count}=Getthemask(ucm2{ff},allregionsframes{ff}{region}.ll(1,1),allregionsframes{ff}{region}.ll(1,2));
    end
    
    mapTracToTrajectories(count)=k;
    
    if (printonscreen)
        if (~all(all(dist_track_mask{1,count}))) %so we exclude the whole frame
            mask=uint8(dist_track_mask{1,count});
%             image(:,:,1)=image(:,:,1)-image(:,:,1).*mask;
%             image(:,:,2)=image(:,:,2)-image(:,:,2).*mask;
            image(:,:,3)=image(:,:,3)-image(:,:,3).*mask; %subtracting only blue makes the marked regions yellow
        end

        edge=uint8(dist_track_mask{1,count}-(imerode(dist_track_mask{1,count}, SE).*frameEdge));
        noEdge=(1-edge);
        
        %this makes the contours of regions red
        image(:,:,1)=image(:,:,1).*noEdge+image(:,:,1).*edge*255;
        image(:,:,2)=image(:,:,2).*noEdge;
        image(:,:,3)=image(:,:,3).*noEdge;
    end
end


if (printonscreen)
    figure(16)
    imshow(image)
    set(gcf, 'color', 'white');
    title('First frame with regions and region edges marked, whole frame excluded from the picture, if any');
end

% figure(17)
% imshow(dist_track_mask{1,5})
% set(gcf, 'color', 'white');
% figure(18)
% imshow(dist_track_mask{1,6})
% set(gcf, 'color', 'white');
% figure(18)
% imshow(dist_track_mask{1,6}+dist_track_mask{1,5})
% set(gcf, 'color', 'white');



