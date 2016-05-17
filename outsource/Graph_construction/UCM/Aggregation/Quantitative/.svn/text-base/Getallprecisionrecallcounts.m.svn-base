function [precision,recall,averageprecision,averagerecall,density,meanlength,stdlength,...
    allprecisepixels,allrecalledpixels,totalobjectpixels,coveredpixels,totpixels,numberoftrajectories,totallengths,totalsquaredlength,fmeasures]=...
    Getallprecisionrecallcounts(labelledvideo,gtmasks,validobjectmasks,includebackground,noallobjects,mintracklength,framesforevaluation,noFrames,textallobjects)
%labelledvideo may be a video or a single image
%precisionperobject(i)=allprecisepixels(i)/allrecalledpixels(i);
%recallperobject(i)=allprecisepixels(i)/totalobjectpixels(i);
%precision and recall: global values, ratio of sum of all pixels
%averageprecision and averagerecall: averages of per object precision and recall
%allprecisepixels,allrecalledpixels,totalobjectpixels: for each object,
%correctly classified pixels, number pixels per test label, number pixels per ground truth label
%density is the number of video pixels assigned to a valid label (coveredpixels) on the total number of pixels (totpixels)
%totallengths,totalsquaredlength are for computing mean and std lengths
%values outliers (-10) are considered in the evaluation



%Cases of single images
% labelledvideo=squeeze(labelledvideo(:,:,1));
% gtmasks=gtmasks(:,:,1,:);
% validobjectmasks=validobjectmasks(1,:);
% size(labelledvideo) =[150   250] (dimIi dimIj)
% size(gtmasks) =[150   250     1     3] (dimIi dimIj noFrames noObjects)
% size(validobjectmasks) =[1     3] (noFrames noObjects)

% labelledvideo=Labelclusteredvideointerestframes(mapped,labelsgt,ucm2,Level,[],printonscreen);

%Prepare the input
if ( (~exist('noallobjects','var')) || (isempty(noallobjects)) )
    noallobjects=size(gtmasks,4);
end
if ( (~exist('mintracklength','var')) || (isempty(mintracklength)) )
    mintracklength=1;
end
if ( (~exist('noFrames','var')) || (isempty(noFrames)) )
    noFrames=size(labelledvideo,3);
end
if ( (~exist('framesforevaluation','var')) || (isempty(framesforevaluation)) )
    framesforevaluation=1:noFrames;
end
if ( (~exist('includebackground','var')) || (isempty(includebackground)) )
    includebackground=false; %by default background is not included in calculations
end
if ( (~exist('textallobjects','var')) || (isempty(includebackground)) || (~iscell(textallobjects)) )
    textallobjects=cell(1,noallobjects);
    for id=1:noallobjects
        textallobjects{id}=['id',num2str(id)];
    end
end



%total number of pixels for each ground truth object
totalobjectpixels=zeros(1,noallobjects);
for i=1:noallobjects
    totalobjectpixels(i)=sum(sum(sum(  gtmasks(:, :, validobjectmasks(:,i) , i)  )));
end



%number and id of objects identified in the video/image
uniquelabels=unique(labelledvideo);

outmzero=find(uniquelabels<0);
if (~isempty(outmzero))
    uniquelabels(outmzero)=[]; %so the outliers -10 are not considered among the assigned
end
if (any(uniquelabels==0))
    fprintf('\n\nSome labels others (0) are also present in the labelledvideo, not removed\n\n\n');
end

numberoftrajectories=numel(uniquelabels);



%main part: each computed object is assigned to the ground truth object
%which superposes the largest number of pixels
%allprecisepixels: number of pixels correctly classified as ground truth object
%allrecalledpixels: number of pixels for the label (including correctly and non correctly classified)
%
%precisionperobject(i)=allprecisepixels(i)/allrecalledpixels(i);
%recallperobject(i)=allprecisepixels(i)/totalobjectpixels(i);
totallengths=0;
totalsquaredlength=0;
allprecisepixels=zeros(1,noallobjects);
allrecalledpixels=zeros(1,noallobjects);
fmeasures=struct;
fmeasures.allprecisepixels=zeros(1,noallobjects);
fmeasures.allrecalledpixels=zeros(1,noallobjects);
%TODO: exchange inner and outer loop
for label=uniquelabels'
    trackmask=(labelledvideo==label); %size(trackmask), Printthevideoonscreen(trackmask,1,1)
    framerange=squeeze(any(any(trackmask,1),2));
    
    startFrame=find(framerange,1,'first');
    endFrame=find(framerange,1,'last');
    totalLength=endFrame-startFrame+1;
    
    totallengths=totallengths+totalLength;
    totalsquaredlength=totalsquaredlength+totalLength^2;



    if (totalLength<mintracklength)
        continue;
    end
    therange=startFrame:endFrame;

    %TODO: set this part before in the function
        newrange=therange;
        for rr=therange
            if (~any(framesforevaluation==rr))
                newrange(newrange==rr)=[];
                %TODO: uncomment the following line and use newrange (modifying validobjectmasks likely)
%                 trackmask(:,:,rr)=false;
                fprintf('\nRequested partial evaluation, which is still not in the code\n\n');
            end
        end
        therange=newrange; clear newrange;



    overlappedpixelsforallobject=zeros(1,noallobjects);
    fmeasureforallobjects=zeros(1,noallobjects);
    recalledpixelsforalllabels=zeros(1,noallobjects);
    for i=1:noallobjects
        %TODO: select frames before equating (labelledvideo==label)
        %validobjectmasks=false(nomaxframes,noallobjects);
        objecttrackmask=trackmask(:,:,validobjectmasks(:,i));
        objecttruepixels=gtmasks(:,:,validobjectmasks(:,i),i);
        
        recalledpixelsforalllabels(i)=sum(objecttrackmask(:));
        overlappedpixelsforallobject(i)=sum(objecttruepixels(objecttrackmask)); %indexing is equivalent to logical AND
        
        fmeasureforallobjects(i)=2*overlappedpixelsforallobject(i)/(recalledpixelsforalllabels(i)+totalobjectpixels(i)); %F-measures for the objects
    end
    
    %TODO: should there be a check as in Labelsfromgt about precisepixels and fmeasurebest
    %Choose objects according to max overlapping pixels
    [precisepixels,chosenobject]=max(overlappedpixelsforallobject);
    totalrecalledpixels=recalledpixelsforalllabels(chosenobject);
    %precisepixels/totalrecalledpixels is precision
    %sum of precisepixels on sum of objecttrupixels is recall
    
    allprecisepixels(chosenobject)=allprecisepixels(chosenobject)+precisepixels;
    allrecalledpixels(chosenobject)=allrecalledpixels(chosenobject)+totalrecalledpixels;
    
    %Choose objects according max F-measure
    [fmeasurebest,fchosenobject]=max(fmeasureforallobjects); %#ok<ASGLU>
    fprecisepixels=overlappedpixelsforallobject(fchosenobject);
    
    ftotalrecalledpixels=recalledpixelsforalllabels(fchosenobject);
    fmeasures.allprecisepixels(fchosenobject)=fmeasures.allprecisepixels(fchosenobject)+fprecisepixels;
    fmeasures.allrecalledpixels(fchosenobject)=fmeasures.allrecalledpixels(fchosenobject)+ftotalrecalledpixels;
end

meanlength=totallengths/numberoftrajectories;
stdlength= sqrt( (totalsquaredlength/numberoftrajectories) - (meanlength^2) );

coveredpixels=sum(sum(sum(labelledvideo>0)));
totpixels=numel(labelledvideo);
density=coveredpixels/totpixels;



%Compute metrics according to most overlapping pixels
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



%Compute metrics according to best fmeasure
fmeasures.precisionperobject=zeros(1,noallobjects);
fmeasures.recallperobject=zeros(1,noallobjects);
for i=1:noallobjects
    if (fmeasures.allrecalledpixels(i)>0)
        fmeasures.precisionperobject(i)=fmeasures.allprecisepixels(i)/fmeasures.allrecalledpixels(i);
    else
        fmeasures.precisionperobject(i)=0;
        fprintf('Could not compute precision for %s\n',textallobjects{i});
    end
    if (totalobjectpixels(i)>0)
        fmeasures.recallperobject(i)=fmeasures.allprecisepixels(i)/totalobjectpixels(i);
    else
        fmeasures.recallperobject(i)=0;
        fprintf('Could not compute recall for %s\n',textallobjects{i});
    end
end

fmeasures.averageprecision=mean(fmeasures.precisionperobject(firstobject:end)); %(2:end) does not include background
fmeasures.averagerecall=mean(fmeasures.recallperobject(firstobject:end)); %(2:end) does not include background
% averageprecision=mean(precisionperobject);
% averagerecall=mean(recallperobject);

if (sum(fmeasures.allrecalledpixels(firstobject:end))>0) %(2:end) does not include background
    fmeasures.precision=sum(fmeasures.allprecisepixels(firstobject:end))/sum(fmeasures.allrecalledpixels(firstobject:end));
else
    fmeasures.precision=0;
    fprintf('Could not compute precision\n');
end
if (sum(totalobjectpixels(firstobject:end))>0) %(2:end) does not include background
    fmeasures.recall=sum(fmeasures.allprecisepixels(firstobject:end))/sum(totalobjectpixels(firstobject:end));
else
    fmeasures.recall=0;
    fprintf('Could not compute recall\n');
end

