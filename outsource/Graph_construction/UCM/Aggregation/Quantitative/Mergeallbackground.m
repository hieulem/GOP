function [labelledvideo,labelsmerged]=Mergeallbackground(gtimages,filename_sequence_basename_frames_or_video,...
    labelledvideo,printonscreen,framesforevaluation,fframe)

%The function merges all background labels, where background labels are
%determined by the available ground truth images

%framesforevaluation=[]; _defined according to the first frame

labelsmerged=[];
nomerged=0;

noFrames=size(labelledvideo,3);

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



% bgcode=[0,0,0] or 0;
% mbcode=[192,0,255;192,192,192] or [192;255];
if ( (~isfield(filename_sequence_basename_frames_or_video,'bgcode')) || (~isfield(filename_sequence_basename_frames_or_video,'mbcode')) )
    fprintf('Please define the background and moving body codes\n');
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

imagesize=size(labelledvideo);
imagesizetwo=imagesize(1:2);

nomaxframes=max(framesforevaluation);


gtmasks=false(imagesizetwo(1),imagesizetwo(2),nomaxframes,noallobjects);
validobjectmasks=false(nomaxframes,noallobjects);
for frame=framesforevaluation
    if (isempty(gtimages{frame}))
        continue;
    end
    for i=1:noallobjects
        if (numel(size(gtimages{frame}))>2)
            tmpmask=cat(3,ones(imagesizetwo).*allcode(i,1),ones(imagesizetwo).*allcode(i,2),ones(imagesizetwo).*allcode(i,3));
            gtmasks(:,:,frame,i)=all(gtimages{frame}==tmpmask,3);
        else
            tmpmask=ones(imagesizetwo).*allcode(i);
            gtmasks(:,:,frame,i)=(gtimages{frame}==tmpmask);
        end
        if (any(any(gtmasks(:,:,frame,i)))) %this identifies masks where the objects occur
            validobjectmasks(frame,i)=true;
            if (printonscreen)
                Init_figure_no(1);
                imshow(squeeze(gtmasks(:,:,frame,i)));
                title(['Frame ',num2str(frame),' - code ',textallobjects{i}]);
                pause(0.1);
            end
        end
    end
end



trackmask=false(size(labelledvideo));
for thelabel=unique(labelledvideo)'
    if (thelabel==0)
        continue; %0 means not label, it does not mean background
    end
    
    trackmask= (labelledvideo==thelabel);
    therange=find( any(any(trackmask,1),2) )';

    newrange=therange;
    for rr=therange
        if (~any(framesforevaluation==rr))
            newrange(newrange==rr)=[];
            trackmask(:,:,rr)=false;
        end
    end

    
    pixelsperobject=zeros(1,noallobjects);
    for i=1:noallobjects
        objecttrackmask=trackmask(:,:,validobjectmasks(:,i));
        objecttruepixels=gtmasks(:,:,validobjectmasks(:,i),i);
        
        pixelsperobject(i)=sum(objecttruepixels(objecttrackmask)); %indexing is equivalent to logical AND
    end
    
    [precisepixels,chosenobject]=max(pixelsperobject);
    
    if (chosenobject==1) %if the label belongs to the background
        nomerged=nomerged+1;
        labelsmerged(nomerged)=thelabel;
    end

    
end

for i=2:numel(labelsmerged)
    labelledvideo(labelledvideo==labelsmerged(i))=labelsmerged(1);
end

Printthevideoonscreen(labelledvideo, printonscreen, 1);
