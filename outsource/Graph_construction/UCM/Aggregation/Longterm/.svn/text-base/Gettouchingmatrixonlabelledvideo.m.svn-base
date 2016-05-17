function touchingmatrix=Gettouchingmatrixonlabelledvideo(labelledlevelvideo,btrajectories,noallsuperpixels,mapped,printonscreen)
%for inverse mapping
%[frame,label]=find(mapped==indexx);
%The sparse version is slightly slower but much more memory efficient as it
%avoids allocating a large touchingmatrix

if (  (~exist('printonscreen','var'))  ||  (isempty(printonscreen))  )
    printonscreen=false;
end

noBtrajectories=numel(btrajectories);

%Determine the video sizes
dimvideo=size(labelledlevelvideo);



%Initialize the variables for the sparse matrix assuming each track is nframes long
nframes=size(labelledlevelvideo,3);
allocatedsize=noBtrajectories*nframes;
btrack=zeros(allocatedsize,1);
spx=zeros(allocatedsize,1);
count=0;
% touchingmatrix=false(noBtrajectories,noallsuperpixels);



%Fill in matrix
for bk=1:noBtrajectories
    bpos=0;
    for f=btrajectories{bk}.startFrame:min(btrajectories{bk}.endFrame,dimvideo(3))
        bpos=bpos+1;
        
        thex=min(max( round(btrajectories{bk}.Xs(bpos)) ,1),dimvideo(2));
        they=min(max( round(btrajectories{bk}.Ys(bpos)) ,1),dimvideo(1));

        touchedlabel=labelledlevelvideo(they,thex,f);
        count=count+1;
        btrack(count)=bk;
        spx(count)=mapped(f,touchedlabel);
    end
end

touchingmatrix=sparse(btrack(1:count),spx(1:count),true(count,1),noBtrajectories,noallsuperpixels);






function touchingmatrix=Gettouchingmatrixonlabelledvideo_backup_full(labelledlevelvideo,btrajectories,noallsuperpixels,mapped,printonscreen) %#ok<DEFNU>
%for inverse mapping
%[frame,label]=find(mapped==indexx);

if (  (~exist('printonscreen','var'))  ||  (isempty(printonscreen))  )
    printonscreen=false;
end

noBtrajectories=numel(btrajectories);

%Determine the video sizes
dimvideo=size(labelledlevelvideo);

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

        touchedlabel=labelledlevelvideo(they,thex,f);
        touchingmatrix(bk,mapped(f,touchedlabel))=true;
    end
end







function test_sparse_logical()


AAA=sparse(1,1,false,100000,100000);

AAA2=logical(sparse(100000,100000));





ind=sub2ind(size(X),r,cvc)
Y=X(ind)



[I J x]=find(X);
[tf loc]= ismember([r(:) cvc(:)],[I J],'rows');
Y = zeros(size(tf));
Y(tf) = x(loc(tf));


