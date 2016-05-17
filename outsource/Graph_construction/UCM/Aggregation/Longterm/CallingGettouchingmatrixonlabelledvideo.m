function touchingmatrix=CallingGettouchingmatrixonlabelledvideo(labelledlevelvideo,btrajectories,noallsuperpixels,mapped,printonscreen)
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
% count1=0;
% touchingmatrix=false(noBtrajectories,noallsuperpixels);

count1 = Gettouchingmatrixonlabelledvideo_mex(labelledlevelvideo ,btrajectories, noallsuperpixels,mapped,btrack,spx,noBtrajectories,dimvideo);

touchingmatrix=sparse(btrack(1:count1),spx(1:count1),true(count1,1),noBtrajectories,noallsuperpixels);


% %Fill in matrix
% for bk=1:noBtrajectories
%     bpos=0;
%     for f=btrajectories{bk}.startFrame:min(btrajectories{bk}.endFrame,dimvideo(3))
%         bpos=bpos+1;
%         
%         thex=min(max( round(btrajectories{bk}.Xs(bpos)) ,1),dimvideo(2));
%         they=min(max( round(btrajectories{bk}.Ys(bpos)) ,1),dimvideo(1));
% 
%         touchedlabel=labelledlevelvideo(they,thex,f);
%         count=count+1;
%         btrack(count)=bk;
%         spx(count)=mapped(f,touchedlabel);
%     end
% end

