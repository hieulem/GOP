function touchingmatrix=Gettouchingmatrixonlabelledvideo(labelledvideo,btrajectories,noallsuperpixels,mapped,printonscreen)
%for inverse mapping
%[frame,label]=find(mapped==indexx);

if (  (~exist('printonscreen','var'))  ||  (isempty(printonscreen))  )
    printonscreen=false;
end

noBtrajectories=numel(btrajectories);

%Determine the video sizes
dimvideo=size(labelledvideo);

%touchingmatrix(a_b_traj, a_traj)=true if a_b_traj is completely contained
%in a_traj for the all length of a_traj
touchingmatrix=false(noBtrajectories,noallsuperpixels);

%Fill in matrix
for bk=1:noBtrajectories
    bpos=0;
    for f=btrajectories{bk}.startFrame:min(btrajectories{bk}.endFrame,dimvideo(3))
        bpos=bpos+1;
        
        thex=min(max( round(btrajectories{bk}.Xs(bpos)) ,1),dimvideo(2));
        they=min(max( round(btrajectories{bk}.Ys(bpos)) ,1),dimvideo(1));

        touchedlabel=labelledvideo(they,thex,f);
        touchingmatrix(bk,mapped(f,touchedlabel))=true;
    end
end




