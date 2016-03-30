function [thresh, cntR, sumR, cntP, sumP, cntR_best] = Evaluatesegmregion(inFile, gtFile, evFile2, evFile3, evFile4, evFile6, nthresh, bmetrics, excludeth)
% function [thresh, cntR, sumR, cntP, sumP, cntR_best] = Evaluatesegmregion(inFile, gtFile, evFile2, evFile3, evFile4, evFile6, nthresh)
%
% Calculate region benchmarks for an image. Probabilistic Rand Index, Variation of
% Information and Segmentation Covering. 
%
% INPUT
%	inFile  : Can be one of the following:
%             - a collection of segmentations in a cell 'segs' stored in a mat file
%             - an ultrametric contour map in 'doubleSize' format, 'ucm2'
%               stored in a mat file with values in [0 1].
%
%	gtFile	:   File containing a cell of ground truth segmentations
%   evFile2, evFile3, evFile4  : Temporary output for this image.
%	nthresh:    Number of scales evaluated. If input is a cell of
%               'segs', nthresh is changed to the actual number of segmentations
%
%
% OUTPUT
%	thresh		Vector of threshold values.
%	cntR,sumR	Ratio gives recall.
%	cntP,sumP	Ratio gives precision.
%
%
% Pablo Arbelaez <arbelaez@eecs.berkeley.edu>
%
% modified by Fabio Galasso
% September 2012

%Note: nsegs in the comments refers to maxseglabs(threshold)
%Note: 0 values should not be used to indicate background. They mean other.
%      E.g. they are not considered for assigment as the best overlapping
%      regions

if (~exist('excludeth','var'))
    excludeth=[]; %Numbers indicated (positions in thresh array) are excluded (nthresh is adjusted consequently)
end
if ( (~exist('bmetrics','var')) || (isempty(bmetrics)) )
    bmetrics={'all'}; %'bdry','sc','pri','vi','all'
end
if ( (~exist('nthresh','var')) || (isempty(nthresh)) )
    nthresh=99;
end

if ( (any(strcmp(bmetrics,'pri'))) || (any(strcmp(bmetrics,'vi'))) || (any(strcmp(bmetrics,'all'))) ), computeindexviandpri=true; else computeindexviandpri=false; end
if ( (any(strcmp(bmetrics,'sc'))) || (any(strcmp(bmetrics,'all'))) ), computeindexsc=true; else computeindexsc=false; end

%Transform non cell arrays inFile and gtFile into cell arrays
if (~iscell(gtFile))
    tmpfile=gtFile; clear gtFile; gtFile=cell(1); gtFile{1}=tmpfile;
end
if (~iscell(inFile))
    tmpfile=inFile; clear inFile; inFile=cell(1); inFile{1}=tmpfile;
end

%Allocate number of ground truths
load(gtFile{1});
if (isempty(groundTruth)) %#ok<NODEF>
    error(' bad gtFile !');
end
ngts = numel(groundTruth);
if (ngts == 0)
    error(' bad gtFile !');
end

%Preallocate max n labels for each ground truth segmentation
maxgtlabelsngt=zeros(1,ngts);
for ff=1:numel(gtFile)
    load(gtFile{ff});

    for i=1:ngts
        if (~isempty(groundTruth{i}))
            maxgtlabelsngt(i)=max(maxgtlabelsngt(i),max(groundTruth{i}.Segmentation(:)));
        end
    end
end
total_gt=sum(maxgtlabelsngt);
regionsGT = zeros(1,total_gt);



%Preallocate max n labels for each threshold in the machine segmentations
firstpass=true; %labels extracted from ucm2 are supposed to be independent at each frame, so countucm2(t) must be added at each frame (and incremented at each addition)
for ff=1:numel(inFile)
    load(inFile{ff});  % segs
    if (exist('ucm2', 'var'))
        ucm = double(ucm2);
        clear ucm2;
    elseif (~exist('segs', 'var'))
        error('unexpected input in inFile');
    end

    if exist('segs', 'var')
        if (nthresh ~= numel(segs))
            nthresh = numel(segs);
        end
        thresh = 1:nthresh; thresh=thresh';
    else
        thresh = linspace(1/(nthresh+1),1-1/(nthresh+1),nthresh)';
    end

    %Exclude some threshold from the computation
    if (~isempty(excludeth))
        excludeth(excludeth>nthresh)=[];
        thresh(excludeth)=[];
        nthresh=numel(thresh);
    end
    
    %Preallocate nthresh cell array for matchesj
    if (ff==1)
        maxseglabs=zeros(1,nthresh);
    end
    
    
    %Initialize count offset for ucm2 in the case of videos
    if (firstpass)
        countucm2=zeros(1,nthresh);
        firstpass=false;
    end
    
    for t = 1 : nthresh
        if exist('segs', 'var')
            seg = Doublebackconv(segs{thresh(t)});
        else
            labels2 = bwlabel(ucm <= thresh(t));
            seg = labels2(2:2:end, 2:2:end);
            seg = seg + countucm2(t); %we assume bwlabel assigns labels from 1
            countucm2(t) = max(seg(:));
        end
        maxseglabs(t)=max(maxseglabs(t),max(seg(:)));
    end
end
confcounts=cell(1,nthresh);
regionsSeg=cell(1,nthresh);
for i=1:numel(confcounts)
    confcounts{i}=zeros( [ (maxseglabs(i) +1) , total_gt + ngts] );
    regionsSeg{i} = zeros(1,maxseglabs(i));
end

%Main cycle: iterated once for images, iterated over the video frames for the videos - accumulate data
firstpass=true; %labels extracted from ucm2 are supposed to be independent at each frame, so countucm2(t) must be added at each frame (and incremented at each addition)
for ff=1:numel(inFile)

    load(inFile{ff});  % segs
    if (exist('ucm2', 'var'))
        ucm = double(ucm2);
        clear ucm2;
    elseif (~exist('segs', 'var'))
        error('unexpected input in inFile');
    end

    load(gtFile{ff}); %groundTruth
    ngtstmp = numel(groundTruth);
    if (ngtstmp ~= ngts)
        error(' bad gtFile ngts correpondence!');
    end

    if exist('segs', 'var')
        if (nthresh ~= numel(segs))
            nthresh = numel(segs);
        end
        thresh = 1:nthresh; thresh=thresh';
    else
        thresh = linspace(1/(nthresh+1),1-1/(nthresh+1),nthresh)';
    end

    %Exclude some threshold from the computation
    if (~isempty(excludeth))
        excludeth(excludeth>nthresh)=[];
        thresh(excludeth)=[];
        nthresh=numel(thresh);
    end

    count=0;
    for s = 1 : ngts
        if (~isempty(groundTruth{s}))
            groundTruth{s}.Segmentation = double(groundTruth{s}.Segmentation); %#ok<AGROW> %touse: Doublebackconv
            segtmp=groundTruth{s}.Segmentation; segtmp(segtmp<0)=0;
            regionsTmp = regionprops(segtmp, 'Area');
            for rr=1:numel(regionsTmp)
                regionsGT(count+rr)=regionsGT(count+rr)+regionsTmp(rr).Area;
            end
        end
        count=count+maxgtlabelsngt(s);
    end

    %Initialize count offset for ucm2 in the case of videos
    if (firstpass)
        countucm2=zeros(1,nthresh);
        firstpass=false;
    end

    for t = 1 : nthresh,

        if exist('segs', 'var')
            seg = Doublebackconv(segs{thresh(t)});
        else
            labels2 = bwlabel(ucm <= thresh(t));
            seg = labels2(2:2:end, 2:2:end);
            seg = seg + countucm2(t); %we assume bwlabel assigns labels from 1
            countucm2(t) = max(seg(:));
        end

        confcountstmp = Getconfcounts(seg, groundTruth, maxgtlabelsngt);
        %confcounts = (nsegs+1) x (total_gt+ngts)
        %the matrix contains the confusion counts among labels, ie the
        %intersection set measures. Zero labels intersection are reported
        %in the column for seg and in each first row for each gt

        confcounts{t}(1:size(confcountstmp,1),1:size(confcountstmp,2))=confcounts{t}(1:size(confcountstmp,1),1:size(confcountstmp,2))+confcountstmp;
        
        regionsSegtmp = regionprops(seg(seg>=0), 'Area'); %This could also be >0, regionprops do not consider 0 labels
        for r = 1 : numel(regionsSegtmp)
            regionsSeg{t}(r)=regionsSeg{t}(r)+regionsSegtmp(r).Area;
        end
        
    end
end %Main cycle accumulate data



%Main cycle: iterated once for images, iterated over the video frames for the videos - compute statistics
nthresh=numel(regionsSeg);
cntR = zeros(nthresh,1);
sumR = zeros(nthresh,1);
cntP = zeros(nthresh,1);
sumP = zeros(nthresh,1);
sumRI = zeros(nthresh,1);
sumVOI = zeros(nthresh,1);
best_matchesGT = zeros(1, total_gt);
for t = 1 : nthresh,

    [matchesj,confcountssized] = Getaccuracies(confcounts{t},maxgtlabelsngt);
    %matchesj is a matrix (number of segments in the computed segmentation) x total_gt (number of all gt segmentation labels)
    %matchesj contains the Jaccard indexes among the respective machine and human segments
    %zero values in seg or groundTruth are counted for the statistics (the area is counted as unlabelled)
    %negative values exclude the part from the statistics, the part is not considered at all, not the area either
    %confcountssized is the same as confcounts{t} but only considers labels > 0
    %nsegs (number of segments in the machine segmentation) x total_gt (number of all gt segmentation labels)
    
    if (size(matchesj,1)==0) %This means that at thresh thresh(t) the machine segmentation is -1. This video and threshold must therefore be neglected.
                             %The code as of now does not allow skipping just a single threshold for a segmentation and will skip the whole video
                             %TODO: address this with outlier values in the results
        fprintf('\nEmpty machine segmentation at threshold %1.2f of video %s, skipping the whole video\n',thresh(t),inFile{1});
        cntR_best=0;
        return;
    end
    
    %PRI and VI
    if (computeindexviandpri)
        [ri, voi] = Getprivi(confcountssized, maxgtlabelsngt);
        sumRI(t) = ri;
        sumVOI(t) = voi;
    end

    %Segmentation covering
    if (computeindexsc)
        matchesSeg = max(matchesj, [], 2);
        matchesGT = max(matchesj, [], 1);

        %cntP(t)/sumP(t) is the segmentatation covering index at threshold t given by covering the
        %machine with the ground truth segmentation
        for r = 1 : numel(regionsSeg{t})
            cntP(t) = cntP(t) + regionsSeg{t}(r)*matchesSeg(r); %here it would be appropriate to use segareas(r)
            sumP(t) = sumP(t) + regionsSeg{t}(r); %here it would be appropriate to use segareas(r)
        end

        %cntR(t)/sumR(t) is the segmentatation covering index at threshold t given by covering the
        %ground truth with the machine segmentation
        for r = 1 : numel(regionsGT),
            cntR(t) = cntR(t) +  regionsGT(r)*matchesGT(r); %here it would be appropriate to use gtareas(r)
            sumR(t) = sumR(t) + regionsGT(r); %here it would be appropriate to use gtareas(r)
        end

        best_matchesGT = max(best_matchesGT, matchesGT); %Best Jaccard indexes for each GT segment, achievable with the machine segments across thresholds
    end
end %Main cycle compute statistics

% SC fro Best
if (computeindexsc)
    cntR_best = 0;
    for r = 1 : numel(regionsGT),
        cntR_best = cntR_best +  regionsGT(r)*best_matchesGT(r);
    end
end



%%%Save Results%%%
if (computeindexsc)
    fid = fopen(evFile2, 'w');
    if fid == -1, 
        error('Could not open file %s for writing.', evFile2);
    end
    fprintf(fid,'%10g %10g %10g %10g %10g\n',[thresh, cntR, sumR, cntP, sumP]');
    fclose(fid);

    fid = fopen(evFile3, 'w');
    if fid == -1, 
        error('Could not open file %s for writing.', evFile3);
    end
    fprintf(fid,'%10g\n', cntR_best);
    fclose(fid);
end

if (computeindexviandpri)
    fid = fopen(evFile4, 'w');
    if fid == -1, 
        error('Could not open file %s for writing.', evFile4);
    end
    fprintf(fid,'%10g %10g %10g\n',[thresh, sumRI, sumVOI]');
    fclose(fid);
end








