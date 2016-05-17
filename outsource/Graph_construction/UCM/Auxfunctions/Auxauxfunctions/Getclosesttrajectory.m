function k=Getclosesttrajectory(trajectories,ipos,jpos,frame,trackLength,selectedtreetrajectories)

if ( (~exist('selectedtreetrajectories','var')) || (isempty(selectedtreetrajectories)) )
    selectedtreetrajectories=true(1,numel(trajectories));
end


%Initial iteration for counting (for preallocating memory)
tcount=0;
for k=1:size(trajectories,2)
    if ( (isempty(trajectories{k})) || (~selectedtreetrajectories(k)) )
        continue;
    end
    if (trajectories{k}.totalLength<trackLength)
        continue;
    end
    if ( (trajectories{k}.startFrame>frame)||(trajectories{k}.endFrame<frame) )
        continue;
    end
    tcount=tcount+1;
end

%Scans through trajectories and computes distances
count=0;
dist=zeros(1,tcount);
posInTrajArray=zeros(1,tcount);
for k=1:size(trajectories,2)
    if ( (isempty(trajectories{k})) || (~selectedtreetrajectories(k)) )
        continue;
    end
    if (trajectories{k}.totalLength<trackLength)
        continue;
    end
    if ( (trajectories{k}.startFrame>frame)||(trajectories{k}.endFrame<frame) )
        continue;
    end
    posInarray=frame-trajectories{k}.startFrame+1;
%     plot(trajectories{k}.Xs(posInarray),trajectories{k}.Ys(posInarray),'+r');
    
    count=count+1;
    dist(count)=sqrt( (trajectories{k}.Xs(posInarray)-jpos)^2+(trajectories{k}.Ys(posInarray)-ipos)^2 );
    posInTrajArray(count)=k;
end

%Computation of the closest trajectory
[c,r]=min(dist);
k=posInTrajArray(r);
