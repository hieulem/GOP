function Addforbenchmarkcbm(allthesegmentations,options,filenames,filename_sequence_basename_frames_or_video,videocorrectionparameters,cim,printonscreen)
%The function prepares input for the benchmaks c and bm



%Parameter setup
noFrames=size(allthesegmentations{1},3);
framerange=1:noFrames; %all frames are considered altogether



%prepare manifold testing
if ( (isfield(options,'testmanifoldclustering')) && (~isempty(options.testmanifoldclustering)) && (options.testmanifoldclustering) )
    if ( (isfield(options,'clustaddname')) && (~isempty(options.clustaddname)) )
        additionalname=options.clustaddname;
    else
        additionalname='Cstltifeff'; fprintf('Using standard additional name %s, please confirm\n',additionalname); pause;
    end
end
%prepare bmetric testing
if ( (isfield(options,'testbmetric')) && (~isempty(options.testbmetric)) && (options.testbmetric) )
    if ( (isfield(options,'broxmetricsname')) && (~isempty(options.broxmetricsname)) )
        additionalbname=options.broxmetricsname;
    else
        additionalbname='Bmcstltifeff'; fprintf('Using standard additionalbname %s, please confirm\n',additionalbname); pause;
    end
end



for level=1:numel(allthesegmentations)
    
    
    asegmentation=Doublebackconv(allthesegmentations{level});
    
    
    
    uniquelabels=unique(asegmentation);
    outmzero=find(uniquelabels<0);
    if (~isempty(outmzero))
        uniquelabels(outmzero)=[]; %so the outliers (<0) are not considered among the assigned
    end
    if (any(uniquelabels==0))
        fprintf('\n\nSome labels others (0) are also present in the labelledvideo, not removed\n\n\n');
    end
    createdk=numel(uniquelabels); %the same as numberoftrajectories
    stepk=createdk;

    
    
    %Graphical output
    if (false)
        labelledfilename=['Clustered',num2str(stepk),'_',filenames.casedirname,'_cfstltifefffaa.mat'];
%         labelledfilename=[filenames.idxpicsandvideobasedir,'Videos',filesep,'C',num2str(stepk),'_',filenames.casedirname,'_labelled.mat'];
        save(labelledfilename,'asegmentation'); % load(labelledfilename);
        if (false)
            for stepk=mergesteps
                labelledfilename=['Clustered',num2str(stepk),'_',filenames.casedirname,'_cfstltifefffaa.mat'];
                load(labelledfilename);
                labelledvideofilename=['Clusteredvideo',num2str(stepk),'sp_',filenames.casedirname,'_cfstltifefffaa.avi'];
                Printthevideoonscreensuperposed(asegmentation, true, 1, true, [], true, true, cim,[],labelledvideofilename);
            end
            Printthevideoonscreen(cim, true, 3, false,[],true,false,['Sequence',filenames.casedirname,'.avi']);
        end
%     Printthevideoonscreen(Doublebackconv(allthesegmentations{1}), true, 3, true,[],[],true);
%     Printthevideoonscreensuperposed(Doublebackconv(allthesegmentations{1}), true, 1, true, [], [], true, cim);
%     distributecolours=false; includenumbers=false;
%     Visualiseclusteredpoints(Y,labelsfc',2,24,distributecolours,includenumbers);
%     Visualiseclusteredpoints(Y,labelsfc',3,25,distributecolours,includenumbers);
    % Savetoeps('Cluster2D_c3_stltifeff.eps'); %write 2D manifold
    % Printthevideoonscreen(asegmentation, true, 3, true, false, true) %write the video
    end


    %compute statistics and store them in scores
    if (  ( (isfield(options,'testmanifoldclustering')) && (~isempty(options.testmanifoldclustering)) && (options.testmanifoldclustering) )  ||...
            ( (isfield(options,'testbmetric')) && (~isempty(options.testbmetric)) && (options.testbmetric) )  )

        if (stepk<=600)
            try
                mintracklength=1; skipfirstlabel=false; %First label is generally the background
                
                if (true) %New metrics
                    [mostats,jistats,densitystats,lengthstats]=Getquantitativemeasurementjustlabelsfast(filename_sequence_basename_frames_or_video,allthesegmentations{level},mintracklength,...
                        videocorrectionparameters,noFrames,skipfirstlabel,printonscreen,framerange);
                     
                    evstat = Explainedvariationcompute(asegmentation,cim);
                    
                    fprintf('%%stepk%dc%d  MO: globP %.4f  globR %.4f  avgP %.4f  avgR %.4f  meanL %.2f  stdL %.2f\n           JI: globP %.4f  globR %.4f  avgP %.4f  avgR %.4f  EV %.4f  D %.4f\n', ...
                        stepk,createdk,mostats.globprec,mostats.globrec,mostats.avgprec,mostats.avgrec, lengthstats.meanlength,lengthstats.stdlength,...
                        jistats.globprec,jistats.globrec,jistats.avgprec,jistats.avgrec, evstat,densitystats.density);

                    useglobal=true;
                    score=Getthescore(stepk,createdk,mostats,jistats,densitystats,lengthstats,evstat,useglobal);

                    Addcurrentcaseformceach(score,filenames,additionalname); %evaluated with Computecm
                else
                    [precision,recall,averageprecision,averagerecall,numberoftrajectories,meanlength,stdlength,...
                        allprecisepixels,allrecalledpixels,totalobjectpixels,density,coveredpixels,totpixels,noallobjects,totallengths,totalsquaredlength,fmeasures]=...
                        Getquantitativemeasurementjustlabels(filename_sequence_basename_frames_or_video,int16(asegmentation),mintracklength,...
                        videocorrectionparameters,noFrames,(~skipfirstlabel),printonscreen,framerange); %int16 limits the labels to 32.767
                    fprintf('%%stepk%dc%d  %.4f    %.4f    %.4f    %.4f    %d    %.2f    %.2f\n    %d    %d    %.4f  %.4f    %.4f    %.4f    %.4f\n',...
                        stepk,createdk,precision,recall,averageprecision,averagerecall,numberoftrajectories,meanlength,stdlength,noallobjects,mintracklength,density,...
                        fmeasures.precision,fmeasures.recall,fmeasures.averageprecision,fmeasures.averagerecall);

                    score=[stepk,createdk,noallobjects,averageprecision,averagerecall,sum(allprecisepixels),sum(allrecalledpixels),sum(totalobjectpixels),...
                        coveredpixels,totpixels,totallengths,totalsquaredlength,...
                        fmeasures.averageprecision,fmeasures.averagerecall,sum(fmeasures.allprecisepixels),sum(fmeasures.allrecalledpixels)];
                    %summing all means including the background
                    %createdk is the same as numberoftrajectories

                    evstat = Explainedvariationcompute(asegmentation,cim);
                    score=[score,evstat];
                    Addcurrentcaseformceach(score,filenames,additionalname);
                end
            catch ME %#ok<NASGU>
                fprintf('Attempt to write mc: %d step, %d labels, %d min, %d max\n',stepk,numel(allthesegmentations{level}),min(min(min(Doublebackconv(allthesegmentations{level})))),max(max(max(Doublebackconv(allthesegmentations{level})))));
            end
        end
        if ( (isfield(options,'testbmetric')) && (~isempty(options.testbmetric)) && (options.testbmetric) )
            if (   ( (isfield(options,'broxmetriccases')) && (~isempty(options.broxmetriccases)) && (ismember(stepk,options.broxmetriccases)) ) ||...
                    (~isfield(options,'broxmetriccases')) || (isempty(options.broxmetriccases))   )
                Addcurrentcaseforbmetric(Doublebackconv(allthesegmentations{level}),stepk,filename_sequence_basename_frames_or_video,filenames,additionalbname);
            end
        end
    end

    %fprintf('Level %d processed for benchmark\n', level);
end






