function [multgts,gtfound,nonemptygt,numbernonempty]=Loadmultgtimagevideo(noFrames,filename_sequence_basename_frames_or_video,ntoreadmgt,maxgtframes,printonscreen)

if ( (~exist('maxgtframes','var')) || (isempty(maxgtframes)) )
    maxgtframes=Inf; %Limit max frame for gt (impose same test set)
end
if ( (~exist('ntoreadmgt','var')) || (isempty(ntoreadmgt)) )
    ntoreadmgt=Inf; %1, 2, .. Inf number of gts to read
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end



%Read the ground truth video sequence or the frames
[gtimages,valid,nfigure]=Readpictureseries(filename_sequence_basename_frames_or_video.gtbasename,...
    filename_sequence_basename_frames_or_video.gtnumber_format,filename_sequence_basename_frames_or_video.gtclosure,...
    filename_sequence_basename_frames_or_video.gtstartNumber,noFrames,printonscreen); %#ok<ASGLU>
if (printonscreen)
    close(nfigure);
end


%verify whether the gtimages dir only contain a single gt
singlegt=false;
for i=1:numel(gtimages)
    singlegt= singlegt | (~isempty(gtimages{i})) ;
end


%read multiple gt (in case of single gt was not read)
if (~singlegt)
    [multgts,valid,nfigure]=Readmultipleannotations(filename_sequence_basename_frames_or_video,noFrames,ntoreadmgt,printonscreen); %#ok<ASGLU>
else
    multgts=cell(1); multgts{1}=gtimages;
end
if (printonscreen)
    close(nfigure);
end

numbergts=numel(multgts);


%verify that at least a gt image is present
gtfound=false;
for gti=1:numbergts
    for i=1:numel(multgts{gti})
        gtfound= gtfound | (~isempty(multgts{gti}{i})) ;
    end
end
if (~gtfound)
    multgts=[];nonemptygt=[];numbernonempty=[];
    return;
end


%Limit max frame for gt (impose same test set)
for gti=1:numbergts
    for f=(maxgtframes+1):numel(multgts{gti})
        multgts{gti}{f}=[];
    end
end

%Identify the existing ground truth
nonemptygt=false(numbergts,noFrames);
for i=1:numbergts
    for f=1:numel(multgts{i})
        if (~isempty(multgts{i}{f}))
            nonemptygt(i,f)=true;
        end
    end
end
numbernonempty=sum(any(nonemptygt,1)); %maximum number of non empty gt images
