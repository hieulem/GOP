function [precision,recall,averageprecision,averagerecall,numberoftrajectories,meanlength,stdlength,allprecisepixels,allrecalledpixels,totalobjectpixels,density,coveredpixels,totpixels,noallobjects,totallengths,totalsquaredlength,fmeasures]=...
    Getquantitativemeasurementjustlabels(filename_sequence_basename_frames_or_video,labelledvideo,mintracklength,...
    videocorrectionparameters,noFrames,includebackground,printonscreen,framesforevaluation,fframe)
%The function measure the maximum achievable precision and recall, global
%and averaged over objects
%The estimation does not include the background by default

%framesforevaluation=[]; _defined according to the first frame
% framesforevaluation=framestoconsider;



%Prepare the input
if ( (~exist('noFrames','var')) || (isempty(noFrames)) )
    noFrames=size(labelledvideo,3);
end
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



%Read the ground truth video sequence or the frames
printonscreeninsidefunction=false;
[gtimages,valid,nfigure]=Readpictureseries(filename_sequence_basename_frames_or_video.gtbasename,...
    filename_sequence_basename_frames_or_video.gtnumber_format,filename_sequence_basename_frames_or_video.gtclosure,...
    filename_sequence_basename_frames_or_video.gtstartNumber,noFrames,printonscreeninsidefunction);
if (printonscreeninsidefunction)
    close(nfigure);
end

%verify whether the gtimages dir only contain a single gt
singlegt=false;
for i=1:numel(gtimages)
    singlegt= singlegt | (~isempty(gtimages{i})) ;
end

%read multiple gt (in case of single gt was not read)
if (~singlegt)
    ntoreadmgt=1; %1,Inf
    
    [multgts,valid,nfigure]=Readmultipleannotations(filename_sequence_basename_frames_or_video,noFrames,ntoreadmgt,printonscreeninsidefunction);
    gtimages=multgts{1};
end
if (printonscreeninsidefunction)
    close(nfigure);
end

%Limit max frame for gt (impose same test set)
maxgtframes=Inf;
for f=(maxgtframes+1):numel(gtimages)
    gtimages{f}=[];
end

%verify that at least a gt image is present
gtfound=false;
for i=1:numel(gtimages)
    gtfound= gtfound | (~isempty(gtimages{i})) ;
end
if (~gtfound)
    precision=[];recall=[];averageprecision=[];averagerecall=[];numberoftrajectories=[];meanlength=[];stdlength=[];allprecisepixels=[];allrecalledpixels=[];totalobjectpixels=[];density=[];coveredpixels=[];totpixels=[];noallobjects=[];totallengths=[];totalsquaredlength=[];fmeasures=[];
    return;
end

%Define bgcode and mbcode if not defined (original gtimages are used)
if ( (~isfield(filename_sequence_basename_frames_or_video,'bgcode')) || (~isfield(filename_sequence_basename_frames_or_video,'mbcode')) )
    allthecodes=[];
    for i=1:numel(gtimages)
        if (isempty(gtimages{i}))
            continue;
        end
        if (size(gtimages{i},3)>1)
            gtimageforunique=[reshape(gtimages{i}(:,:,1),[],1),reshape(gtimages{i}(:,:,2),[],1),reshape(gtimages{i}(:,:,3),[],1)];
        else
            gtimageforunique=reshape(gtimages{i}(:,:,1),[],1);
        end
        allthecodes=[allthecodes;unique(gtimageforunique,'rows')]; %#ok<AGROW>
    end
    allthecodes=unique(allthecodes,'rows');
    bgcode=allthecodes(1,:);
    if (size(allthecodes,1)>1)
        mbcode=allthecodes(2:end,:);
    else
        mbcode=[];
    end
else
    bgcode=filename_sequence_basename_frames_or_video.bgcode; %[0,0,0] or 0
    mbcode=filename_sequence_basename_frames_or_video.mbcode; %[192,0,255;192,192,192] or [192;255]
end

%Adjust image size
[gtimages,nfigure]=Adjustimagesize(gtimages,videocorrectionparameters,printonscreeninsidefunction,true);
if (printonscreeninsidefunction)
    close(nfigure);
end

allcode=double([bgcode;mbcode]);
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



[precision,recall,averageprecision,averagerecall,density,meanlength,stdlength,...
    allprecisepixels,allrecalledpixels,totalobjectpixels,coveredpixels,totpixels,numberoftrajectories,totallengths,totalsquaredlength,fmeasures]=...
    Getallprecisionrecallcounts(labelledvideo,gtmasks,validobjectmasks,includebackground,noallobjects,mintracklength,framesforevaluation,noFrames,textallobjects);
%precisionperobject(i)=allprecisepixels(i)/allrecalledpixels(i);
%recallperobject(i)=allprecisepixels(i)/totalobjectpixels(i);
%precision and recall: global values, ratio of sum of all pixels
%averageprecision and averagerecall: averages of per object precision and recall
%allprecisepixels,allrecalledpixels,totalobjectpixels: for each object,
%correctly classified pixels, number pixels per test label, number pixels per ground truth label
%density is the number of video pixels assigned to a valid label on the total number of pixels

    




function coverindexmintracklength=Otherfunctions(labelledvideo,trajectories)

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


