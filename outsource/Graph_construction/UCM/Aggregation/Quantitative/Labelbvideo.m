function blabelledvideo=Labelbvideo(btrajectories,videosize,printonscreen,backgroundlabel)

if (~exist('backgroundlabel','var') || (isempty(backgroundlabel)) )
    backgroundlabel=0;
end
if (~exist('printonscreen','var') || (isempty(printonscreen)) )
    printonscreen=false;
end

touchedpixels=false(videosize);
blabelledvideo=ones(videosize)*backgroundlabel;

notraj=numel(btrajectories);

for i=1:notraj
    
    count=0;
    %Trajectories longer than videosize(3) are only considered up that
    %frames or not at all, depending on btrajectories{i}.startFrame
    for j=btrajectories{i}.startFrame:min(btrajectories{i}.endFrame,videosize(3))
        count=count+1;
        xx=round(btrajectories{i}.Xs(count));
        yy=round(btrajectories{i}.Ys(count));
        
        if ((xx<1)||(xx>videosize(2))||(yy<1)||(yy>videosize(1)))
            continue;
        end
        if (~touchedpixels(yy,xx,j))
            blabelledvideo(yy,xx,j)=btrajectories{i}.nopath;
            touchedpixels(yy,xx,j)=true;
        end
    end
    
end

if (printonscreen)
    Printthevideoonscreen(blabelledvideo, printonscreen, 1);
end