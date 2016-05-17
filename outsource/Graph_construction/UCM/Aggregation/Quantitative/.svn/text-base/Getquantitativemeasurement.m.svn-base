function [precision,recall,averageprecision,averagerecall]=...
    Getquantitativemeasurement(gtimages,filename_sequence_basename_frames_or_video,trajectories,labelledvideo,mintracklength,...
    printonscreen,framesforevaluation,fframe,includebackground)
%The function measure the maximum achievable precision and recall, global
%and averaged over objects
%The estimation does not include the background by default

%framesforevaluation=[]; _defined according to the first frame

noFrames=numel(gtimages);
noTracks=numel(trajectories);

if ( (~exist('mintracklength','var')) || (isempty(mintracklength)) )
    mintracklength=5;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('framesforevaluation','var')) || (isempty(framesforevaluation)) )
    framesforevaluation=1:noFrames;
end
if (numel(framesforevaluation)==1) %This means that at least two frames must be requested if fframe is not empty
    if ( (exist('fframe','var')) && (~isempty(fframe)) )
        framesforevaluation=fframe:fframe+framesforevaluation-1;
    end
end
if (any(framesforevaluation>noFrames))
    framesforevaluation=framesforevaluation(framesforevaluation<=noFrames);
end
if ( (~exist('includebackground','var')) || (isempty(includebackground)) )
    includebackground=false; %by default background is not included in calculations
end



% bgcode=[0,0,0] or 0;
% mbcode=[192,0,255;192,192,192] or [192;255];
if ( (~isfield(filename_sequence_basename_frames_or_video,'bgcode')) || (~isfield(filename_sequence_basename_frames_or_video,'mbcode')) )
    fprintf('Please define the background and moving body codes\n');
    precision=0;recall=0;averageprecision=0;averagerecall=0;
    return;
end
bgcode=filename_sequence_basename_frames_or_video.bgcode;
mbcode=filename_sequence_basename_frames_or_video.mbcode;

allcode=[bgcode;mbcode];
noallobjects=size(allcode,1);
textallobjects=cell(1,noallobjects);
textallobjects{1}='Background';
for i=2:noallobjects
    textallobjects{i}=['Object ',num2str(i-1)];
end

[firstnonempty,firstisvalid]=Getfirstgtnonempty(gtimages,framesforevaluation,noFrames);
if (~firstisvalid)
    precision=0;recall=0;averageprecision=0;averagerecall=0;
    return;
end
imagesize=size(gtimages{firstnonempty});
imagesizetwo=imagesize(1:2);

nomaxframes=max(framesforevaluation);



%Compute gtmasks by using allcode
[gtmasks,validobjectmasks]=Gtmasksfromallcodes(gtimages,imagesizetwo,nomaxframes,noallobjects,allcode,framesforevaluation,noFrames,printonscreen,textallobjects);



%From trajectories to newlabelledvideo
alllabels=zeros(1,noTracks);
for traj=1:noTracks
    alllabels(traj)=trajectories{traj}.label;
end

if (numel(unique(alllabels))~=noTracks)
    fprintf('\nLabels are repeated (Getquantitativemeasurement.m)\n\n');
    precision=0;
    recall=0;
    averageprecision=0;
    averagerecall=0;
    return;
end

%Transformation trajectories to labelledvideo
newlabelledvideo=zeros(size(labelledvideo));
for traj=1:noTracks
    range=trajectories{traj}.startFrame:trajectories{traj}.endFrame;
    themask=false(size(labelledvideo));
    themask(:,:,range)= ( labelledvideo(:,:,range) == trajectories{traj}.label );
    newlabelledvideo(themask)= trajectories{traj}.label;
end
% Printthevideoonscreen(newlabelledvideo,1,1,1)



[precision,recall,averageprecision,averagerecall,density,meanlength,stdlength]=...
    Getallprecisionrecallcounts(newlabelledvideo,gtmasks,validobjectmasks,includebackground,noallobjects,mintracklength,framesforevaluation,noFrames,textallobjects);
    %output: ,allprecisepixels,allrecalledpixels,totalobjectpixels,coveredpixels,totpixels,numberoftrajectories
%precisionperobject(i)=allprecisepixels(i)/allrecalledpixels(i);
%recallperobject(i)=allprecisepixels(i)/totalobjectpixels(i);
%precision and recall: global values, ratio of sum of all pixels
%averageprecision and averagerecall: averages of per object precision and recall
%allprecisepixels,allrecalledpixels,totalobjectpixels: for each object,
%correctly classified pixels, number pixels per test label, number pixels per ground truth label
%density is the number of video pixels assigned to a valid label on the total number of pixels






function trajectories=Fromlabelledvideototrajectories(labelledvideo) %#ok<DEFNU>


uniquelabels=unique(labelledvideo);
numberoftrajectories=numel(uniquelabels);

trajectories=cell(1,numberoftrajectories);
for traj=1:numberoftrajectories
    trajectories{traj}.label=uniquelabels(traj);
    trajectories{traj}.startFrame=find( any(any(labelledvideo==trajectories{traj}.label,1),2) , 1 , 'first');
    trajectories{traj}.endFrame=find( any(any(labelledvideo==trajectories{traj}.label,1),2) , 1 , 'last');
end


function [precision,recall,averageprecision,averagerecall]=...
    Otherparts_backup_notcommonfunctions(trajectories,labelledvideo,validobjectmasks,gtmasks,textallobjects) %#ok<DEFNU>


totalobjectpixels=zeros(1,noallobjects);
for i=1:noallobjects
    totalobjectpixels(i)=sum(sum(sum(  gtmasks(:, :, validobjectmasks(:,i) , i)  )));
end



allprecisepixels=zeros(1,noallobjects);
allrecalledpixels=zeros(1,noallobjects);
for traj=1:noTracks
    trackmask=false(size(labelledvideo));
    if (trajectories{traj}.totalLength>=mintracklength)
        therange=trajectories{traj}.startFrame:trajectories{traj}.endFrame;

        newrange=therange;
        for rr=therange
            if (~any(framesforevaluation==rr))
                newrange(newrange==rr)=[];
            end
        end
        therange=newrange; clear newrange;


        trackmask(:,:,therange)= (labelledvideo(:,:,therange)==trajectories{traj}.label);
    end
    
    pixelsperobject=zeros(1,noallobjects);
    for i=1:noallobjects
        objecttrackmask=trackmask(:,:,validobjectmasks(:,i));
        objecttruepixels=gtmasks(:,:,validobjectmasks(:,i),i);
        
        pixelsperobject(i)=sum(objecttruepixels(objecttrackmask)); %indexing is equivalent to logical AND
    end
    
    [precisepixels,chosenobject]=max(pixelsperobject);
    
    objecttrackmask=trackmask(:,:,validobjectmasks(:,chosenobject));
    totalrecalledpixels=sum(objecttrackmask(:));
    %precisepixels/totalrecalledpixels is precision
    %sum of precisepixels on sum of objecttrupixels is recall
    
    allprecisepixels(chosenobject)=allprecisepixels(chosenobject)+precisepixels;
    allrecalledpixels(chosenobject)=allrecalledpixels(chosenobject)+totalrecalledpixels;
    
end

precisionperobject=zeros(1,noallobjects);
recallperobject=zeros(1,noallobjects);
for i=1:noallobjects
    if (allrecalledpixels(i)>0)
        precisionperobject(i)=allprecisepixels(i)/allrecalledpixels(i);
    else
        precisionperobject(i)=0;
        fprintf('Could not compute precision for %s\n',textallobjects{i});
    end
    if (totalobjectpixels(i)>0)
        recallperobject(i)=allprecisepixels(i)/totalobjectpixels(i);
    else
        recallperobject(i)=0;
        fprintf('Could not compute recall for %s\n',textallobjects{i});
    end
end

if (includebackground) %#1 position is for the background
    firstobject=1;
else
    firstobject=2;
end

averageprecision=mean(precisionperobject(firstobject:end)); %(2:end) does not include background
averagerecall=mean(recallperobject(firstobject:end)); %(2:end) does not include background
% averageprecision=mean(precisionperobject);
% averagerecall=mean(recallperobject);

if (sum(allrecalledpixels(firstobject:end))>0) %(2:end) does not include background
    precision=sum(allprecisepixels(firstobject:end))/sum(allrecalledpixels(firstobject:end));
else
    precision=0;
    fprintf('Could not compute precision\n');
end
if (sum(totalobjectpixels(firstobject:end))>0) %(2:end) does not include background
    recall=sum(allprecisepixels(firstobject:end))/sum(totalobjectpixels(firstobject:end));
else
    recall=0;
    fprintf('Could not compute recall\n');
end



function coverindexmintracklength=Otherfunctions(labelledvideo,trajectories) %#ok<DEFNU>

%Measure region cover with mintracklength
mintracklength=5;

regioncover=false(size(labelledvideo));
for traj=1:noTracks
    if (trajectories{traj}.totalLength>=mintracklength)
        therange=trajectories{traj}.startFrame:trajectories{traj}.endFrame;
        regioncover(:,:,therange)= regioncover(:,:,therange) | (labelledvideo(:,:,therange)==trajectories{traj}.label);
    end
end
coverindexmintracklength=sum(regioncover(:));


