function [labelledgtvideo,nonemptygt,numberofobjects,numbernonempty]=Getmultgtlabvideo(noFrames,filename_sequence_basename_frames_or_video,videocorrectionparameters,ntoreadmgt,maxgtframes,printonscreen)
% [labelledgtvideo,nonemptygt,numberofobjects,numbernonempty]=Getmultgtlabvideo(noFrames,filename_sequence_basename_frames_or_video,videocorrectionparameters,Inf,Inf,printonscreen);
%labelledgtvideo{ which gt annotation , which frame } = dimIi x dimIj double (the labels, 0 others, -1 neglect)

if ( (~exist('ntoreadmgt','var')) || (isempty(ntoreadmgt)) )
    ntoreadmgt=Inf; %1, 2, .. Inf number of gts to read
end
if ( (~exist('maxgtframes','var')) || (isempty(maxgtframes)) )
    maxgtframes=Inf; %Limit max frame for gt (impose same test set)
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

%Prepare parameters
printonscreeninsidefunction=false;



%Read the single of mutliple gt annotations
[multgts,gtfound,nonemptygt,numbernonempty]=Loadmultgtimagevideo(noFrames,filename_sequence_basename_frames_or_video,ntoreadmgt,maxgtframes,printonscreeninsidefunction);
%multgts{which gt annotation}{which frame}= dimIi x dimIj [ x 3 colors] uint8

%verify that at least a gt image is present
if (~gtfound)
    labelledgtvideo=[];nonemptygt=[];numberofobjects=[];numbernonempty=[];
    return;
end

numbergts=numel(multgts);



%Define bgcode and mbcode if not defined (multgts are used if not defined)
allthecodes=cell(1,numbergts);
numberofobjects=zeros(numbergts,1);
if ( (~isfield(filename_sequence_basename_frames_or_video,'bgcode')) || (~isfield(filename_sequence_basename_frames_or_video,'mbcode')) )
    for mid=1:numbergts
        allmidcodes=[];
        for i=1:numel(multgts{mid})
            if (isempty(multgts{mid}{i}))
                continue;
            end
            if (size(multgts{mid}{i},3)>1)
                gtimageforunique=[reshape(multgts{mid}{i}(:,:,1),[],1),reshape(multgts{mid}{i}(:,:,2),[],1),reshape(multgts{mid}{i}(:,:,3),[],1)];
            else
                %error('tmp gt num %d frame %d', mid,i); %assertion for debugging
                gtimageforunique=reshape(multgts{mid}{i}(:,:,1),[],1);
            end
            allmidcodes=[allmidcodes;unique(gtimageforunique,'rows')]; %#ok<AGROW>
        end
        allthecodes{mid}=unique(allmidcodes,'rows');
        %allthecodes{mid} %print for debugging
        
        numberofobjects(mid)=size(allthecodes{mid},1);
    end
else
    for mid=1:numbergts
        allthecodes{mid}=[ filename_sequence_basename_frames_or_video.bgcode;... %[0,0,0] or 0
            filename_sequence_basename_frames_or_video.mbcode ]; %[192,0,255;192,192,192] or [192;255]
        
        numberofobjects(mid)=size(allthecodes{mid},1);
   end
end


%Adjust image size
for i=1:numbergts
    [multgts{i},nfigure]=Adjustimagesize(multgts{i},videocorrectionparameters,printonscreeninsidefunction,true);
end
if (printonscreeninsidefunction)
    close(nfigure);
end

%Visualization of multgts
if (printonscreen)
    Init_figure_no(10)
    for i=1:numbergts
        for f=1:numel(multgts{i})
            agtimage=multgts{i}{f};
            if (~isempty(agtimage))
                imshow(agtimage);
            end
            pause(0.1);
        end
    end
end

%Video sizes
[firstnonemptymid,firstnonemptyfid]=find(nonemptygt,1,'first');
dimi=size(multgts{firstnonemptymid}{firstnonemptyfid},1);
dimj=size(multgts{firstnonemptymid}{firstnonemptyfid},2);
% colornumber=size(multgts{firstnonemptymid}{firstnonemptyfid},3);
% numberofpixels=dimi*dimj;

%Recolor gt images according to the labels in allthecodes
labelledgtvideo=cell(numbergts,noFrames);
%the variable was before only containing only valid gts, it is now the same
%size as noFrames with empties when no gt is available. This should also
%reflect in the other functions of Addcurrentimageforrp
for mid=1:numbergts
    for i=1:numel(multgts{mid})
        if (~nonemptygt(mid,i)) %(isempty(multgts{mid}{i}))
            continue;
        end
        
        %Init labelled GT to ignore label (-1)
        labelledgtvideo{mid,i}=zeros(dimi,dimj);
        
        %Replace ignore labels according to colors in allthecodes{mid}
        if (size(multgts{mid}{i},3)>1)
            %All colors from the ground truth are arranged into a column so as to run matlab unique command
            gtimageforunique=[reshape(multgts{mid}{i}(:,:,1),[],1),reshape(multgts{mid}{i}(:,:,2),[],1),reshape(multgts{mid}{i}(:,:,3),[],1)];
        else
            gtimageforunique=reshape(multgts{mid}{i}(:,:,1),[],1);
        end
        [listofcolors,tmp,thenewrow] = unique(gtimageforunique,'rows'); %#ok<ASGLU>
        
        listoflabels=ones(size(listofcolors,1),1).*(-1);
        for lc=1:size(listofcolors,1)
            r=find( all( repmat(listofcolors(lc,:),size(allthecodes{mid},1),1) == allthecodes{mid} , 2 ) );
            if (~isempty(r))
                listoflabels(lc)=r;
            end
        end
        labelledgtvideo{mid,i}(:)=listoflabels(thenewrow);
        
        if (printonscreeninsidefunction)
            if (size(allthecodes{mid},1)>1)
                Init_figure_no(10), imagesc(labelledgtvideo{mid,i},[-1,size(allthecodes{mid},1)]), drawnow;
            end
        end
    end
%     if (printonscreeninsidefunction)
%         Printthevideoonscreen(labelledgtvideo(mid,:), printonscreeninsidefunction, 10, false, true,[],[]);
%     end
end
if (printonscreeninsidefunction)
    close(10);
end











