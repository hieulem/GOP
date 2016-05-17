function newlabelledvideo=Votewithtrajectories(numberofsegments,noblabels,btrajectories,labelledvideo,printonscreen)

if (~exist('printonscreen','var') || (isempty(printonscreen)) )
    printonscreen=false;
end

nobtrajectories=numel(btrajectories);
videosize=size(labelledvideo);
votingmap=zeros(numberofsegments,noblabels); %votingmap(which segment, which b label)= no occurrencies

for i=1:nobtrajectories
    blabel=btrajectories{i}.nopath;
    %Trajectories longer than videosize(3) are only considered up that
    %frames or not at all, depending on btrajectories{i}.startFrame
    for theframe=btrajectories{i}.startFrame:min(btrajectories{i}.endFrame,videosize(3))
        pos=theframe-btrajectories{i}.startFrame+1;
        thex=round(btrajectories{i}.Xs(pos)); %+1 has been added when reading the trajectory
        they=round(btrajectories{i}.Ys(pos)); %+1 has been added when reading the trajectory
        if ((thex<1)||(thex>videosize(2))||(they<1)||(they>videosize(1)))
            continue;
        end
        foundsegment=labelledvideo(they,thex,theframe);
        if (foundsegment~=0)
            votingmap(foundsegment, blabel)=votingmap(foundsegment, blabel)+1;
        end
    end
end

[orderedvotes,votingorder]=sort(votingmap,2,'descend');

votingresult=zeros(1,numberofsegments);
for i=1:numberofsegments
    if (orderedvotes(i,1)~=orderedvotes(i,2)) %if first two votes are not equal (case of equal or no votes)
        votingresult(i)=votingorder(i,1);
    else
        votingresult(i)=0;
    end
end

% newlabelledvideo=Remapvideo(labelledvideo,votingresult);
newlabelledvideo=zeros(size(labelledvideo));
for i=1:numel(votingresult)
    newlabelledvideo(labelledvideo==i)=votingresult(i);
end

if (printonscreen)
    Init_figure_no(1);
    
    for i=1:videosize(3)
        imagesc(labelledvideo(:,:,i))
        pause(0.5)
    end
end

if (printonscreen)
    Init_figure_no(1);
    
    for i=1:videosize(3)
        imagesc(newlabelledvideo(:,:,i))
        pause(0.5)
    end
end
