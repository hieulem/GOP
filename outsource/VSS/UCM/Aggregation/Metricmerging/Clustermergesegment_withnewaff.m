function [allthesegmentations,newucm2]=Clustermergesegment_withnewaff(ucm2,similarities,mapped,noFrames,options,...
    filenames,dimtouse,manifoldmethod,mergesegmoptions,noallsuperpixels,Level,filename_sequence_basename_frames_or_video,videocorrectionparameters,cim,printonscreen)


%Parameter setup
printonscreeninsidefunction=false;
framerange=1:noFrames; %all frames are considered altogether

n_size=mergesegmoptions.n_size; %default is 7, 0 when neighbours have already been selected, (includes self-connectivity)
saveyre=mergesegmoptions.saveyre; %The option also controls the loading
%Define the merge and clustering method:
% - 'linear','log','distlinear','distlog' refer to the merging based on the distances or manifold distances
% - 'numberofclusters','logclusternumber','adhoc' refer to k-means
setclustermethod=mergesegmoptions.setclustermethod; %'linear','log','distlinear','distlog','numberofclusters','logclusternumber','adhoc'
desireducmlevels=mergesegmoptions.desireducmlevels; %number of ucm2 levels, mainly for visualization purposes
numberofclusterings=mergesegmoptions.numberofclusterings; %Desired number of merge iterations or clustering numbers required, not used for k-means
includeoversegmentation=mergesegmoptions.includeoversegmentation; %include oversegmented video into allthesegmentations and newucm2



%Initialisation
newucm2=Initucmtwo(framerange,ucm2,includeoversegmentation); %Initilize newucm2



%prepare manifold testing
if ( (isfield(options,'testmanifoldclustering')) && (~isempty(options.testmanifoldclustering)) && (options.testmanifoldclustering) )
    if ( (isfield(options,'clustaddname')) && (~isempty(options.clustaddname)) )
        additionalname=options.clustaddname;
    else
        additionalname='Cstltifeff'; fprintf('Using standard additional name %s, please confirm\n',additionalname); pause;
    end
end



tmpfilenames.the_isomap_yre=[filenames.filename_directory,'Videopicsidx',filesep,'yretmp.mat'];
tmpfilenames.the_tree_structure=[filenames.filename_directory,'Videopicsidx',filesep,'treestructuretmp.mat'];
% set(0,'RecursionLimit',500);
[Y]=Getmanifoldandtreestructureprogressivemerge(similarities,dimtouse,n_size,...
    manifoldmethod,tmpfilenames,saveyre,options);



if (   (isfield(options,'clustcompnumbers'))   &&   (~isempty(options.clustcompnumbers))   &&   ...
        ( (strcmp(setclustermethod,'adhoc')) || (strcmp(setclustermethod,'numberofclusters')) || (strcmp(setclustermethod,'logclusternumber')) )   )
    mergesteps=options.clustcompnumbers;
else
    mergesteps=myDefinemergesteps(setclustermethod);
%     mergesteps= [2,3,5,10,20]; %TODO: this sets up the number of clusters for k-means
%@HIeu
   % mergesteps = [10,20,50,100,300,500];
end



if ( (strcmp(setclustermethod,'adhoc')) || (strcmp(setclustermethod,'numberofclusters')) || (strcmp(setclustermethod,'logclusternumber')) )
    numberofclusterings=numel(mergesteps);
    clusteringmethod='km3';
else
    numberofclusterings=numel(mergesteps)-1;
    %merge proceeds from mergesteps(i)+1 to mergesteps(i+1) (extrema included) with 1<=i<=(numberofclusterings)
    clusteringmethod=[]; %merge according to distances
end
if (numberofclusterings>(desireducmlevels-1))
    fprintf('\n\nNumber of levels corrected\n\n\n');
    numberofclusterings=(desireducmlevels-1);
end



%Initialization of a cell array with all segmentations
framesize=floor((size(ucm2{1})-1)/2);
allthesegmentations=Initallsegmentations(framesize,numberofclusterings,includeoversegmentation,mapped,ucm2,Level,framerange); %[,labelledvideo]
labelsfc=1:size(similarities,1);
for level=1:numberofclusterings
%@HIEU    
    tryonlinefirst=true; noreplicates=100; noGroups=mergesteps(level);
    [IDX,kmeansdone]=Clusterthepoints(Y,clusteringmethod,noGroups,dimtouse,noreplicates,...
        tryonlinefirst,[],[],[],options); %,offext,C
    valid=kmeansdone;
    [labelsfc]=Gettmandlabelsfcfromidx(IDX);

    if (~valid)
        labelsfc=1:size(similarities,1);
    end

    stepk=mergesteps(level);
            
    uniquelabels=unique(labelsfc);
    outmzero=find(uniquelabels<0);
    if (~isempty(outmzero))
        uniquelabels(outmzero)=[]; %so the outliers <0 are not considered among the assigned
    end
    if (any(uniquelabels==0))
        fprintf('\n\nSome labels others (0) are also present in the labelledvideo, not removed\n\n\n');
    end
    createdk=numel(uniquelabels); %the same as numberoftrajectories

    %From clusters to labelled frames (each pixel gets a cluster code,
    %possibly permuted for visualisation purposes)
    labelledvideo=Labelclusteredvideointerestframes(mapped,labelsfc,ucm2,Level,framerange,printonscreeninsidefunction);

    %output segmentations
    allthesegmentations{level}=Uintconv(labelledvideo);

    %Graphical output
    if (false)
        labelledfilename=['Clustered',num2str(stepk),'_',filenames.casedirname,'_cfstltifefffaa.mat'];
%         labelledfilename=[filenames.idxpicsandvideobasedir,'Videos',filesep,'C',num2str(stepk),'_',filenames.casedirname,'_labelled.mat'];
        save(labelledfilename,'labelledvideo'); % load(labelledfilename);
        if (false)
            for stepk=mergesteps
                labelledfilename=['Clustered',num2str(stepk),'_',filenames.casedirname,'_cfstltifefffaa.mat'];
                load(labelledfilename);
                labelledvideofilename=['Clusteredvideo',num2str(stepk),'sp_',filenames.casedirname,'_cfstltifefffaa.avi'];
                Printthevideoonscreensuperposed(labelledvideo, true, 1, true, [], true, true, cim,[],labelledvideofilename);
            end
            Printthevideoonscreen(cim, true, 3, false,[],true,false,['Sequence',filenames.casedirname,'.avi']);
        end
%     Printthevideoonscreen(Doublebackconv(allthesegmentations{1}), true, 3, true,[],[],true);
%     Printthevideoonscreensuperposed(Doublebackconv(allthesegmentations{1}), true, 1, true, [], [], true, cim);
%     distributecolours=false; includenumbers=false;
%     Visualiseclusteredpoints(Y,labelsfc',2,24,distributecolours,includenumbers);
%     Visualiseclusteredpoints(Y,labelsfc',3,25,distributecolours,includenumbers);
    % Savetoeps('Cluster2D_c3_stltifeff.eps'); %write 2D manifold
    % Printthevideoonscreen(labelledvideo, true, 3, true, false, true) %write the video
    end


    %compute statistics and store them in scores
    if ( (isfield(options,'testmanifoldclustering')) && (~isempty(options.testmanifoldclustering)) && (options.testmanifoldclustering) )
        mintracklength=1; skipfirstlabel=false; %First label is generally the background

        [mostats,jistats,densitystats,lengthstats]=Getquantitativemeasurementjustlabelsfast(filename_sequence_basename_frames_or_video,Uintconv(labelledvideo),mintracklength,...
            videocorrectionparameters,noFrames,skipfirstlabel,printonscreen,framerange);

        if (isempty(mostats)||isempty(jistats)||isempty(densitystats)||isempty(lengthstats))
            fprintf('Skipped requested mc: stats not computed\n');
        else
            evstat = Explainedvariationcompute(labelledvideo,cim);

            fprintf('%%stepk%dc%d  MO: globP %.4f  globR %.4f  avgP %.4f  avgR %.4f  meanL %.2f  stdL %.2f\n           JI: globP %.4f  globR %.4f  avgP %.4f  avgR %.4f  EV %.4f  D %.4f\n', ...
                stepk,createdk,mostats.globprec,mostats.globrec,mostats.avgprec,mostats.avgrec, lengthstats.meanlength,lengthstats.stdlength,...
                jistats.globprec,jistats.globrec,jistats.avgprec,jistats.avgrec, evstat,densitystats.density);

            useglobal=false;
            score=Getthescore(stepk,createdk,mostats,jistats,densitystats,lengthstats,evstat,useglobal);

            Addcurrentcaseformceach(score,filenames,additionalname); %evaluated with Computecm
        end
    end


    %Use the IDX
    for ff=framerange
        newucm2=Addtoucm2wmex(ff,labelledvideo,newucm2,size(labelledvideo,1),size(labelledvideo,2),numel(ff));
        % newucm2=Addtoucm2(ff,labelledvideo,newucm2,printonscreeninsidefunction);
    end

    %fprintf('Level %d (out of %d) processed\n', level, numberofclusterings);
end



%Expand newucm2 to the desireducmlevels
newucm2=Expanddesireducm(newucm2,desireducmlevels,framerange);
