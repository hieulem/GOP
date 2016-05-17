function similarities=Getsimilarityaggregated(theDir,avideoname,options,includecompletion)
%avideoname=allvideonames{i};


%Prepare options with setup cases
% options.stpcas='default';
if ( (~exist('includecompletion','var')) || (isempty(includecompletion)) )
    includecompletion=false;
end
if ( (~exist('options','var')) || (isempty(options)) )
    options=struct;
end
if ( (isfield(options,'stpcas')) && (~isempty(options.stpcas)) )
    options=Applysetupcase(options);
end
if ( (isfield(options,'requestedaffinities')) && (iscell(options.requestedaffinities)) )
    requestedaffinities=options.requestedaffinities;
else
    requestedaffinities={'stt','ltt','aba','abm','stm','sta'};
end
computeall=false;



if (includecompletion)
    %Adjust requestedaffinities on the base of dependencies
    requestedaffinities=Includeconnectivityrequested(requestedaffinities);
end



%STT (Short-Term Temporal)
if ( (Isaffinityrequested(requestedaffinities,'stt')) || (Computationrequestedaffinity(requestedaffinities,'stt')) || computeall )
    inFile= fullfile(theDir, [avideoname,'_stt_raw.mat']); %[thename, theext]
    load(inFile); %'sxa','sya','sva','labelsgt','noallsuperpixels'
    STT=Getsttfromindexedrawvalues(sxa, sya, sva, noallsuperpixels, options);
end

%LTT (Long-Term Temporal)
if ( (Isaffinityrequested(requestedaffinities,'ltt')) || (Computationrequestedaffinity(requestedaffinities,'ltt')) || computeall )
    inFile= fullfile(theDir, [avideoname,'_ltt_raw.mat']); %[thename, theext]
    load(inFile); %'sxa','sya','sva','labelsgt','noallsuperpixels'
    LTT=Getlttfromindexedrawvalues(sxa, sya, sva, noallsuperpixels, options);
end

%ABA (Across-Boundary Appearance)
if ( (Isaffinityrequested(requestedaffinities,'aba')) || (Computationrequestedaffinity(requestedaffinities,'aba')) || computeall )
    inFile= fullfile(theDir, [avideoname,'_aba_raw.mat']); %[thename, theext]
    load(inFile); %'sxa','sya','sva','labelsgt','noallsuperpixels'
    ABA=Getabafromindexedrawvalues(sxa, sya, sva, noallsuperpixels, options);
end

%ABM  (Across-Boundary Motion)
if ( (Isaffinityrequested(requestedaffinities,'abm')) || (Computationrequestedaffinity(requestedaffinities,'abm')) || computeall )
    inFile= fullfile(theDir, [avideoname,'_abm_raw.mat']); %[thename, theext]
    load(inFile); %'sxa','sya','sva','labelsgt','noallsuperpixels'
    ABM=Getabmfromindexedrawvalues(sxa, sya, sva, noallsuperpixels, options);
end

%STM (Spatio-Temporal Motion)
if ( (Isaffinityrequested(requestedaffinities,'stm')) || (Computationrequestedaffinity(requestedaffinities,'stm')) || computeall )
    inFile= fullfile(theDir, [avideoname,'_stm_raw.mat']); %[thename, theext]
    load(inFile); %'sxa','sya','sva','labelsgt','noallsuperpixels'
    STM=Getstmfromindexedrawvalues(sxa, sya, sva, noallsuperpixels, options);
end

%STA (Spatio-Temporal Appearance)
if ( (Isaffinityrequested(requestedaffinities,'sta')) || (Computationrequestedaffinity(requestedaffinities,'sta')) || computeall )
    inFile= fullfile(theDir, [avideoname,'_sta_raw.mat']); %[thename, theext]
    load(inFile); %'sxa','sya','sva','labelsgt','noallsuperpixels'
    STA=Getstafromindexedrawvalues(sxa, sya, sva, noallsuperpixels, options);
end



%Assemble similarities
if ( (isfield(options,'mrgmth')) && (~isempty(options.mrgmth)) )
    mrgmth=options.mrgmth;
else
    mrgmth='prod'; % prod, ssum, wsum
end
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
    [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,STA,mrgmth,options,wgtsimilarities,mrgwgt(6)); %#ok<NASGU>
end
