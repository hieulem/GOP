function [similarities,STT,LTT,ABA,ABM,STM,STA,CTR,STA3,STM3,SD,STT_max,STT_mean,Dspx]=Getcombinedsimilarities(labelledlevelvideo,flows, ucm2, cim, mapped, ...
    filename_sequence_basename_frames_or_video, options, theoptiondata, filenames,...
    noallsuperpixels, framebelong, numberofsuperpixelsperframe, requestedaffinities, printonscreen,sizeofsprpix)

%Initialization
STT=sparse(noallsuperpixels,noallsuperpixels); LTT=sparse(noallsuperpixels,noallsuperpixels);
ABA=sparse(noallsuperpixels,noallsuperpixels); ABM=sparse(noallsuperpixels,noallsuperpixels);
STM=sparse(noallsuperpixels,noallsuperpixels); STA=sparse(noallsuperpixels,noallsuperpixels);
CTR=sparse(noallsuperpixels,noallsuperpixels); SD = sparse(noallsuperpixels,noallsuperpixels);
STM3=sparse(noallsuperpixels,noallsuperpixels); STA3=sparse(noallsuperpixels,noallsuperpixels);
STT_max=sparse(noallsuperpixels,noallsuperpixels); STT_mean=sparse(noallsuperpixels,noallsuperpixels);
Dspx=sparse(noallsuperpixels,noallsuperpixels);

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
%  VLTTI            -                ABA            ABM STA STM
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

    timetic=tic;
    STT=Getshortterm_cpp_friendly(labelledlevelvideo, mapped, flows, graphdepth, multcount, options, theoptiondata, filenames);
    fprintf('Mex STT cpp friendly %f\n',toc(timetic));
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

            btrajectories=Readbroxtrajectories(filename_sequence_basename_frames_or_video.btracksfile);       
            timetic=tic;
            touchingmatrix=Gettouchingmatrixonlabelledvideo_cpp(labelledlevelvideo,btrajectories,noallsuperpixels,mapped,printonscreen);
            fprintf('LTT cpp %f\n',toc(timetic));  
            temporalsmoothing=false;
            [LTT, CTR] =Computelongerterm(touchingmatrix,temporalsmoothing,framebelong, options, theoptiondata, filenames);            
            
        else
            fprintf('LTT request\n');
        end
    end
end

%ABA (Across-Boundary Appearance)
if ( (Isaffinityrequested(requestedaffinities,'aba')) || (Computationrequestedaffinity(requestedaffinities,'aba',options)) || computeall )
    [ABA,boundarylengths]=Computeintraframe(ucm2,mapped,noallsuperpixels,labelledlevelvideo, options, theoptiondata, filenames); %#ok<NASGU>
end

%ABM  (Across-Boundary Motion)
if ( (Isaffinityrequested(requestedaffinities,'abm')) || (Computationrequestedaffinity(requestedaffinities,'abm',options)) || computeall )
    [conrr,concc]=Getconnectivityof(ABA);
%     [conrr,concc]=Getconnectivityof(STT,LTT,ABA);
    
    uselocalvariance=false;
    [ABM,boundarylengths]=Computeflowdifference(ucm2,mapped,noallsuperpixels,flows,labelledlevelvideo,uselocalvariance,...
        conrr,concc,printonscreen, options, theoptiondata, filenames); %#ok<NASGU>
end



%STM (Spatio-Temporal Motion)
if ( (Isaffinityrequested(requestedaffinities,'stm')) || (Computationrequestedaffinity(requestedaffinities,'stm',options)) || computeall )
    [conrr,concc]=Getconnectivityof(ABA);
    
    thedepth=2;
    temporaldepth=1; % temporaldepth=0 correspond to just spatial information
    timetic=tic;
    STM=Computespatiotemporalvelocitylargerfast_CPP_friendly(labelledlevelvideo,numberofsuperpixelsperframe,concc,conrr,flows,mapped,thedepth,...
        STT,temporaldepth,printonscreen, options, theoptiondata, filenames);
    fprintf('Non-mex STM cpp_friendly %f\n',toc(timetic));

  if options.new_features
    timetic=tic;
    STM3=Computespatiotemporalvelocitylargerfastchisquared(labelledlevelvideo,numberofsuperpixelsperframe,concc,conrr,flows,mapped,thedepth,...
    STT,temporaldepth,printonscreen, options, theoptiondata, filenames);
    fprintf('Chi squared histogram distance STM %f\n',toc(timetic));
 end
end
% Texture
if options.new_features
    [conrr,concc]=Getconnectivityof(ABA);    
    thedepth=2;
    temporaldepth=2;
    timetic=tic;
    [STT_max,STT_mean]=Computetexture(labelledlevelvideo,numberofsuperpixelsperframe,concc,conrr,cim,mapped,thedepth,STT,temporaldepth,printonscreen, options);
    fprintf('Texture %f\n',toc(timetic));
end
 
%STA (Spatio-Temporal Appearance)
if ( (Isaffinityrequested(requestedaffinities,'sta')) || (Computationrequestedaffinity(requestedaffinities,'sta',options)) || computeall )
    [conrr,concc]=Getconnectivityof(ABA);
    thedepth=2;
    temporaldepth=1;
    timetic=tic;
    STA=Computeappearancesimilaritycppfriendly(labelledlevelvideo,numberofsuperpixelsperframe,concc,conrr,cim,mapped,thedepth,...
        STT,temporaldepth,printonscreen, options, theoptiondata, filenames);
    fprintf('Mex/non mex cpp friendly STA %f\n',toc(timetic));
if options.new_features
    timetic=tic;
    STA3=Computeappearancesimilaritychisquared(labelledlevelvideo,numberofsuperpixelsperframe,concc,conrr,cim,mapped,thedepth,...
        STT,temporaldepth,printonscreen, options, theoptiondata, filenames);
    fprintf('Chi squared histogram distance STA %f\n',toc(timetic));
end
end

%Reduce max connectivity
% maxconnectivity=3;
% printthetext=true;
% makesimmetric=true;
% gisdistance=false;
% STTr = Selectkneighbours(STT,maxconnectivity,noallsuperpixels,printthetext,makesimmetric,gisdistance);
% ABAr = Selectkneighbours(ABA,maxconnectivity,noallsuperpixels,printthetext,makesimmetric,gisdistance);
% ABMr = Selectkneighbours(ABM,maxconnectivity,noallsuperpixels,printthetext,makesimmetric,gisdistance);
% STMr = Selectkneighbours(STM,maxconnectivity,noallsuperpixels,printthetext,makesimmetric,gisdistance);
% STAr = Selectkneighbours(STA,maxconnectivity,noallsuperpixels,printthetext,makesimmetric,gisdistance);

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
    mrgwgt=ones(1,7); %weight of [STT, LTT, ABA, ABM, STM, STA, VLTTI]
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
    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,STA,mrgmth,options,wgtsimilarities,mrgwgt(6));
end
%%

if ( (~isfield(options,'complrqst')) || (~options.complrqst) )
    %If requestedaffinities has not been completed this code ensures full connectivity
    %This is just a debug option to not get errors for missing connectivity
    %However solutions of those cases will not be reliable
    if (~Isaffinityrequested(requestedaffinities,'ltt','stt','stm','sta','vltti'))
        similarities=similarities+LTT.*0.000001;
    end
    if (~Isaffinityrequested(requestedaffinities,'aba','abm','stm','sta'))
        similarities=similarities+ABA.*0.000001;
    end
end
% end

if options.new_features

%Spatial distance
  timetic=tic;
 [conrr,concc]=Getconnectivityof(similarities);      
 [~,SD]=Computestd(labelledlevelvideo,numberofsuperpixelsperframe,concc,conrr,noFrames,noallsuperpixels);
  fprintf('SD %f\n',toc(timetic));

%Size ratio   
  timetic=tic;
[ii,jj] = find(similarities);
Dspx = sparse(ii,jj, min(abs(1-sizeofsprpix(jj)./sizeofsprpix(ii)),abs(1-sizeofsprpix(ii)./sizeofsprpix(jj))),noallsuperpixels,noallsuperpixels);
 fprintf('Dspx %f\n',toc(timetic));
 
end

%Ad hoc choice of similarities
if (false) %Area to define use of some, still computing all
    similarities=sparse(noallsuperpixels,noallsuperpixels); %#ok<UNRCH>
    wgtsimilarities=0;
    
    mrgwgt=ones(1,7); %weight of [STT, LTT, ABA, ABM, STM, STA, VLTTI]
    mrgmth='prod';

    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,STT,mrgmth,options,wgtsimilarities,mrgwgt(1));
    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,LTT,mrgmth,options,wgtsimilarities,mrgwgt(2));
    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,ABA,mrgmth,options,wgtsimilarities,mrgwgt(3));
    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,ABM,mrgmth,options,wgtsimilarities,mrgwgt(4));
    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,STM,mrgmth,options,wgtsimilarities,mrgwgt(5));
    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,STA,mrgmth,options,wgtsimilarities,mrgwgt(6));
end

end



