function [LTT, CTR] = Computelongerterm(touchingmatrix,temporalsmoothing,framebelong, options, theoptiondata, filenames)

%paper options:
% options.lttuexp=false; options.lttlambd=1; options.lttsqv=false;

%optimized options (default):
% options.lttuexp=false; options.lttlambd=1; options.lttsqv=false;

if ( (~exist('temporalsmoothing','var')) || (isempty(temporalsmoothing)) )
    temporalsmoothing=false;
end
if (temporalsmoothing)
    if ( (~exist('framebelong','var')) || (isempty(framebelong)) )
        fprintf('Use of temporal smoothing requires frame belonging information\n');
        temporalsmoothing=false;
    end
end

[btrack,spx]=find(touchingmatrix); %sparse matrix case

tmsize=size(touchingmatrix);
noBtrajectories=tmsize(1);
noallsuperpixels=tmsize(2);

allintersectks=cell(1,noallsuperpixels); %each cell contains horizontal arrays
for k=1:noallsuperpixels
    allintersectks{k}= btrack(spx==k)'; %sparse matrix case
%     allintersectks{k}=find(touchingmatrix(:,k))'; %full matrix case
end
allintersectbks=cell(1,noBtrajectories); %each cell contains horizontal arrays
for bk=1:noBtrajectories
    allintersectbks{bk}= spx(btrack==bk)'; %sparse matrix case
%     allintersectbks{bk}=find(touchingmatrix(bk,:)); %full matrix case
end

%Count number of entries to include in the LTT
donetrajs=false(noallsuperpixels,noallsuperpixels);
for i=1:noallsuperpixels
    donetrajs(i,i)=true;
end
% donetrajs(logical(eye(noallsuperpixels)))=true;
count=0;
for bk=1:noBtrajectories
    intersectks=allintersectbks{bk};
    for k1count=1:numel(intersectks)
        k1=intersectks(k1count);
        for k2count=k1count+1:numel(intersectks)
            k2=intersectks(k2count);
            if (donetrajs(k1,k2))
                continue;
            end
            count=count+1;
            donetrajs(k1,k2)=true;
            donetrajs(k2,k1)=true;
        end
    end
end
nomaxentries=count;


%Compute LTT
tic
firstindex=zeros(nomaxentries,1);
secondindex=zeros(nomaxentries,1);
values=zeros(nomaxentries,1);
values_ctr=zeros(nomaxentries,1);
[r,c]=find(donetrajs);
todelete=(r<=c);
r(todelete)=[];
c(todelete)=[];
if (numel(r)~=nomaxentries)
    fprintf('Please check donetrajs\n');
    LTT=0;
    return;
end
% fprintf('count(out of %d) %010d',nomaxentries,0);
fprintf('Computing LTT elements... ');
for i=1:numel(r)
    
    k1=r(i);
    k2=c(i);
    
    intersectbks1=allintersectks{k1};
    intersectbks2=allintersectks{k2};

    [ratejointcoincide,countcommon]=Computejointcoincide(intersectbks1,intersectbks2);
    
    %ratecoincide is the dice coefficient between intersecting sets

    firstindex(i)=k1;
    secondindex(i)=k2;
    if (temporalsmoothing)
        values(i)=ratejointcoincide/( abs( framebelong(k1)-framebelong(k2) ) );
    else
        values(i)=ratejointcoincide;
    end
        values_ctr(i)=countcommon;
end
fprintf('done, ');
toc

LTT=Getlttfromindexedrawvalues([firstindex;secondindex],[secondindex;firstindex],[values;values],noallsuperpixels,options);
CTR=sparse([firstindex;secondindex], [secondindex;firstindex],[values_ctr;values_ctr], noallsuperpixels, noallsuperpixels);

%Add data to paramter calibration directory
if ( (isfield(options,'calibratetheparameters')) && (~isempty(options.calibratetheparameters)) && (options.calibratetheparameters) )
    thiscase='ltt';
    printonscreenincalibration=false;
    Addthisdataforparametercalibration([firstindex;secondindex],[secondindex;firstindex],[values;values],thiscase,theoptiondata,filenames,noallsuperpixels,printonscreenincalibration);
end


%This function iterates through the btrajectories in the outer loop and
%uses a boolean matrix to find out which trajectories have been processed
%already
% 
%Count number of entries to include in the LTT
% tic
% donetrajs=false(noallsuperpixels,noallsuperpixels);
% for i=1:noallsuperpixels
%     donetrajs(i)=true;
% end
% % donetrajs(logical(eye(noallsuperpixels)))=true;
% count=0;
% for bk=1:noBtrajectories
%     intersectks=allintersectbks{bk};
%     for k1count=1:numel(intersectks)
%         k1=intersectks(k1count);
%         for k2count=k1count+1:numel(intersectks)
%             k2=intersectks(k2count);
%             if (donetrajs(k1,k2))
%                 continue;
%             end
%             count=count+1;
%             donetrajs(k1,k2)=true;
%             donetrajs(k2,k1)=true;
%         end
%     end
% end
% toc
% nomaxentries=count;
% 
%Compute LTT without using the donetrajs
% tic
% donetrajs=false(noallsuperpixels,noallsuperpixels);
% donetrajs(logical(eye(noallsuperpixels)))=true;
% count=0;
% firstindex=zeros(nomaxentries,1);
% secondindex=zeros(nomaxentries,1);
% values=zeros(nomaxentries,1);
% fprintf('btrajectory(out of %d)-totfilled(out of %d) %08d-%010d',noBtrajectories,nomaxentries,0,0);
% for bk=1:noBtrajectories
% 
%     intersectks=allintersectbks{bk};
%     
%     for k1count=1:numel(intersectks)
%         k1=intersectks(k1count);
%         
%         for k2count=k1count+1:numel(intersectks)
%             
%             k2=intersectks(k2count);
%             
%             if (donetrajs(k1,k2))
%                 continue;
%             end
%                         
%             count=count+1;
%             
%             intersectbks1=allintersectks{k1};
%             intersectbks2=allintersectks{k2};
% 
%             ratejointcoincide=Computejointcoincide(intersectbks1,intersectbks2);
%             %ratecoincide is the dice coefficient between intersecting sets
%             
%             firstindex(count)=k1;
%             secondindex(count)=k2;
%             values(count)=ratejointcoincide;
%                         
%             donetrajs(k1,k2)=true;
%             donetrajs(k2,k1)=true;
%         end
%     end
%     if (~mod(bk,1000))
%         fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b%08d-%010d',bk,count);
%     end
% end
% fprintf('\n');
% toc
% LTT = sparse([firstindex;secondindex],[secondindex;firstindex],[values;values],noallsuperpixels,noallsuperpixels);


%Compute number of max entries: each label is connected to all those at
%the following frames, with a spread factor
% spreadfactor=10;
% thesum=0;
% for thetot=noFrames:-1:1
%     thesum=thesum+thetot;
% end
% nomaxentriesupperbound=thesum*spreadfactor*(noallsuperpixels/noFrames);
%
%Count number of entries to include in the LTT with sparse
%donetrajs
% tic
% donetrajs=sparse(1:noallsuperpixels,1:noallsuperpixels,true,noallsuperpixels,noallsuperpixels,nomaxentriesupperbound);
% count=0;
% fprintf('btrajectory(out of %d)-totfilled(out of %d) %08d-%010d',noBtrajectories,nomaxentries,0,0);
% for bk=1:noBtrajectories
%     intersectks=allintersectbks{bk};
%     for k1count=1:numel(intersectks)
%         k1=intersectks(k1count);
%         for k2count=k1count+1:numel(intersectks)
%             k2=intersectks(k2count);
%             if (donetrajs(k1,k2))
%                 continue;
%             end
%             count=count+1;
%             donetrajs(k1,k2)=true;
%             donetrajs(k2,k1)=true;
%         end
%     end
%     if (~mod(bk,100))
%         fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b%08d-%010d',bk,count);
%     end
% end
% fprintf('\n');
% toc
% nomaxentries=count;


%This function iterates through the btrajectories in the outer loop
% LTT=sparse(noallsuperpixels,noallsuperpixels);
% fprintf('btrajectory (out of %d) %08d',noBtrajectories,0);
% for bk=1:noBtrajectories
% 
%     intersectks=allintersectbks{bk};
%     
%     for k1count=1:numel(intersectks)
%         for k2count=k1count+1:numel(intersectks)
%             
%             k1=intersectks(k1count);
%             k2=intersectks(k2count);
%             
%             if (LTT(k1,k2))
%                 continue;
%             end
%             
%             intersectbks1=allintersectks{k1};
%             intersectbks2=allintersectks{k2};
% 
%             ratejointcoincide=Computejointcoincide(intersectbks1,intersectbks2);
%             %ratecoincide is the dice coefficient between intersecting sets
%             
%             LTT(k1,k2)=ratejointcoincide;
%             LTT(k2,k1)=ratejointcoincide;
%         end
%     end
%     if (~mod(bk,1000))
%         fprintf('\b\b\b\b\b\b\b\b%08d',bk);
%     end
% end
% fprintf('\n');

%This function iterates through the trajectories in the outer loop
% for k=1:noallsuperpixels
%     
%     intersectbks=allintersectks{k};
%     
%     for bkcount=1:numel(intersectbks)
%         
%         bk=intersectbks(bkcount);
%         intersectks=allintersectbks{bk};        
%         
%         for kincount=1:numel(intersectks)
%             
%             kin=intersectks(kincount);
%             
%             if ( (kin==k) || (LTT(k,kin)>0) )
%                 continue;
%             end
%                         
%             intersectbksin=allintersectks{kin};
% 
%             ratejointcoincide=Computejointcoincide(intersectbksin,intersectbks);
%             %ratecoincide is the min of the two rate, so >0.5 ensures unique correspondences
%             
%             LTT(k,kin)=ratejointcoincide;
%             LTT(kin,k)=ratejointcoincide;
%         end
%     end
% end


