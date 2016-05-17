function Orderwitherror(filenames,additionalmasname,nclusters)

if ( (~exist('nclusters','var')) || (isempty(nclusters)) )
    nclusters=10; %This should correspond to 10 clusters
end
if ( (~exist('additionalmasname','var')) || (isempty(additionalmasname)) )
    additionalmasname='ucm'; fprintf('%s additional name, press a button to continue\n',additionalmasname); pause;
end
printonscreeninsidefunction=false;


%Assign input directory names and check existance of folders
onlyassignnames=true;
[sbenchmarkdir,imgDir,gtDir,inDir,isvalid] = Benchmarkcreatedirsimvid(filenames, additionalmasname, onlyassignnames);
% [sbenchmarkdir,imgDir,gtDir,inDir,isvalid] = Benchmarkcreatedirs(filenames, additionalmasname, onlyassignnames);
%imgDir images (for name listing), gtDir ground truth, inDir ucm2, outDir output
if (~isvalid)
    fprintf('Some Directories are not existing\n');
    return;
end

%Check existance of output directory and request confirmation of deletion
[theoutputdir,isoutvalid] = Checkadir([sbenchmarkdir,'Ordered',filesep]);
requestdelconf=1;
if ( isoutvalid )
    if (requestdelconf)
        theanswer = input('Remove previous output? [ 1 (default) , 0 ] ');
    else
        theanswer=1;
    end
    if ( (isempty(theanswer)) || (theanswer~=0) )
        rmdir(theoutputdir,'s')
        fprintf('Dir %s removed\n',theoutputdir);
        isoutvalid=false;
    end
end
if (~isoutvalid)
    theoutputdir=Createadir([sbenchmarkdir,'Ordered',filesep]);
end



MINTRACKLENGTH=1;
INCLUDEBACKGROUND=true; %in most case background is the first object and all objects are included
PRINTTHETEXT=false;
if (INCLUDEBACKGROUND) %#1 position is for the background (usually)
    firstobject=1;
else
    firstobject=2;
end



iids = dir(fullfile(inDir,'*.mat'));
fprintf('Processing images:')
for i = 1:numel(iids)
    fprintf(' %d',i)
    
    if (~strcmp(iids(i).name(1:7),'allsegs'))
        continue;
    end
    
    casename=iids(i).name(8:end-4);
    if (isempty(casename))
        fprintf('Casename empty\n');
    end
    
    
    inFile = fullfile(inDir, iids(i).name);
    load(inFile); % allthesegmentations
    asegmentation=Doublebackconv(allthesegmentations{nclusters}); %#ok<USENS>
    
    anumberframes=size(asegmentation,3);
    lcim=cell(1,anumberframes);
    lgtimages=cell(1,anumberframes);
    
    allindicesfile= fullfile(inDir, strcat('allindices',casename,'.txt'));
    if (exist(allindicesfile,'file'))
        nonemptyindex = dlmread(allindicesfile);
    else
        nonemptyindex = Getnonemptyindexofcase(casename); % TODO : keep coding this function
        fprintf('Using Getnonemptyindexofimage instead of file %s\n',allindicesfile);
    end
    
    %Read images and gtimags into the appriate frame location in lcim and lgtimages
    count=0;
    allcode=[];
    for f=nonemptyindex
        count=count+1;
        gtFile = fullfile(gtDir, strcat(casename,num2str(count), '.mat'));
        imgFile = fullfile(imgDir, strcat(casename,num2str(count), '.jpg'));
        if ( (exist(imgFile,'file')) && (exist(gtFile,'file')) )
            lcim{f}=imread(imgFile);
            load(gtFile);
            lgtimages{f}=Doublebackconv(groundTruth{1}.Segmentation); %#ok<USENS> % uint16 image size
            allcode=unique([allcode;unique(lgtimages{f}(:))]);
        else
            fprintf('Files in Ordercolorvideos\n');
        end
    end
    allcode=sort(allcode,'ascend'); %vertical array
    
    
    
    %Evaluate asegmentation with lgtimages, color the images and darken
    %according to error

    % bgcode is usually the min among all segmentations
    % mbcode are all other values [bgcode+1:max]
    noallobjects=size(allcode,1);
    textallobjects=cell(1,noallobjects);
    textallobjects{1}='Background';
    for i=2:noallobjects
        textallobjects{i}=['Object ',num2str(i-1)];
    end

    framesforevaluation=1:anumberframes;
    firstnonempty=nonemptyindex(1); %Getfirstgtnonempty(lgtimages,framesforevaluation,anumberframes)
    imagesize=size(lgtimages{firstnonempty});
    imagesizetwo=imagesize(1:2);

    %Compute gtmasks by using allcode
    [gtmasks,validobjectmasks]=Gtmasksfromallcodes(lgtimages,imagesizetwo,anumberframes,noallobjects,allcode,framesforevaluation,anumberframes,printonscreeninsidefunction,textallobjects);

    
    
    %total number of pixels for each ground truth object
    totalobjectpixels=zeros(1,noallobjects);
    for i=1:noallobjects
        totalobjectpixels(i)=sum(sum(sum(  gtmasks(:, :, validobjectmasks(:,i) , i)  )));
    end



    %number and id of objects identified in the video/image
    uniquelabels=unique(asegmentation);

    %Treatment of outliers
    outmzero=find(uniquelabels<0);
    if (~isempty(outmzero))
        uniquelabels(outmzero)=[]; %so the outliers <0 are not considered among the assigned
    end
    if (any(uniquelabels==0))
        fprintf('\n\nSome labels others (0) are also present in the asegmentation, not removed\n\n\n');
    end

    numberoftrajectories=numel(uniquelabels);



    %main part: each computed object is assigned to the ground truth object which scores the largest F-measure
    %allprecisepixels: number of pixels correctly classified as ground truth object
    %allrecalledpixels: number of pixels for the label (including correctly and non correctly classified)
    %
    %precisionperobject(i)=allprecisepixels(i)/allrecalledpixels(i);
    %recallperobject(i)=allprecisepixels(i)/totalobjectpixels(i);
    totallengths=0;
    totalsquaredlength=0;
    fmeasures=struct;
    fmeasures.allprecisepixels=zeros(1,noallobjects);
    fmeasures.allrecalledpixels=zeros(1,noallobjects);
    for label=uniquelabels'
        trackmask=(asegmentation==label); %size(trackmask), Printthevideoonscreen(trackmask,1,1)
        framerange=squeeze(any(any(trackmask,1),2));

        startFrame=find(framerange,1,'first');
        endFrame=find(framerange,1,'last');
        totalLength=endFrame-startFrame+1;

        totallengths=totallengths+totalLength;
        totalsquaredlength=totalsquaredlength+totalLength^2;

        if (totalLength<MINTRACKLENGTH)
            continue;
        end
%         therange=startFrame:endFrame;

        overlappedpixelsforallobject=zeros(1,noallobjects);
        fmeasureforallobjects=zeros(1,noallobjects);
        recalledpixelsforalllabels=zeros(1,noallobjects);
        for i=1:noallobjects
            objecttrackmask=trackmask(:,:,validobjectmasks(:,i)); %validobjectmasks is a boolean matrix nomaxframes x noallobjects
            objecttruepixels=gtmasks(:,:,validobjectmasks(:,i),i);

            recalledpixelsforalllabels(i)=sum(objecttrackmask(:));
            overlappedpixelsforallobject(i)=sum(objecttruepixels(objecttrackmask)); %indexing is equivalent to logical AND

            fmeasureforallobjects(i)=2*overlappedpixelsforallobject(i)/(recalledpixelsforalllabels(i)+totalobjectpixels(i)); %F-measures for the objects
        end

        %Choose objects according max F-measure
        [fmeasurebest,fchosenobject]=max(fmeasureforallobjects); %#ok<ASGLU>
        fprecisepixels=overlappedpixelsforallobject(fchosenobject);
        %precisepixels/totalrecalledpixels is precision
        %sum of precisepixels on sum of objecttrupixels is recall

        ftotalrecalledpixels=recalledpixelsforalllabels(fchosenobject);
        fmeasures.allprecisepixels(fchosenobject)=fmeasures.allprecisepixels(fchosenobject)+fprecisepixels;
        fmeasures.allrecalledpixels(fchosenobject)=fmeasures.allrecalledpixels(fchosenobject)+ftotalrecalledpixels;
    end

    meanlength=totallengths/numberoftrajectories;
    stdlength= sqrt( (totalsquaredlength/numberoftrajectories) - (meanlength^2) );

    coveredpixels=sum(sum(sum(asegmentation>0)));
    totpixels=numel(asegmentation);
    density=coveredpixels/totpixels;



    %Compute metrics according to best fmeasure
    fmeasures.precisionperobject=zeros(1,noallobjects);
    fmeasures.recallperobject=zeros(1,noallobjects);
    for i=1:noallobjects
        if (fmeasures.allrecalledpixels(i)>0)
            fmeasures.precisionperobject(i)=fmeasures.allprecisepixels(i)/fmeasures.allrecalledpixels(i);
        else
            fmeasures.precisionperobject(i)=0;
            if (PRINTTHETEXT)
                fprintf('Could not compute precision for %s\n',textallobjects{i});
            end
        end
        if (totalobjectpixels(i)>0)
            fmeasures.recallperobject(i)=fmeasures.allprecisepixels(i)/totalobjectpixels(i);
        else
            fmeasures.recallperobject(i)=0;
            if (PRINTTHETEXT)
                fprintf('Could not compute recall for %s\n',textallobjects{i});
            end
        end
    end

    fmeasures.averageprecision=mean(fmeasures.precisionperobject(firstobject:end)); %(2:end) does not include background
    fmeasures.averagerecall=mean(fmeasures.recallperobject(firstobject:end)); %(2:end) does not include background

    if (sum(fmeasures.allrecalledpixels(firstobject:end))>0) %(2:end) does not include background
        fmeasures.precision=sum(fmeasures.allprecisepixels(firstobject:end))/sum(fmeasures.allrecalledpixels(firstobject:end));
    else
        fmeasures.precision=0;
        if (PRINTTHETEXT)
            fprintf('Could not compute precision\n');
        end
    end
    if (sum(totalobjectpixels(firstobject:end))>0) %(2:end) does not include background
        fmeasures.recall=sum(fmeasures.allprecisepixels(firstobject:end))/sum(totalobjectpixels(firstobject:end));
    else
        fmeasures.recall=0;
        if (PRINTTHETEXT)
            fprintf('Could not compute recall\n');
        end
    end



    valueonname=fmeasures.averageprecision+fmeasures.averagerecall+fmeasures.precision+fmeasures.recall;
    thebasename=[num2str(round(valueonname*1000000),'%07.0f'),'_',casename,'_'];



    printonscreeninsidethisfunction=false; nofigure=1; printthetext=false;
%     Printthevideoonscreen(asegmentation, printonscreeninsidethisfunction, 3, true,[],false,true);
    [coloredvideo,activeframes]=Printthevideoonscreensuperposed(asegmentation, printonscreeninsidethisfunction, nofigure, true, [], false, true, lcim,[],[],printthetext);
%     Printthevideoonscreen(coloredvideo(activeframes), printonscreeninsidethisfunction, nofigure, false, [], false,false,[]);

    sampledcoloredvideo=coloredvideo(activeframes);
    sampledgtmasks=gtmasks(:,:,activeframes,:);
    scoreofobjects=(fmeasures.precisionperobject+fmeasures.recallperobject)./2; %score per object in range [0,1] (1 best score)
    % allcode
    % size(gtmasks)
    % size(sampledgtmasks)



    %Write images in the order of avgprc+avgrcl+glbprc+glbrcl with darkened
    %areas according to rcl+prc per object
    mixprop=0.6; %proportion of added darkness
    for ff=1:numel(sampledcoloredvideo)
        coloredframe=sampledcoloredvideo{ff};
        refimage=zeros(size(coloredframe)).*0;
        for oid=1:size(sampledgtmasks,4)
            thegtattheframe=squeeze(sampledgtmasks(:,:,ff,oid));
            refimage(cat(3,thegtattheframe,thegtattheframe,thegtattheframe))=scoreofobjects(oid); % size(squeeze(sampledgtmasks(:,:,ff,oid)))
        end


        newcoloredframe=uint8( double(coloredframe)*(1-mixprop) + double(coloredframe).*mixprop.*refimage );
    %     newcoloredframe=uint8( 255*mixprop*refimage + double(coloredframe)*(1-mixprop) );



        outFile = fullfile(theoutputdir, strcat(thebasename,num2str(ff), 'orig.jpg'));
        imwrite(coloredframe,outFile);
        outFile = fullfile(theoutputdir, strcat(thebasename,num2str(ff), 'recolor.jpg'));
        imwrite(newcoloredframe,outFile);

    %     Init_figure_no(1), imshow(newcoloredframe)
    %     Init_figure_no(2), imagesc(asegmentation(:,:,nonemptyindex(ff)))
    %     Init_figure_no(3), imshow(coloredframe)
    %     Init_figure_no(4), imagesc(refimage)
    end



%     fprintf('Showing video: %s\n',casename);
%     for lev=1:numel(allthesegmentations)
% 
%         fprintf(' lev %d (clusters %d) ',lev,numel(unique(asegmentation)));
%         
%         Printthevideoonscreen(labelledgtvideo, true, 3, false,[],false,true);
%         Printthevideoonscreen(asegmentation, true, 3, true,[],false,true);
% %         Printthevideoonscreensuperposed(asegmentation, true, 1, true, [], false, true, lcim,[]);
%     end
end
fprintf('\n');


