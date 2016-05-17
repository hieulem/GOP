function allthesegmentations=Getvideosegmentation(filenames,ucm2,flows,printonscreen,dimtouse,options,filename_sequence_basename_frames_or_video,videocorrectionparameters,cim,gehoptions)
%Function shares code with Affinityfromsuperpixels
%%%%%%%%%%HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
%% Set up input and compute similarities
if ~exist(filenames.affinity_matrices,'file')
    
    
    if (~exist('options','var'))
        options=[];
    end
    if (~exist('theoptiondata','var'))
        theoptiondata=[];
    end
    %prepare calibration parameters options
    if ( (isfield(options,'calibratetheparameters')) && (~isempty(options.calibratetheparameters)) && (options.calibratetheparameters) )
        if ( (isfield(options,'calibrateparametersname')) && (~isempty(options.calibrateparametersname)) )
            paramcalibname=options.calibrateparametersname;
        else
            paramcalibname='Paramcstltifefff'; fprintf('Using standard additional name %s for parameter calibration, please confirm\n',paramcalibname); pause;
        end
    else
        options.calibratetheparameters=false;
    end
    if ( (~exist('dimtouse','var')) || (isempty(dimtouse)) )
        dimtouse=6;
    end
    if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
        printonscreen=false;
    end
    printonscreeninsidefunction=false;
    
    %Level at which to threshold the UCM2 to get the superpixels
    if ( (isfield(options,'ucm2level')) && (~isempty(options.ucm2level)) )
        Level=options.ucm2level;
    else
        Level=1;
    end
    
    noFrames=numel(ucm2);
    
    %Prepares a labelledlevelvideo for the requested Level (bwlabel and pixel sample)
    [labelledlevelvideo,numberofsuperpixelsperframe]=Labellevelframes(ucm2,Level,noFrames,printonscreen);
    
    [mapped,framebelong,noallsuperpixels]=Mappedfromlabels(labelledlevelvideo); %,maxnumberofsuperpixelsperframe
    fprintf('%d number of superpixels in total at level %d (%d frames)\n',noallsuperpixels, Level, noFrames);
    %mapped provides the index transformation from (frame,label) to similarities
    %for inverse mapping
    %[frame,label]=find(mapped==indexx);
    
    [sizeofsprpix] = Sizeofsuperpixels(labelledlevelvideo,numberofsuperpixelsperframe, noallsuperpixels);
    %%
    %Prepare the parameter calibration ground truth
    if (options.calibratetheparameters)
        theoptiondata.labelsgt=Labelsfromgt(filename_sequence_basename_frames_or_video,mapped,ucm2,...
            videocorrectionparameters,printonscreen);
        theoptiondata.paramcalibname=paramcalibname;
    end
    
    
    
    %Computation of all affinities and combination in similarities
    if ( (isfield(options,'requestedaffinities')) && (iscell(options.requestedaffinities)) )
        requestedaffinities=options.requestedaffinities;
    else
        if (isfield(options,'requestedaffinities'))
            fprintf('Field in place but not cell\n');
        end
        requestedaffinities={'stt','ltt','aba','abm','stm','sta'};
    end
    
    if ( (isfield(options,'softdecision')) )
        softdecision=options.softdecision;
    else
        softdecision=true;
    end
    
    if ( (isfield(options,'map')) )
        map=options.map;
    else
        map=true;
    end
    
    if ~( (isfield(options,'new_features')) )
        options.new_features = 1;
    end
    
    if ~(isfield(options,'manifoldcl'))
        options.manifoldcl='km3new';
    end
    
    if  (isfield(options,'plmultiplicity'))
        plmultiplicity=options.plmultiplicity;
    else
        plmultiplicity=false;
    end
    
    if ( (isfield(options,'size1spx')))
        size1spx=options.size1spx;
    else
        size1spx=false;
    end
    
    
    [similarities,STT,LTT,ABA,ABM,STM,STA,CTR,STA3,STM3,SD,STT_max,STT_mean,Dspx] =Getcombinedsimilarities(labelledlevelvideo,flows, ucm2, cim, mapped, ...
        filename_sequence_basename_frames_or_video, options, theoptiondata, filenames,...
        noallsuperpixels, framebelong, numberofsuperpixelsperframe, requestedaffinities, printonscreeninsidefunction,sizeofsprpix);
    save(filenames.affinity_matrices,'similarities','STT','LTT','ABA','ABM','STM','STA','CTR','STA3','STM3'...
        ,'SD','STT_max','STT_mean','Dspx');
else
    load(filenames.affinity_matrices);
    display('Computed affinities, Just loading');
end;

try
    gehoptions;
    
catch
    display('No gehoptions, just run the baseline');
end

%% Learned graph
if (options.within||options.across_2||options.across_n||options.across1||options.across2)
    similarities = Getnewgraph(STT,LTT,ABA,ABM,STM,STA,STM3,STA3,SD,STT_max,STT_mean,Dspx,CTR,noallsuperpixels,framebelong, options,softdecision,map);
end

%% Reweight similarities if requested
if ( (isfield(options,'uselevelfrw')) && (~isempty(options.uselevelfrw)) && (options.uselevelfrw) )
    [similarities]=Reweightwithhypercliquecardinality(similarities,labelledlevelvideo,options,ucm2,printonscreen);
end



%% Computate clustering from matrix of similarities

%Assign unique labels to superpixels (used in computing the correspondence matrix)
labelledlevelunique=labelledlevelvideo;
count=0;
for f=2:size(labelledlevelunique,3)
    count=count+max(max(labelledlevelvideo(:,:,(f-1))));
    labelledlevelunique(:,:,f)=labelledlevelunique(:,:,f)+count;
end
% noallsuperpixels=count+max(max(labelledlevelvideo(:,:,size(labelledlevelunique,3))));

%Parameter setup
mergesegmoptions.n_size=0; %default is 7, 0 when neighbours have already been selected, (includes self-connectivity)
mergesegmoptions.saveyre=false; %The option also controls the loading
%Define the clustering and number of cluster method:
% - 'manifoldcl'
%   - 'numberofclusters','logclusternumber','adhoc', [1,2,3,...] referring to k-means,
%       [1,2,3,...] used to determine the divisive coefficients for dbscan or the requested clusters for optics
% - 'distances'
%   - 'linear','log','distlinear','distlog' refer to the merging based on the distances or manifold distances
mergesegmoptions.setclustermethod='manifoldcl'; %'manifoldcl', 'distances'
mergesegmoptions.clusternumbermethod=options.scmethod;%'adhoc';%'1spectclust'; %'linear','log','distlinear','distlog','numberofclusters','logclusternumber','adhoc',[1,2,3,...]
%mergesegmoptions.clusternumbermethod='adhoc'; %'linear','log','distlinear','distlog','numberofclusters','logclusternumber','adhoc', [1,2,3,...]
mergesegmoptions.numberofclusterings=10; %Desired number of hierarchical levels, not used if 'adhoc' or actual cluster numbers are defined
mergesegmoptions.includethesuperpixels=true; %include oversegmented video into allthesegmentations and newucm2
mergesegmoptions.manifoldmethod='laplacian'; %'iso','isoii','laplacian'
mergesegmoptions.dimtouse=dimtouse;
mergesegmoptions.manifoldclustermethod=options.manifoldcl;%;'km3'; %'km','km3','dbscan','optics', used in combination with 'manifoldcl'
mergesegmoptions.manifolddistancemethod='euclidian'; %[option for setclustermethod='distances'] 'origd','euclidian'(default),'spectraldiffusion'

if (   (isfield(options,'clustcompnumbers'))   &&   (~isempty(options.clustcompnumbers))   )
    mergesegmoptions.clusternumbermethod=options.clustcompnumbers;
end

allthesegmentations=Clustervideosegmentation(similarities,labelledlevelunique,options,filenames,mergesegmoptions, plmultiplicity);

fprintf('\n\n\nVideo segmentation completed\n\n\n\n\n');
end



