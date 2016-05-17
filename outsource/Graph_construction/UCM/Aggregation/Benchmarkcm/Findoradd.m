function [stepkmap,allcounts]=Findoradd(stepkmap,thisscore,allcounts)
% thisscore=score(1,:);

thepos=find(stepkmap==thisscore(1));

if (numel(thepos)>1)
    fprintf('\nThe pos is either 1 or empty, in case a new stepkmap must be created\n\n');
    return;
elseif (isempty(thepos))
    thepos=numel(stepkmap)+1;
    stepkmap(thepos,1)=thisscore(1);
    
    allcounts.cntprec(thepos,1)=0; %intersection test and ground truth, for precision
    allcounts.sumprec(thepos,1)=0;  %machine segmentation sum, for precision
    allcounts.sumrec(thepos,1)=0;  %ground truth sum, for recall

    allcounts.avgrec(thepos,1)=0;   %average recall at the image (recall for each objects averaged)
    allcounts.avgprec(thepos,1)=0;   %average precision at the image (precision for each objects averaged)
    allcounts.nprec(thepos,1)=0;  %object count at the image (used to re-weight averages), for precision

    allcounts.covpx(thepos,1)=0; %covered pixels
    allcounts.totpx(thepos,1)=0; %total number of pixels covpx/totpx = density

    allcounts.requestedclusters(thepos,1)=0; %used to check how many clusters were really allocated
    allcounts.createdclusters(thepos,1)=0; %used to check how many clusters were really allocated

    allcounts.totallengths(thepos,1)=0; %used to compute the mean and std length in
    allcounts.totalsquaredlength(thepos,1)=0; %conjunction with createdclusters
    
    allcounts.totalexpvariation(thepos,1)=0; %used to compute the mean and std length in
    allcounts.totalsquaredtheexpvariation(thepos,1)=0; %conjunction with createdclusters
    
    allcounts.stepkcount(thepos,1)=0; %used to check how many sequences are contributing to the statistics
    
    allcounts.cntrec(thepos,1)=0; %intersection test and ground truth, for recall
    allcounts.nrec(thepos,1)=0;  %object count at the image (used to re-weight averages), for recall
end

if (thisscore(3)<0), isglobal=false; else isglobal=true; end

if (isempty(allcounts.isglobal))
    allcounts.isglobal=isglobal;
end
if (allcounts.isglobal~=isglobal)
    fprintf('Global and average statistics should not be aggregated\n');
end

allcounts.requestedclusters(thepos,1)=allcounts.requestedclusters(thepos,1)+thisscore(1);
allcounts.createdclusters(thepos,1)=allcounts.createdclusters(thepos,1)+thisscore(2);

if (isglobal)
    allcounts.cntprec(thepos,1)=allcounts.cntprec(thepos,1)+thisscore(6);
    allcounts.sumprec(thepos,1)=allcounts.sumprec(thepos,1)+thisscore(7);
    allcounts.sumrec(thepos,1)=allcounts.sumrec(thepos,1)+thisscore(8);

    allcounts.nprec(thepos,1)=allcounts.nprec(thepos,1)+thisscore(3); %weighting factor for avgrec and avgprec
    allcounts.avgprec(thepos,1)=allcounts.avgprec(thepos,1)+thisscore(3).*thisscore(4);
else
    allcounts.cntprec(thepos,1)=allcounts.cntprec(thepos,1)+thisscore(6); %cntprec > globprec
    allcounts.sumprec(thepos,1)=allcounts.sumprec(thepos,1)+1;
    allcounts.sumrec(thepos,1)=allcounts.sumrec(thepos,1)+1;

    allcounts.nprec(thepos,1)=allcounts.nprec(thepos,1)+1; %weighting factor for avgrec and avgprec
    allcounts.avgprec(thepos,1)=allcounts.avgprec(thepos,1)+thisscore(4); %avgprec > avgprec
end

if (numel(thisscore)>=15)
    if (isglobal)
        allcounts.nrec(thepos,1)=allcounts.nrec(thepos,1)+thisscore(15);
        allcounts.cntrec(thepos,1)=allcounts.cntrec(thepos,1)+thisscore(14);
        allcounts.avgrec(thepos,1)=allcounts.avgrec(thepos,1)+thisscore(15).*thisscore(5); %avgrec and avgprec contain the numerators for a weighted average
    else
        allcounts.nrec(thepos,1)=allcounts.nrec(thepos,1)+1;
        allcounts.cntrec(thepos,1)=allcounts.cntrec(thepos,1)+thisscore(14); %cntrec > globrec
        allcounts.avgrec(thepos,1)=allcounts.avgrec(thepos,1)+thisscore(5); %avgrec > avgrec
    end        
else %compatibility options with previous results
    allcounts.nrec(thepos,1)=allcounts.nrec(thepos,1)+thisscore(3);
    allcounts.cntrec(thepos,1)=allcounts.cntrec(thepos,1)+thisscore(6);
    allcounts.avgrec(thepos,1)=allcounts.avgrec(thepos,1)+thisscore(3).*thisscore(5); %avgrec and avgprec contain the numerators for a weighted average
end

if (isglobal)
    allcounts.covpx(thepos,1)=allcounts.covpx(thepos,1)+thisscore(9);
    allcounts.totpx(thepos,1)=allcounts.totpx(thepos,1)+thisscore(10);
else
    allcounts.covpx(thepos,1)=allcounts.covpx(thepos,1)+thisscore(9); %covpx > density
    allcounts.totpx(thepos,1)=allcounts.totpx(thepos,1)+1;
end

if (numel(thisscore)>=12)
    if (isglobal)
        allcounts.totallengths(thepos,1)=allcounts.totallengths(thepos,1)+thisscore(11);
        allcounts.totalsquaredlength(thepos,1)=allcounts.totalsquaredlength(thepos,1)+thisscore(12);
    else
        allcounts.totallengths(thepos,1)=allcounts.totallengths(thepos,1)+thisscore(11); %totallengths > meanlength
        allcounts.totalsquaredlength(thepos,1)=allcounts.totalsquaredlength(thepos,1)+thisscore(12); %totalsquaredlength > stdlength
    end
end

if (numel(thisscore)>=13)
    allcounts.totalexpvariation(thepos,1)=allcounts.totalexpvariation(thepos,1)+thisscore(13);
    allcounts.totalsquaredtheexpvariation(thepos,1)=allcounts.totalsquaredtheexpvariation(thepos,1)+((thisscore(13))^2);
end

allcounts.stepkcount(thepos,1)=allcounts.stepkcount(thepos,1)+1;