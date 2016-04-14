function [similarities,STT,LTT,ABA,ABM,STM,STA]=Getcombinedsimilarities_withnewaff(labelledlevelvideo,flows, ucm2, cim, mapped, ...
    filename_sequence_basename_frames_or_video, options, theoptiondata, filenames,...
    noallsuperpixels, framebelong, numberofsuperpixelsperframe, requestedaffinities, printonscreen)

% HERE we plug in our feature @Hieu
% @Hieu

%Initialization


if ~exist(filenames.affinities)
    
    STT=sparse(noallsuperpixels,noallsuperpixels); LTT=sparse(noallsuperpixels,noallsuperpixels);
    ABA=sparse(noallsuperpixels,noallsuperpixels); ABM=sparse(noallsuperpixels,noallsuperpixels);
    STM=sparse(noallsuperpixels,noallsuperpixels); STA=sparse(noallsuperpixels,noallsuperpixels);
    
    
    
    
    if ( (~exist('requestedaffinities','var')) || (isempty(requestedaffinities)) )
        requestedaffinities={'stt','ltt','aba','abm','stm','sta'};
    end
    if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
        printonscreen=false;
    end
    
    
    computeall=false;
    
    
    
    %Table of dependencies
    %Case/Need   for computation   for connectivity       exclude
    %  STT              -                ABA            ABM STA STM
    %  LTT              -                ABA            ABM STA STM
    %  STA           STT ABA              -                  -
    %  STM           STT ABA              -                  -
    %  ABA              -                LTT            STT STA STM
    %  ABM             ABA               LTT            STT STA STM
    %Criterion: Need for computation merely refers to the affinity dependencies
    %for computation
    %Need for connectivity refers to not having disconnected components in the
    %graph. The affinity is complemented with the an orthogonal one
    %temporal/spatial-wise, so the added terms do not overlap with the
    %requested affinity.
    %Exclude refers to connectivity: if any of the exclude affinity is
    %requested than the need for connectivity is not necessary
    
    
    
    %Adjust requestedaffinities on the base of dependencies
    if ( (isfield(options,'complrqst')) && (options.complrqst) )
        requestedaffinities=Includeconnectivityrequested(requestedaffinities);
    end
    
    
    
    %Setup parameters
    noFrames=numel(ucm2);
    
    
    
    %STT (Short-Term Temporal)
    if ( (Isaffinityrequested(requestedaffinities,'stt')) || (Computationrequestedaffinity(requestedaffinities,'stt',options)) || computeall )
        multcount=1;
        graphdepth=2;
        STT=Getshortterm(labelledlevelvideo, mapped, flows, graphdepth, multcount, options, theoptiondata, filenames);
        % Init_figure_no(1); spy(STT(1:1000,1:1000));
        % Spywithcolor(STT,1)
        % Spywithcolor(STT(1:1204,1:1204),1,mapped)
        % fTHR=-Inf; sTHR=Inf; frames=[1,2]; Showaffinityattwoframes(STT,frames,labelledlevelvideo,mapped,numberofsuperpixelsperframe,fTHR,sTHR,1016+263,cim);
        % fTHR=-Inf; sTHR=Inf; frames=[2,3]; Showaffinityattwoframes(STT,frames,labelledlevelvideo,mapped,numberofsuperpixelsperframe,fTHR,sTHR,263,cim);
    end
    
    
    
    %LTT (Long-Term Temporal)
    if ( (Isaffinityrequested(requestedaffinities,'ltt')) || (Computationrequestedaffinity(requestedaffinities,'ltt',options)) || computeall )
        if ( (exist('filename_sequence_basename_frames_or_video','var')) && (isstruct(filename_sequence_basename_frames_or_video)) )
            
            if (  ( (~isfield(filename_sequence_basename_frames_or_video,'btracksfile')) || (isempty(filename_sequence_basename_frames_or_video.btracksfile)) ||...
                    (~exist(filename_sequence_basename_frames_or_video.btracksfile,'file')) )...
                    &&  (~ispc)  )
                filename_sequence_basename_frames_or_video=Blongtracks(filename_sequence_basename_frames_or_video,noFrames,filenames,cim);
            end
            
            if ( (isfield(filename_sequence_basename_frames_or_video,'btracksfile')) && (~isempty(filename_sequence_basename_frames_or_video.btracksfile)) &&...
                    (exist(filename_sequence_basename_frames_or_video.btracksfile,'file')) )
                %Compute long term similarities
                [btrajectories]=Readbroxtrajectories(filename_sequence_basename_frames_or_video.btracksfile); %,noblabels
                touchingmatrix=Gettouchingmatrixonlabelledvideo(labelledlevelvideo,btrajectories,noallsuperpixels,mapped,printonscreen);
                temporalsmoothing=false;
                LTT=Computelongerterm(touchingmatrix,temporalsmoothing,framebelong, options, theoptiondata, filenames);
                % Spywithcolor(LTT(1:1940,1:1940),2,mapped)
                % fTHR=-Inf; sTHR=Inf; frames=[2,25]; Showaffinityattwoframes(LTT,frames,labelledlevelvideo,mapped,numberofsuperpixelsperframe,fTHR,sTHR,263,cim);
            else
                fprintf('LTT request\n');
            end
        end
    end
    
    
    
    %ABA (Across-Boundary Appearance)
    if ( (Isaffinityrequested(requestedaffinities,'aba')) || (Computationrequestedaffinity(requestedaffinities,'aba',options)) || computeall )
        [ABA,boundarylengths]=Computeintraframe(ucm2,mapped,noallsuperpixels,labelledlevelvideo, options, theoptiondata, filenames); %#ok<NASGU>
        %     Spywithcolor(ABA(1:1204,1:1204),3,mapped)
        % fTHR=-Inf; sTHR=Inf; frames=[2,2]; Showaffinityattwoframes(ABA,frames,labelledlevelvideo,mapped,numberofsuperpixelsperframe,fTHR,sTHR,263,cim);
    end
    
    
    
    %ABM  (Across-Boundary Motion)
    if ( (Isaffinityrequested(requestedaffinities,'abm')) || (Computationrequestedaffinity(requestedaffinities,'abm',options)) || computeall )
        [conrr,concc]=Getconnectivityof(ABA);
        %     [conrr,concc]=Getconnectivityof(STT,LTT,ABA);
        
        uselocalvariance=false;
        [ABM,boundarylengths]=Computeflowdifference(ucm2,mapped,noallsuperpixels,flows,labelledlevelvideo,uselocalvariance,...
            conrr,concc,printonscreen, options, theoptiondata, filenames); %#ok<NASGU>
        %     Spywithcolor(ABM(1:1204,1:1204),4,mapped)
    end
    
    
    
    %STM (Spatio-Temporal Motion)
    if ( (Isaffinityrequested(requestedaffinities,'stm')) || (Computationrequestedaffinity(requestedaffinities,'stm',options)) || computeall )
        [conrr,concc]=Getconnectivityof(ABA);
        
        thedepth=2;
        temporaldepth=1; % temporaldepth=0 correspond to just spatial information
        STM=Computespatiotemporalvelocitylargerfast(labelledlevelvideo,numberofsuperpixelsperframe,concc,conrr,flows,mapped,thedepth,...
            STT,temporaldepth,printonscreen, options, theoptiondata, filenames);
        %     Spywithcolor(STM(1:1204,1:1204),5,mapped)
        % fTHR=-Inf; sTHR=Inf; frames=[1,2]; Showaffinityattwoframes(STM,frames,labelledlevelvideo,mapped,numberofsuperpixelsperframe,fTHR,sTHR,1016+263,cim);
        % fTHR=-Inf; sTHR=Inf; frames=[2,2]; Showaffinityattwoframes(STM,frames,labelledlevelvideo,mapped,numberofsuperpixelsperframe,fTHR,sTHR,263,cim);
        % fTHR=-Inf; sTHR=Inf; frames=[2,3]; Showaffinityattwoframes(STM,frames,labelledlevelvideo,mapped,numberofsuperpixelsperframe,fTHR,sTHR,263,cim);
    end
    
    
    
    %STA (Spatio-Temporal Appearance)
    if ( (Isaffinityrequested(requestedaffinities,'sta')) || (Computationrequestedaffinity(requestedaffinities,'sta',options)) || computeall )
        [conrr,concc]=Getconnectivityof(ABA);
        
        thedepth=2;
        temporaldepth=1;
        STA=Computeappearancesimilarity(labelledlevelvideo,numberofsuperpixelsperframe,concc,conrr,cim,mapped,thedepth,...
            STT,temporaldepth,printonscreen, options, theoptiondata, filenames);
        %     Spywithcolor(STA(1:1204,1:1204),6,mapped)
    end
    
    
    
    
    %Assemble similarities
    if ( (isfield(options,'mrgmth')) && (~isempty(options.mrgmth)) )
        mrgmth=options.mrgmth;
    else
        mrgmth='prod'; % prod, ssum, wsum
    end
    fprintf('mrgmth %s\n',mrgmth);
    if ( (isfield(options,'mrgwgt')) && (~isempty(options.mrgwgt)) )
        mrgwgt=options.mrgwgt;
    else
        mrgwgt=ones(1,6); %weight of [STT, LTT, ABA, ABM, STM, STA]
    end
    
    similarities=sparse(noallsuperpixels,noallsuperpixels);
    wgtsimilarities=0;
    
    if (Isaffinityrequested(requestedaffinities,'stt'))
        [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,STT,mrgmth,options,wgtsimilarities,mrgwgt(1));
    end
    if (Isaffinityrequested(requestedaffinities,'ltt'))
        [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,LTT,mrgmth,options,wgtsimilarities,mrgwgt(2));
    end
    if (Isaffinityrequested(requestedaffinities,'aba'))
        [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,ABA,mrgmth,options,wgtsimilarities,mrgwgt(3));
    end
    if (Isaffinityrequested(requestedaffinities,'abm'))
        [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,ABM,mrgmth,options,wgtsimilarities,mrgwgt(4));
    end
    if (Isaffinityrequested(requestedaffinities,'stm'))
        [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,STM,mrgmth,options,wgtsimilarities,mrgwgt(5));
    end
    if (Isaffinityrequested(requestedaffinities,'sta'))
        %     [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,STA,'wsum',options,0.9,0.1); %#ok<NASGU>
        [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,STA,mrgmth,options,wgtsimilarities,mrgwgt(6));
    end
    save(filenames.affinities,'STT','LTT','ABA','ABM','STM','STA','wgtsimilarities','similarities','mrgmth','mrgwgt');
else
    %@Hieu
    disp('Loading computed affinities');
    load(filenames.affinities);
end;
if (options.usingGeH == 1)
    if ~exist(filenames.GeHaffinities)
        GeH = sparse(noallsuperpixels,noallsuperpixels);
        GeH = wrapperforVSS( labelledlevelvideo,cim,filenames.flowpath);
        GeH = GeH.*(STA>0);
        save(filenames.GeHaffinities,'GeH');
    else
        load(filenames.GeHaffinities);
    end;
    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,GeH,mrgmth,options,wgtsimilarities,mrgwgt(6));
end;

if ( (~isfield(options,'complrqst')) || (~options.complrqst) )
    %If requestedaffinities has not been completed this code ensures full connectivity
    %This is just a debug option to not get errors for missing connectivity
    %However solutions of those cases will not be reliable
    if (~Isaffinityrequested(requestedaffinities,'ltt','stt','stm','sta'))
        similarities=similarities+LTT.*0.000001;
    end
    if (~Isaffinityrequested(requestedaffinities,'aba','abm','stm','sta'))
        similarities=similarities+ABA.*0.000001;
    end
end



%Ad hoc choice of similarities
if (false) %Area to define use of some, still computing all
    similarities=sparse(noallsuperpixels,noallsuperpixels); %#ok<UNRCH>
    wgtsimilarities=0;
    
    mrgwgt=ones(1,6); %weight of [STT, LTT, ABA, ABM, STM, STA]
    mrgmth='prod';
    
    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,STT,mrgmth,options,wgtsimilarities,mrgwgt(1));
    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,LTT,mrgmth,options,wgtsimilarities,mrgwgt(2));
    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,ABA,mrgmth,options,wgtsimilarities,mrgwgt(3));
    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,ABM,mrgmth,options,wgtsimilarities,mrgwgt(4));
    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,STM,mrgmth,options,wgtsimilarities,mrgwgt(5));
    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,STA,mrgmth,options,wgtsimilarities,mrgwgt(6));
    
    %     if (~Isaffinityrequested(requestedaffinities,'aba','abm','stm','sta'))
    %         similarities=similarities+ABA.*0.000001; %ensure no disconnected components
    %     end
    %     Spywithcolor(similarities(1:2981,1:2981),6,mapped)
    %     Savetoeps('Affinity3_marpleone5frames_fstltifefff.eps');
end



