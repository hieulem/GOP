function Visualisealltrajectories(trajectories,trackLength,frame,nofigure,cim,selectedtreetrajectories)

if ( (~exist('nofigure','var')) || (isempty(nofigure)) )
    nofigure=13;
end
if ( (~exist('selectedtreetrajectories','var')) || (isempty(selectedtreetrajectories)) )
    selectedtreetrajectories=true(1,numel(trajectories));
end

if ( (~exist('cim','var')) || (~iscell(cim)) )
    figure(nofigure)
else
    Init_figure_no(nofigure);
    imshow(cim{frame});
end

hold on
for k=1:size(trajectories,2)
    if ( (isempty(trajectories{k})) || (~(selectedtreetrajectories(k))) )
        continue;
    end
    if (trajectories{k}.totalLength<trackLength)
        continue;
    end
    if ( (trajectories{k}.startFrame>frame)||(trajectories{k}.endFrame<frame) )
        continue;
    end
    posInarray=frame-trajectories{k}.startFrame+1;
    line(trajectories{k}.Xs,trajectories{k}.Ys,'Color','y');
    plot(trajectories{k}.Xs,trajectories{k}.Ys,'+g');
    if (trajectories{k}.endFrame<(frame+trackLength-1))
        plot(trajectories{k}.Xs(posInarray),trajectories{k}.Ys(posInarray),'+r');
            %red crosses have trajectories at least as long as trackLength
    else
        plot(trajectories{k}.Xs(posInarray),trajectories{k}.Ys(posInarray),'+b');
            %blue crosses have trajectories at least as long as trackLength at least spanning from current position to +trackLength
    end
end
hold off
title (['Image with regions trajectories (at least ',num2str(trackLength),' frames)']);
