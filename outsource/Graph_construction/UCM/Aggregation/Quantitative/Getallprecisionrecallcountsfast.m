function [mostats,jistats,densitystats,lengthstats]=Getallprecisionrecallcountsfast(labelledvideo,labelledgtvideo,skipfirstlabel,mintracklength,framesforevaluation)
%[mostats,jistats,density,meanlength,stdlength]=Getallprecisionrecallcountsfast(labelledvideo,labelledgtvideo,skipfirstlabel,mintracklength,framesforevaluation);
%labelledvideo should be uint, as converted with Uintconv
% labelledvideo= [dimIi x dimIj x nFrames]
%labelledgtvideo is double, as output from Getmultgtlabvideo
%labelledgtvideo{ which gt annotation , which frame } = dimIi x dimIj double (the labels, 0 others, -1 neglect)
%Precision and recall values are global and average, in both cases this
%refers to statistics of the sequence, statistics over different sequences
%are average (this accounts for different frame size and time resolution)
%density is the number of video pixels assigned a valid label on the total number of pixels
%meanlength and stdlength are the respective statistics for labelledvideo
%label outlier (<0), label others(0)



% labelledvideo=Labelclusteredvideointerestframes(mapped,labelsgt,ucm2,Level,[],printonscreen);

%Prepare the input
if ( (~exist('mintracklength','var')) || (isempty(mintracklength)) )
    mintracklength=1;
end
if ( (~exist('framesforevaluation','var')) || (isempty(framesforevaluation)) )
    framesforevaluation=1:size(labelledvideo,3);
end
if ( (~exist('skipfirstlabel','var')) || (isempty(skipfirstlabel)) )
    skipfirstlabel=false; %by default background is not included in calculations
end



%Exclude some frames from all these evaluations on request
framestoexclude=true(1,size(labelledvideo,3));
framestoexclude(framesforevaluation)=false;
ftoexcl=find(framestoexclude);
if (~isempty(ftoexcl))
    tmpconv=Uintconv([-1,max(Doublebackconv(labelledvideo(:)))]);
    outliervalue= tmpconv(1);
    for i=1:numel(ftoexcl)
        ff=ftoexcl(i);
        
        labelledvideo(:,:,ff)=outliervalue;
        labelledgtvideo{1,ff}(:)=[];
    end
end



%Preallocate max n labels for each ground truth segmentation
ngts=1;
maxgtlabelsngt=zeros(1,ngts);
for ff=1:size(labelledgtvideo,2)
    for i=1:ngts
        if (~isempty(labelledgtvideo{i,ff}))
            maxgtlabelsngt(i)=max(maxgtlabelsngt(i),max(labelledgtvideo{i,ff}(:)));
        end
    end
end
total_gt=sum(maxgtlabelsngt);
regionsGT = zeros(1,total_gt);

%Convertion to double format
labelledvideoconv = Doublebackconv(labelledvideo);


%Preallocate max n labels for each threshold in the machine segmentations
maxseglabs=0;
for ff=1:size(labelledgtvideo,2)
    if (isempty(labelledgtvideo{1,ff}))
        continue;
    end
    
    seg = labelledvideoconv(:,:,ff);
    maxseglabs=max(maxseglabs,max(seg(:)));
end
confcounts=zeros( [ (maxseglabs +1) , total_gt + ngts] );
regionsSeg = zeros(1,maxseglabs);



%Compute length statistics and set to zero shorter tracks
maxallsegs=max(labelledvideoconv(:));
allpresences=false(maxallsegs,size(labelledvideoconv,3));
for ff=1:size(labelledvideoconv,3)
    labelsatff=unique(labelledvideoconv(:,:,ff));
    labelsatff(labelsatff<1)=[]; %so as to not consider 0 and -1
    allpresences(labelsatff,ff)=true;
end

alllengths=zeros(1,maxallsegs);
for i=1:maxallsegs
    themin=find(allpresences(i,:),1,'first');
    themax=find(allpresences(i,:),1,'last');
    if (~isempty(themin))
        alllengths(i)=themax-themin+1;
    end
end

%Erase (set to 0) shorter labels
lengthtoerase=find( (alllengths<mintracklength) & (alllengths>0) ); %a length of 0 is not present and there is no need to delete the label
if (~isempty(lengthtoerase))
    find(ismember(labelledvideoconv,lengthtoerase))
    labelledvideoconv(ismember(labelledvideoconv,lengthtoerase))=0;
end
% Printthevideoonscreen(labelledvideoconv,true,            1,        false,     true,           [],         false);

%Record length statistics
lengthstats=struct();
lengthstats.cntlengths=sum(alllengths(alllengths>0));
lengthstats.cntsqlengths=sum(alllengths(alllengths>0).^2);
lengthstats.nlengths=numel(alllengths(alllengths>0));



%Main cycle: accumulate data
for ff=1:size(labelledgtvideo,2)
    if (isempty(labelledgtvideo{1,ff}))
        continue;
    end

    count=0;
    for s = 1 : ngts
            segtmp=labelledgtvideo{s,ff}; segtmp(segtmp<0)=0; %touse: Doublebackconv not necessary here as gtsegm is already a double (not loaded)
            regionsTmp = regionprops(segtmp, 'Area');
            for rr=1:numel(regionsTmp)
                regionsGT(count+rr)=regionsGT(count+rr)+regionsTmp(rr).Area;
            end
        count=count+maxgtlabelsngt(s);
    end

    seg = labelledvideoconv(:,:,ff);
    groundTruth=cell(1,ngts);
    for gti=1:ngts
        groundTruth{gti}.Segmentation=labelledgtvideo{gti,ff};
    end

    confcountstmp = Getconfcounts(seg, groundTruth, maxgtlabelsngt);
    %confcounts = (nsegs+1) x (total_gt+ngts)
    %the matrix contains the confusion counts among labels, ie the
    %intersection set measures. Zero labels intersection are reported
    %in the column for seg and in each first row for each gt

    confcounts(1:size(confcountstmp,1),1:size(confcountstmp,2))=confcounts(1:size(confcountstmp,1),1:size(confcountstmp,2))+confcountstmp;

    regionsSegtmp = regionprops(seg(seg>=0), 'Area'); %This could also be >0, regionprops do not consider 0 labels
    for r = 1 : numel(regionsSegtmp)
        regionsSeg(r)=regionsSeg(r)+regionsSegtmp(r).Area;
    end

end %Main cycle accumulate data



%Main cycle: compute statistics
[matchesj,confcountssized,segareas,gtareas] = Getaccuracies(confcounts,maxgtlabelsngt);
%matchesj is a matrix (number of segments in the computed segmentation) x total_gt (number of all gt segmentation labels)
%matchesj contains the Jaccard indexes among the respective machine and human segments
%zero values in seg or groundTruth are counted for the statistics (the area is counted as unlabelled)
%negative values exclude the part from the statistics, the part is not considered at all, not the area either
%confcountssized is the same as confcounts but only considers labels > 0
%nsegs (number of segments in the machine segmentation) x total_gt (number of all gt segmentation labels)


%Precision, recall and assignment according to max overlap
% [overlapssegmax] = max(confcountssized, [], 2); %These are the overlap areas across all GT altogether
% overlapseg=Getoverlapingseg(confcountssized,maxgtlabelsngt); %These are the max-overlap areas for each gt separately [nsegs x ngts]
[overlapseg,moindex]=max(confcountssized,[],2); %#ok<ASGLU> %the function above is not needed when ngts==1, additionally here we include the index to resolve for the assignment
%moindex specifies to which gt label each machine label is optimally assigned (according to max overlap), it is 1 when all numbers are 0 or the first among equal values

%Precision, recall and assignment according to max Jaccard index
[matchesSeg,jiindex] = max(matchesj, [], 2); %#ok<ASGLU>
%jiindex specifies to which gt label each machine label is optimally assigned (according to the Jaccard index), it is 1 when all numbers are 0 or the first among equal values
%Main cycle compute statistics



if (false) %This returns the original video optimally assigned to GT
    indextouse=moindex; %#ok<UNRCH> %moindex, jiindex
    newlabelledvideo=labelledvideoconv;
    
    
    [labels,ivid,ilab]=unique(newlabelledvideo(:)); %labels = newlabelledvideo(ivid); and newlabelledvideo(:) = labels(ilab);
    
    maxmo=numel(moindex);
    moindex=[reshape(moindex,[],1);0;-1];
    labels(labels<0)=maxmo+2;
    labels(labels==0)=maxmo+1;
    updatedlabels=moindex(labels);
    
    newlabelledvideo(:)=updatedlabels(ilab);
    
%     Printthevideoonscreen(labelledgtvideo,true,            1,        false,     true,           [],         false);
%     Printthevideoonscreen(newlabelledvideo,true,            1,        false,     true,           [],         false);
    %                          thevideo, printonscreen, nofigure, toscramble, showcolorbar, writethevideo,treatoutliers,outputfile,printthetext
    
%     tmplabelledvideo=newlabelledvideo;
%     for ll=1:size(confcountssized,1)
%         newlabelledvideo(tmplabelledvideo==ll)=indextouse(ll);
%     end
end


%Compute global and average precision and recall, given the best assignment with indextouse



%Global precision, recall and assignment according to max overlap
indextouse=moindex;
[cntprec,sumprec,cntrec,sumrec,avgsumprec,nprec,avgsumrec,nrec,ntlabels]=Rpfromconfcount(confcountssized,indextouse,segareas,gtareas,skipfirstlabel);
mostats=struct();
if (sumprec>0), mostats.globprec=cntprec/sumprec; else mostats.globprec=0; end
if (sumrec>0), mostats.globrec=cntrec/sumrec; else mostats.globrec=0; end
if (nprec>0), mostats.avgprec=avgsumprec/nprec; else mostats.avgprec=0; end
if (nrec>0), mostats.avgrec=avgsumrec/nrec; else mostats.avgrec=0; end
mostats.cntprec=cntprec; %cntprec and cntrec should in general coincide
mostats.sumprec=sumprec;
mostats.cntrec=cntrec; %cntprec and cntrec should in general coincide
mostats.sumrec=sumrec;
mostats.avgsumprec=avgsumprec;
mostats.nprec=nprec;
mostats.avgsumrec=avgsumrec;
mostats.nrec=nrec;
mostats.ntlabels=ntlabels; %This depends on the GT, it is not a function of the assignement (also it does not depend on skipfirstlabel)


%Global precision, recall and assignment according to max Jaccard index
indextouse=jiindex;
[cntprec,sumprec,cntrec,sumrec,avgsumprec,nprec,avgsumrec,nrec,ntlabels]=Rpfromconfcount(confcountssized,indextouse,segareas,gtareas,skipfirstlabel);
jistats=struct();
if (sumprec>0), jistats.globprec=cntprec/sumprec; else jistats.globprec=0; end
if (sumrec>0), jistats.globrec=cntrec/sumrec; else jistats.globrec=0; end
if (nprec>0), jistats.avgprec=avgsumprec/nprec; else jistats.avgprec=0; end
if (nrec>0), jistats.avgrec=avgsumrec/nrec; else jistats.avgrec=0; end
jistats.cntprec=cntprec; %cntprec and cntrec should in general coincide
jistats.sumprec=sumprec;
jistats.cntrec=cntrec; %cntprec and cntrec should in general coincide
jistats.sumrec=sumrec;
jistats.avgsumprec=avgsumprec;
jistats.nprec=nprec;
jistats.avgsumrec=avgsumrec;
jistats.nrec=nrec;
jistats.ntlabels=ntlabels; %This depends on the GT, it is not a function of the assignement (also it does not depend on skipfirstlabel)


%Compute density
densitystats=struct();
densitystats.coveredpixels=sum(sum(sum(labelledvideo>0)));
densitystats.totpixels=numel(labelledvideo);
if (densitystats.totpixels>0), densitystats.density=densitystats.coveredpixels/densitystats.totpixels; else densitystats.density=0; end



%Compute mean and std lengths
if (lengthstats.nlengths>0), lengthstats.meanlength=lengthstats.cntlengths / lengthstats.nlengths; else lengthstats.meanlength=0; end
if (lengthstats.nlengths>0), lengthstats.stdlength= sqrt( ( lengthstats.cntsqlengths / lengthstats.nlengths ) - (lengthstats.meanlength^2) ); else lengthstats.stdlength=0; end




%DEBUG lines

% labelledvideo=ones([size(labelledgtvideo{1,1}),33]).*5;
% for ff=1:size(labelledgtvideo,2)
%     if (~isempty(labelledgtvideo{1,ff}))
%         labelledvideo(:,:,ff)=labelledgtvideo{1,ff};
%     end
% end
% labelledvideo(:,:,2)=ones(size(labelledgtvideo{1,1})).*5;
% labelledvideo=Uintconv(labelledvideo);
% 
% Printthevideoonscreen(Doublebackconv(labelledvideo),true,            1,        false,     true,           [],         false);
%                          thevideo, printonscreen, nofigure, toscramble, showcolorbar, writethevideo,treatoutliers,outputfile,printthetext
