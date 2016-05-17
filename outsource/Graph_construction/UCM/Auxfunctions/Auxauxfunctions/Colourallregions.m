function Colourallregions(trajectories,...
    frame,trackLength,allregionpaths,ucm2,allregionsframes,selectedtreetrajectories,cim,nooffigure,visualisecentroids)
%Colours all regions at least trackLength long. Trajectory length is
%absolute and does not consider the startFrame
%cim is only requested if printonscreen is true


if ( (~exist('visualisecentroids','var')) || (isempty(visualisecentroids)) )
    visualisecentroids=false;
end
if ( (~exist('nooffigure','var')) || (isempty(nooffigure)) )
    nooffigure=16;
end
if ( (~exist('frame','var')) || (isempty(frame)) )
    frame=1;
end
if ( (~exist('trackLength','var')) || (isempty(trackLength)) )
    trackLength=3;
end

noTrajectories=numel(trajectories);
if (  (~exist('selectedtreetrajectories','var'))  ||  (isempty(selectedtreetrajectories))  )
    selectedtreetrajectories=true(1,noTrajectories);
end





%This part counts the trajectories, for initialising the memory
noTracks=0;
for k=1:noTrajectories
    if (isempty(trajectories{k}))
        continue;
    end
    if ((trajectories{k}.totalLength<trackLength)||(~selectedtreetrajectories(k)))
        continue;
    end
    if ( (trajectories{k}.startFrame>frame)||(trajectories{k}.endFrame<frame) )
        continue;
    end
    noTracks=noTracks+1;
end
fprintf('No of trajectories at least %d frame long are %d\n',trackLength,noTracks);



dist_track_mask=cell(1,noTracks);
track=zeros(1,2,noTracks);
mapTracToTrajectories=zeros(1,noTracks);
all_the_lengths.start=zeros(1,noTracks);
all_the_lengths.end=zeros(1,noTracks);
count=0;
for k=1:numel(trajectories)
    if (isempty(trajectories{k}))
        continue;
    end
    if ((trajectories{k}.totalLength<trackLength)||(~selectedtreetrajectories(k)))
        continue;
    end
    if ( (trajectories{k}.startFrame>frame)||(trajectories{k}.endFrame<frame) )
        continue;
    end
    count=count+1;
    
    nopath=trajectories{k}.nopath;
    
    %trajectories{k}.totalLength(nopath)
    region=find(allregionpaths.nopath{frame}==nopath);
    dist_track_mask{1,count}=Getthemask(ucm2{frame},allregionsframes{frame}{region}.ll(1,1),allregionsframes{frame}{region}.ll(1,2));
    all_the_lengths.start(count)=trajectories{k}.startFrame;
    all_the_lengths.end(count)=trajectories{k}.endFrame;
    mapTracToTrajectories(count)=k;
    
    posinarray=frame-trajectories{k}.startFrame+1;
    track(1,1,count)=trajectories{k}.Xs(posinarray);
    track(1,2,count)=trajectories{k}.Ys(posinarray);
end
%track = [ which frame , x or y , which trajectory ]
% dist_track_mask{which frame,which trajectory}=mask



theimage=cim{frame};

colourratio=1/2;
colourforimage=[1,1,0];
colourforedges=[1,0,0];
thickeredges=false;

Colourtheimage(theimage,dist_track_mask(1,:),nooffigure,colourratio,colourforimage,colourforedges,thickeredges);

figure(nooffigure);
title(['Trajectories at least ',num2str(trackLength),' long at frame ',num2str(frame)]);



if (visualisecentroids)
    hold on
    for k=1:noTracks
        plot(track(1,1,k),track(1,2,k),'+b');
    end
    hold off
end



