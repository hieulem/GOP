function Mcbench(theDir, outDir, justavideo, outfilename)

if ( (~exist('outfilename','var')) || (isempty(outfilename)) )
    outfilename='evaluations.txt';
end
if (~exist('justavideo','var'))
    justavideo=[];
end
if (isempty(justavideo))
    analyzeonevideo=false;
else
    analyzeonevideo=true;
end



fname = fullfile(outDir, outfilename);
yettoprocess=(~(length(dir(fname))==1));
if (~yettoprocess)
    fprintf('Scores already processed\n');
    return
end



stepkmap=[];



% zero all counts
allcounts=struct();
allcounts.isglobal=[]; %to take a boolean

allcounts.cntprec=[]; %intersection test and ground truth, for precision
allcounts.sumprec=[]; %machine segmentation sum, for precision
allcounts.cntrec=[];  %intersection test and ground truth, for recall
allcounts.sumrec=[];  %ground truth sum, for recall

allcounts.avgrec=[];   %average recall at the image (recall for each objects averaged)
allcounts.avgprec=[];   %average precision at the image (precision for each objects averaged)
allcounts.nprec=[]; %object count at the image (used to re-weight averages), for precision
allcounts.nrec=[]; %object count at the image (used to re-weight averages), for recall

allcounts.covpx=[]; %covered pixels
allcounts.totpx=[]; %total number of pixels covpx/totpx = density

allcounts.requestedclusters=[]; %used to check how many clusters were really allocated
allcounts.createdclusters=[]; %used to check how many clusters were really allocated

allcounts.totallengths=[]; %used to compute the mean and std length in
allcounts.totalsquaredlength=[]; %conjunction with createdclusters

allcounts.totalexpvariation=[];
allcounts.totalsquaredtheexpvariation=[];

allcounts.stepkcount=[]; %used to check how many sequences are contributing to the statistics

allnames=cell(0);
nameoccurrences=[];
stepkocc=[];
maxscorerow=0;

iids = dir(fullfile(theDir,'*.txt'));
if (numel(iids)<1)
    fprintf('Statistics to be computed\n');
    return;
end
fprintf('Evaluating scores:');
for i = 1:numel(iids)
    
    inFile = fullfile(theDir, strcat(iids(i).name(1:end-4), '.txt'));

    score = dlmread(inFile);
    % score=[1 stepk,2 createdk,3 noallobjects,4 averageprecision,5 averagerecall,6 allprecisepixels,7 allrecalledpixels,
    %8 totalobjectpixels,9 coveredpixels,10 totpixels,11 totallengths,12 totalsquaredlength,13 explained variation]
    
    maxscorerow=max(maxscorerow,size(score,2));
    
    thevideoname=Findthevideosequencename(iids(i).name);
    
    if ( (analyzeonevideo) && (~strcmp(thevideoname,justavideo)) )
        continue;
    end
    
    [allnames,nameoccurrences,stepkocc,repeatedocc]=Findaddcheckavideoname(allnames,nameoccurrences,stepkocc,thevideoname,score(:,1));
    
    for j=1:size(score,1)
        if (repeatedocc(j))
            fprintf('Excluding repeated\n');
            continue;
        end
        [stepkmap,allcounts]=Findoradd(stepkmap,score(j,:),allcounts);
    end
    
    if (mod(i,20)==0), fprintf(' %d', i); end
end
fprintf('\n');

if (isempty(allnames))
    fprintf('Statistics of video %s to be computed\n',justavideo);
    return;
end

globrec= allcounts.cntrec ./ allcounts.sumrec;
globprec= allcounts.cntprec ./ allcounts.sumprec;

avgrec= allcounts.avgrec ./ allcounts.nrec;
avgprec= allcounts.avgprec ./ allcounts.nprec;

thecov= allcounts.covpx ./ allcounts.totpx;

clusterassignratio= allcounts.createdclusters ./ allcounts.requestedclusters; %one if k-means assigns all requested clusters

if (allcounts.isglobal)
    meanlength= allcounts.totallengths ./ allcounts.createdclusters;
    stdlength= sqrt( (allcounts.totalsquaredlength./allcounts.createdclusters) - (meanlength.^2) );
else
    meanlength= allcounts.totallengths ./ allcounts.totpx;
    stdlength= allcounts.totalsquaredlength ./ allcounts.totpx;
end

NORMEV=false;
if (NORMEV)
    meanexplainedvariation= allcounts.totalexpvariation ./ allcounts.createdclusters;
    stdtheexplainedvariation= sqrt( (allcounts.totalsquaredtheexpvariation./allcounts.createdclusters) - (meanexplainedvariation.^2) );
else
    meanexplainedvariation= allcounts.totalexpvariation ./ (sum(nameoccurrences,1)');
    stdtheexplainedvariation= sqrt( (allcounts.totalsquaredtheexpvariation./ (sum(nameoccurrences,1)') ) - (meanexplainedvariation.^2) );
end
stepkcount=allcounts.stepkcount;

%Write output to files
fname = fullfile(outDir,outfilename);
fid = fopen(fname,'w');
if fid==-1,
    error('Could not open file %s for writing.',fname);
end
fprintf(fid,'%10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g\n',...
    [stepkmap, globrec, globprec, avgrec, avgprec, thecov, clusterassignratio, meanlength, stdlength,stepkcount,meanexplainedvariation,stdtheexplainedvariation]');
%Sorting of the solutions is done in Mcplot
fclose(fid);



%Compact the results in theDir
% nameoccurrences=[number of videos(allnames) x number of requested cluster cases(stepkocc)]
if ( (all(nameoccurrences(:))) && (~analyzeonevideo) && (numel(iids)>=numel(nameoccurrences)) && (size(nameoccurrences,2)>1) )
    theanswer = input('Case complete, compact the results? [ 1 (default) , 0 ] ');
    if ( (isempty(theanswer)) || (theanswer~=0) )
        Compactmc(theDir,iids,allnames,nameoccurrences,stepkocc,maxscorerow);
    end
else
    fprintf('Missing cases: '); fprintf('%s ',allnames{~all(nameoccurrences,2)}); fprintf('\n');
end


