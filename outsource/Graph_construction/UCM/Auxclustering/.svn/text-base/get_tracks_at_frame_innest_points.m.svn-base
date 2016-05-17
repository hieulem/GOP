function [track,mapTracToTrajectories]=get_tracks_at_frame_innest_points(image,trajectories,frame,trackLength,firstTrajectory,printonscreen)
%returned tracks are all trackLength long

if (  (~exist('printonscreen','var'))  ||  (isempty(printonscreen))  )
    printonscreen=false;
end

if (printonscreen)
    figure(15)
    imshow(image)
    set(gcf, 'color', 'white');
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
track=zeros(trackLength,2,noTracks);
mapTracToTrajectories=zeros(1,noTracks);
for k=firstTrajectory:size(trajectories,2)
    if (isempty(trajectories{k}))
        continue;
    end
    if ( (trajectories{k}.startFrame>frame)||(trajectories{k}.endFrame<(frame+trackLength-1)) )
        continue;
    end
    count=count+1;
    for i=1:trackLength
        posInarray=frame-trajectories{k}.startFrame+i;
        track(i,1,count)=trajectories{k}.Xs(posInarray);
        track(i,2,count)=trajectories{k}.Ys(posInarray);
    end
    mapTracToTrajectories(count)=k;
%     frameposInarray=frame-trajectories{k}.startFrame+1; %position in trajectory of the present frame
end

if (printonscreen)
    hold on
    for k=1:noTracks
        line(track(:,1,k),track(:,2,k),'Color','y');
        plot(track(:,1,k),track(:,2,k),'+g');
        plot(track(1,1,k),track(1,2,k),'+r');
    end
    hold off
end

%It must be verified the following
if ( noTracks~=count)
    fprintf('Please check the extraction of innest point trajectories at frame %d\n',frame);
end
