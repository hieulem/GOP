function [mmtrajectories,mmmapPathToTrajectory,mselectedtreetrajectories,mallregionpaths]=Mergetheregions(btrajectories,...
    trajectories,mapPathToTrajectory,selectedtreetrajectories,allregionpaths,ucm2,allregionsframes,noFrames,printonscreen,cim)

noTrajectories=numel(trajectories);

if (  (~exist('selectedtreetrajectories','var'))  ||  (isempty(selectedtreetrajectories))  )
    selectedtreetrajectories=true(1,noTrajectories);
end
if (  (~exist('printonscreen','var'))  ||  (isempty(printonscreen))  )
    printonscreen=false;
end

noBtrajectories=numel(btrajectories);

%Only keep valid trajectories in trajectories
mtrajectories=trajectories;
mmapPathToTrajectory=mapPathToTrajectory;
noMtrajectories=numel(mtrajectories);
for k=noMtrajectories:-1:1
    if (~selectedtreetrajectories(k))
        mmapPathToTrajectory(find(mmapPathToTrajectory==k,1,'first'))=0;
        thosetochange=(mmapPathToTrajectory>k);
        mmapPathToTrajectory(thosetochange)=mmapPathToTrajectory(thosetochange)-1;
        for kk=k:(noMtrajectories-1)
            mtrajectories{kk}=mtrajectories{kk+1};
%             mmapPathToTrajectory(find(mmapPathToTrajectory==kk+1,1,'first'))=kk;
        end
        noMtrajectories=noMtrajectories-1;
    end
end
mtrajectories(noMtrajectories+1:numel(mtrajectories))=[];



%touchingmatrix(a_b_traj, a_traj)=true if a_b_traj is completely contained
%in a_traj for the all length of a_traj
touchingmatrix=false(noBtrajectories,noMtrajectories);



%Determine the image sizes
nopath=mtrajectories{1}.nopath;
ff=mtrajectories{1}.startFrame;
region=find(allregionpaths.nopath{ff}==nopath);
amask=Getthemask(ucm2{ff},allregionsframes{ff}{region}.ll(1,1),allregionsframes{ff}{region}.ll(1,2));
dim=size(amask);



%Fill in matrix
regionmasks=false(dim(1),dim(2),noFrames); %mask length, so this memory does not be reassigned and no mapping is needed
for k=1:noMtrajectories
    
    nopath=mtrajectories{k}.nopath;
    for f=mtrajectories{k}.startFrame:mtrajectories{k}.endFrame
        region=find(allregionpaths.nopath{f}==nopath);
        regionmasks(:,:,f)=Getthemask(ucm2{f},allregionsframes{f}{region}.ll(1,1),allregionsframes{f}{region}.ll(1,2));
    end
    if (printonscreen)
        Printthevideoonscreen(regionmasks, printonscreen, 1);
    end

    for bk=1:noBtrajectories
        
        if ( (btrajectories{bk}.startFrame<=mtrajectories{k}.startFrame) && (btrajectories{bk}.endFrame>=mtrajectories{k}.endFrame) )
            
            btrajinsert=true;
%             fprintf('*');
            for aframe=mtrajectories{k}.startFrame:mtrajectories{k}.endFrame
                
                bpos=aframe-btrajectories{bk}.startFrame+1;
                thex=min(max( round(btrajectories{bk}.Xs(bpos)) ,1),dim(2));
                they=min(max( round(btrajectories{bk}.Ys(bpos)) ,1),dim(1));
                if ( ~ regionmasks(they,thex,aframe) )
                    btrajinsert=false;
                end
            end
            
            if (btrajinsert)
                touchingmatrix(bk,k)=true;
            end
        end
    end
end



allintersectks=cell(1,noMtrajectories);
for k=1:noMtrajectories
    allintersectks{k}=find(touchingmatrix(:,k))';
end
allintersectbks=cell(1,noBtrajectories);
for bk=1:noBtrajectories
    allintersectbks{bk}=find(touchingmatrix(bk,:));
end


coincideratio=0.5;
trajtomerge=false(noMtrajectories,noMtrajectories);
%trajtomerge(i,j)==true indicates that i and j need to be merged
for k=1:noMtrajectories
    
    intersectbks=allintersectks{k};
%     intersectbks=find(touchingmatrix(:,k));

%     if (numel(intersectbks)<=1)
%         continue;
%     end
    
    for bkcount=1:numel(intersectbks)
        
        bk=intersectbks(bkcount);
        intersectks=allintersectbks{bk};
%         intersectks=find(touchingmatrix(bk,:));
        
        
        for kincount=1:numel(intersectks)
            
            kin=intersectks(kincount);
            
            if (kin==k)
                continue;
            end
            
            if (  ( (mtrajectories{k}.startFrame-1)~=mtrajectories{kin}.endFrame )  &&...
                    ( (mtrajectories{kin}.startFrame-1)~=mtrajectories{k}.endFrame )  )
                continue;
            end
            
            intersectbksin=allintersectks{kin};
%             intersectbksin=find(touchingmatrix(:,kin));

%             if (numel(intersectbksin)<=1)
%                 continue;
%             end

            ratecoincide=Computeratecoincide(intersectbksin,intersectbks);
            %ratecoincide is the min of the two rate, so >0.5 ensures unique correspondences
            if (ratecoincide>coincideratio)
                trajtomerge(k,kin)=true;
                trajtomerge(kin,k)=true;
%                 fprintf('k %d (%d,%d), bk %d, kin %d (%d,%d), ratecoincide %f\n',k,...
%                     mtrajectories{k}.startFrame,mtrajectories{k}.endFrame,bk,kin,...
%                     mtrajectories{kin}.startFrame,mtrajectories{kin}.endFrame,ratecoincide);
            end
        end
    end
end

fprintf('Suggested merges %d (on %d)\n',sum(trajtomerge(:))/2,noMtrajectories);

%Check that no multiple merges are done (max merges for a trajectories are
%two: the two ends may be merged to other trajectories
where=find(sum(trajtomerge)>1);
for i=1:numel(where)
    k=where(i);
%     fprintf('the multiple %d, startFrame %d, endFrame %d\n',k,mtrajectories{k}.startFrame,mtrajectories{k}.endFrame);
    
    bestpostlength=0;
    bestpostk=0;
    bestprelength=0;
    bestprek=0;
    
    wheretouch=find(trajtomerge(k,:));
    for j=1:numel(wheretouch)
        
        kt=wheretouch(j);
%         fprintf('the multiple %d, startFrame %d, endFrame %d\n',kt,mtrajectories{kt}.startFrame,mtrajectories{kt}.endFrame);
        
        if ( (mtrajectories{k}.startFrame-1)==mtrajectories{kt}.endFrame ) %precase
            if ( mtrajectories{kt}.totalLength>bestprelength )
                if ( bestprelength>0 )
                    trajtomerge(k,bestprek)=false;
                    trajtomerge(bestprek,k)=false;
%                     fprintf('Eliminating merge with %d\n',bestprek);
                end
                bestprelength=mtrajectories{kt}.totalLength;
                bestprek=kt;
            else
                trajtomerge(k,kt)=false;
                trajtomerge(kt,k)=false;
%                 fprintf('Eliminating merge with %d\n',kt);
            end
        elseif ( (mtrajectories{kt}.startFrame-1)==mtrajectories{k}.endFrame ) %postcase
            if ( mtrajectories{kt}.totalLength>bestpostlength )
                if ( bestpostlength>0 )
                    trajtomerge(k,bestpostk)=false;
                    trajtomerge(bestpostk,k)=false;
%                     fprintf('Eliminating merge with %d\n',bestpostk);
                end
                bestpostlength=mtrajectories{kt}.totalLength;
                bestpostk=kt;
            else
                trajtomerge(k,kt)=false;
                trajtomerge(kt,k)=false;
%                 fprintf('Eliminating merge with %d\n',kt);
            end
        else
            fprintf('Unrecognised case\n');
        end
        
    end
end

fprintf('Suggested merges after eliminating repeated merges %d (on %d)\n',sum(trajtomerge(:))/2,noMtrajectories);


mmtrajectories=mtrajectories;
numberofmerges=sum(trajtomerge(:))/2;
mtouchingmatrix=touchingmatrix;
mmmapPathToTrajectory=mmapPathToTrajectory;
noMmtrajectories=noMtrajectories;
mallregionpaths=allregionpaths;
mtrajtomerge=trajtomerge;
showregionpaths=false; %if true, it shows parts of paths outside the 'trajectories'
for i=1:numberofmerges
    
    %the merge procedure proceeds from single-sided merges
    ktomerge=find(sum(mtrajtomerge)==1,1,'first');
    ktokeep=find(mtrajtomerge(ktomerge,:));
    
    if (printonscreen)
        fprintf('ktomerge %d (%d,%d), ktokeep %d (%d,%d)\n',ktomerge,...
            mmtrajectories{ktomerge}.startFrame,mmtrajectories{ktomerge}.endFrame,ktokeep,...
            mmtrajectories{ktokeep}.startFrame,mmtrajectories{ktokeep}.endFrame);
        Graphicregionpathsandtrajectories(ktomerge,ucm2,allregionsframes,mallregionpaths,mmtrajectories,cim,showregionpaths);
        Graphicregionpathsandtrajectories(ktokeep,ucm2,allregionsframes,mallregionpaths,mmtrajectories,cim,showregionpaths);
    end
    
    mtrajtomerge(ktomerge,:)=[];
    mtrajtomerge(:,ktomerge)=[];
    
    mmtrajectories{ktokeep}.totalLength=mmtrajectories{ktokeep}.totalLength+mmtrajectories{ktomerge}.totalLength;
    
    
    commontraj=find(mtouchingmatrix(:,ktokeep)&mtouchingmatrix(:,ktomerge),1,'first');

    if ( (mmtrajectories{ktokeep}.startFrame-1)==mmtrajectories{ktomerge}.endFrame ) %precase

        mmtrajectories{ktokeep}.startFrame=mmtrajectories{ktomerge}.startFrame;
        if (isempty(commontraj))
            mmtrajectories{ktokeep}.Xs=[mmtrajectories{ktomerge}.Xs,mmtrajectories{ktokeep}.Xs];
            mmtrajectories{ktokeep}.Ys=[mmtrajectories{ktomerge}.Ys,mmtrajectories{ktokeep}.Ys];
        end

    elseif ( (mmtrajectories{ktomerge}.startFrame-1)==mmtrajectories{ktokeep}.endFrame ) %postcase

        mmtrajectories{ktokeep}.endFrame=mmtrajectories{ktomerge}.endFrame;
        if (isempty(commontraj))
            mmtrajectories{ktokeep}.Xs=[mmtrajectories{ktokeep}.Xs,mmtrajectories{ktomerge}.Xs];
            mmtrajectories{ktokeep}.Ys=[mmtrajectories{ktokeep}.Ys,mmtrajectories{ktomerge}.Ys];
        end
        
    else
        fprintf('Unrecognised case\n');
        fprintf('ktomerge %d-%d (%d,%d), ktokeep %d-%d (%d,%d)\n',ktomerge,mmtrajectories{ktomerge}.nopath,...
            mmtrajectories{ktomerge}.startFrame,mmtrajectories{ktomerge}.endFrame,ktokeep,mmtrajectories{ktokeep}.nopath,...
            mmtrajectories{ktokeep}.startFrame,mmtrajectories{ktokeep}.endFrame);
%         Graphicregionpathsandtrajectories(ktomerge,ucm2,allregionsframes,mallregionpaths,mmtrajectories,cim,showregionpaths);
%         Graphicregionpathsandtrajectories(ktokeep,ucm2,allregionsframes,mallregionpaths,mmtrajectories,cim,showregionpaths);
    end

    if (~isempty(commontraj))
        for ff=mmtrajectories{ktokeep}.startFrame:mmtrajectories{ktokeep}.endFrame
            posmm=ff-mmtrajectories{ktokeep}.startFrame+1;
            posb=ff-btrajectories{commontraj}.startFrame+1;
            
            mmtrajectories{ktokeep}.Xs(posmm)=min(max( btrajectories{commontraj}.Xs(posb) ,1),dim(2));
            mmtrajectories{ktokeep}.Ys(posmm)=min(max( btrajectories{commontraj}.Ys(posb) ,1),dim(1));
        end
    end
    
    
    pathtomerge=mmtrajectories{ktomerge}.nopath;
    pathtokeep=mmtrajectories{ktokeep}.nopath;
    for f=mmtrajectories{ktomerge}.startFrame:mmtrajectories{ktomerge}.endFrame
        mallregionpaths.nopath{f}(mallregionpaths.nopath{f}==pathtomerge)=pathtokeep;
%         region=find(mallregionpaths.nopath{f}==pathtomerge);
%         mallregionpaths.nopath{f}(region)=pathtokeep;
%         regionmasks(:,:,f)=Getthemask(ucm2{f},allregionsframes{f}{region}.ll(1,1),allregionsframes{f}{region}.ll(1,2));
    end

    mallregionpaths.summedSimilarity(pathtokeep)=mallregionpaths.summedSimilarity(pathtokeep)+mallregionpaths.summedSimilarity(pathtomerge);
    mallregionpaths.totalLength(pathtokeep)=mmtrajectories{ktokeep}.totalLength;
    mallregionpaths.startPath(pathtokeep)=mmtrajectories{ktokeep}.startFrame;
    mallregionpaths.endPath(pathtokeep)=mmtrajectories{ktokeep}.endFrame;
    
    
    mtouchingmatrix(:,ktokeep)=mtouchingmatrix(:,ktokeep)&mtouchingmatrix(:,ktomerge);
    mtouchingmatrix(:,ktomerge)=[];
    
    mmmapPathToTrajectory(find(mmmapPathToTrajectory==ktomerge,1,'first'))=0;
    thosetochange=(mmmapPathToTrajectory>ktomerge);
    mmmapPathToTrajectory(thosetochange)=mmmapPathToTrajectory(thosetochange)-1;
    for kk=ktomerge:(noMmtrajectories-1)
        mmtrajectories{kk}=mmtrajectories{kk+1};
    end
    noMmtrajectories=noMmtrajectories-1;
    
    if (ktokeep>ktomerge)
        ktokeep=ktokeep-1;
    end
    
    if (printonscreen)
        Graphicregionpathsandtrajectories(ktokeep,ucm2,allregionsframes,mallregionpaths,mmtrajectories,cim,showregionpaths);
    end
end

mmtrajectories(noMmtrajectories+1:numel(mmtrajectories))=[];
mselectedtreetrajectories=true(1,numel(mmtrajectories));



%Output variables:
% selectedtreetrajectories=mselectedtreetrajectories;
% trajectories=mmtrajectories;
% mapPathToTrajectory=mmmapPathToTrajectory;
% allregionpaths=mallregionpaths;


function Otherfunctions(touchingmatrix,mtrajectories,btrajectories) %#ok<DEFNU>

bk=1;
k=find(touchingmatrix(bk,:),1,'first');
mtrajectories{k}.startFrame
mtrajectories{k}.endFrame
allks=find(touchingmatrix(bk,:));
for i=1:numel(allks)
    fprintf('traj %d, startFrame %d, endFrame %d\n',allks(i),mtrajectories{allks(i)}.startFrame,mtrajectories{allks(i)}.endFrame);
end

allbks=find(touchingmatrix(:,k));
for bi=1:numel(allbks)
    fprintf('btraj %d, startFrame %d, endFrame %d\n',allbks(bi),btrajectories{allbks(bi)}.startFrame,btrajectories{allbks(bi)}.endFrame);
end

bk=4739;
k=find(touchingmatrix(bk,:),1,'first');
allbks=find(touchingmatrix(:,k));
for bi=1:numel(allbks)
    bk=allbks(bi);
    allks=find(touchingmatrix(bk,:));
    fprintf('btraj %d, startFrame %d, endFrame %d\n',bk,btrajectories{bk}.startFrame,btrajectories{bk}.endFrame)
    for i=1:numel(allks)
        fprintf('   traj %d, startFrame %d, endFrame %d\n',allks(i),mtrajectories{allks(i)}.startFrame,mtrajectories{allks(i)}.endFrame);
        thoseink=find(touchingmatrix(:,allks(i)));
        fprintf('      (');fprintf(' %d',thoseink);fprintf(' )\n');
    end
end



bk=1;
allintks=find(touchingmatrix(bk,:));
for ii=1:numel(allintks)
    k=allintks(ii);
    fprintf('traj %d\n',k);
    allbks=find(touchingmatrix(:,k));
    for bi=1:numel(allbks)
        bk=allbks(bi);
        allks=find(touchingmatrix(bk,:));
        fprintf('   btraj %d, startFrame %d, endFrame %d\n',bk,btrajectories{bk}.startFrame,btrajectories{bk}.endFrame)
        for i=1:numel(allks)
            fprintf('      traj %d, startFrame %d, endFrame %d\n',allks(i),mtrajectories{allks(i)}.startFrame,mtrajectories{allks(i)}.endFrame);
        end
    end
end







function XYAffiliation(btrajectories,trajectories) %#ok<DEFNU>

mxmax=-Inf;
mymax=-Inf;
for k=1:numel(btrajectories)
    mx=max(btrajectories{k}.Xs);
    my=max(btrajectories{k}.Ys);
    if (mx>mxmax)
        mxmax=mx;
    end
    if (my>mymax)
        mymax=my;
    end
end
fprintf('btrajectories: max X= %f, max Y= %f\n',mxmax,mymax);

mxmax=-Inf;
mymax=-Inf;
for k=1:numel(trajectories)
    mx=max(trajectories{k}.Xs);
    my=max(trajectories{k}.Ys);
    if (mx>mxmax)
        mxmax=mx;
    end
    if (my>mymax)
        mymax=my;
    end
end
fprintf('trajectories: max X= %f, max Y= %f\n',mxmax,mymax);
