function labelsgt=Labelsfromgt(filename_sequence_basename_frames_or_video,mapped,ucm2,...
        videocorrectionparameters,printonscreen)
%The function assigns the labels according to ground truth
%Zero labels correspond to unlabelled superpixels

USEFMEASURE=true;

%Prepare the input
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
noFrames=numel(ucm2);
framesforevaluation=1:noFrames;
mintracklength=1;



%Read the ground truth video sequence or the frames
printonscreeninsidefunction=false;
gtimages=Readpictureseries(filename_sequence_basename_frames_or_video.gtbasename,...
    filename_sequence_basename_frames_or_video.gtnumber_format,filename_sequence_basename_frames_or_video.gtclosure,...
    filename_sequence_basename_frames_or_video.gtstartNumber,noFrames,printonscreeninsidefunction);
gtimages=Adjustimagesize(gtimages,videocorrectionparameters,printonscreeninsidefunction,true);
if (printonscreeninsidefunction)
    close all;
end



Level=1;
numberofelements=sum(sum(mapped>0));
labelsfc=zeros(numberofelements,1);
labelsfc(:)=1:numberofelements;
labelledvideo=Labelclusteredvideointerestframes(mapped,labelsfc,ucm2,Level,[],printonscreen);



% bgcode=[0,0,0] or 0;
% mbcode=[192,0,255;192,192,192] or [192;255];
if ( (~isfield(filename_sequence_basename_frames_or_video,'bgcode')) || (~isfield(filename_sequence_basename_frames_or_video,'mbcode')) )
    fprintf('Please define the background and moving body codes\n');
    labelsgt=[];
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

firstnonempty=0;
for frame=framesforevaluation
    if (isempty(gtimages{frame}))
        continue;
    else
        firstnonempty=frame;
        break;
    end
end
if (firstnonempty==0)
    labelsgt=[];
    return;
end
imagesize=size(gtimages{firstnonempty});
imagesizetwo=imagesize(1:2);

nomaxframes=max(framesforevaluation);



[gtmasks,validobjectmasks]=Gtmasksfromallcodes(gtimages,imagesizetwo,nomaxframes,noallobjects,allcode,framesforevaluation,noFrames,printonscreen,textallobjects);



totalobjectpixels=zeros(1,noallobjects);
for i=1:noallobjects
    totalobjectpixels(i)=sum(sum(sum(  gtmasks(:, :, validobjectmasks(:,i) , i)  )));
end


uniquelabels=unique(labelledvideo);
framebelong=Getmappedframes(mapped); %[,labelsatframe,numberofelements]


labelsgt=zeros(size(labelsfc));
labelledatframeinuse=NaN;
gtatframeinuse=zeros(1,noallobjects); gtatframeinuse(:)=NaN;
gtattheframe=cell(1,noallobjects); for nob=1:noallobjects, gtattheframe{nob}=zeros(size(labelledvideo,1),size(labelledvideo,2)); end;
for label=uniquelabels'
    theframe=framebelong(label);
    
    if ( (~any(framesforevaluation==theframe)) || (~any(validobjectmasks(theframe,:))) )
        continue;
    end
    
    
    
    if (theframe~=labelledatframeinuse)
        labelledatframe=labelledvideo(:,:,theframe);
        labelledatframeinuse=theframe;
    end
    trackmaskimage=(labelledatframe==label); %size(trackmaskimage), Printthevideoonscreen(trackmaskimage,1,1)
    
    
    
    overlappedpixelsforallobject=zeros(1,noallobjects);
    fmeasureforallobjects=zeros(1,noallobjects);
    recalledpixelsforalllabels=zeros(1,noallobjects);
    for i=1:noallobjects
        if (validobjectmasks(theframe,i))
            if (theframe~=gtatframeinuse(i))
                gtattheframe{i}=gtmasks(:,:,theframe,i);
                gtatframeinuse(i)=theframe;
            end
            recalledpixelsforalllabels(i)=sum(trackmaskimage(:));
            overlappedpixelsforallobject(i)=sum(trackmaskimage(gtattheframe{i})); %indexing is equivalent to logical AND
            fmeasureforallobjects(i)=2*overlappedpixelsforallobject(i)/(recalledpixelsforalllabels(i)+totalobjectpixels(i)); %F-measures for the objects
        end
    end
    
    if (USEFMEASURE)
        %Choose objects according max F-measure
        [themeasurebest,thechosenobject]=max(fmeasureforallobjects);
        if (themeasurebest>0) %unassigned labels are left zero
            labelsgt(label)=thechosenobject;
        end
    else
        %Choose objects according to max overlapping pixels
        [themeasurebest,thechosenobject]=max(overlappedpixelsforallobject);
        if (themeasurebest>0) %unassigned labels are left zero
            labelsgt(label)=thechosenobject;
        end
    end
    
end

if (printonscreen)
    labelledvideo=Labelclusteredvideointerestframes(mapped,labelsgt,ucm2,Level,[],printonscreen);
    %Printthevideoonscreen(labelledvideo, printonscreen, 6, printonscreen);
end










