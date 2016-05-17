function touchingmatrix=Gettouchingmatrixonlabelledvideo_cpp(labelledlevelvideo,btrajectories,noallsuperpixels,mapped,printonscreen)
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

count1 = Gettouchingmatrixonlabelledvideo_mex(labelledlevelvideo ,btrajectories, noallsuperpixels,mapped,btrack,spx,noBtrajectories,dimvideo);

touchingmatrix=sparse(btrack(1:count1),spx(1:count1),true(count1,1),noBtrajectories,noallsuperpixels);


