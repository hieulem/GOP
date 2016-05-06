function [cim,ucm2,flows,allthesegmentations]=...
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters)



%Create needed directories
Createalldirs(filenames);
Createalldirs(ucm2filename);
Createalldirs(filename_sequence_basename_frames_or_video);



if (~exist('options','var'))
    options=[];
end
if (~exist('videocorrectionparameters','var'))
    videocorrectionparameters=0;
end
if ( (~isfield(options,'cleanifexisting')) || (isempty(options.cleanifexisting)) )
    cleanifexisting=Inf;
else
    cleanifexisting=options.cleanifexisting;
end
%cleanifexisting == n implies deleting and recomputing variables starting from n (also replaced)
% 0 all(bfiles), 1 cim, 2 flows, 3 ucm2, 4 filtered flows, 5 newucm2-allsegs
temporalmedianfilter=true;
temporalmediandepth=2; %1(4 flows in the median for +-1 frames), 2(8 flows in the median for +-2 frames)
twolessedges=false; %option to exclude one flow from the edge frames, unless already excluded at the first and last frames

printonscreen=false;


if (cleanifexisting==0) %This requests recomputation of all variables
    %This option is usually adopted for computing differently resized images
    %The Brox flow and long term trajectories are deleted
    if ( (isfield(filename_sequence_basename_frames_or_video,'btracksfile')) && (~isempty(filename_sequence_basename_frames_or_video.btracksfile)) &&...
            (exist(filename_sequence_basename_frames_or_video.btracksfile,'file')) )
        delete(filename_sequence_basename_frames_or_video.btracksfile)
        fprintf('btracksfile (%s) removed\n', filename_sequence_basename_frames_or_video.btracksfile);
        filename_sequence_basename_frames_or_video.btracksfile=[];
    end
    if ( (isfield(filename_sequence_basename_frames_or_video,'bflowdir')) && (~isempty(filename_sequence_basename_frames_or_video.bflowdir)) &&...
            (exist(filename_sequence_basename_frames_or_video.bflowdir,'dir')) )
        rmdir(filename_sequence_basename_frames_or_video.bflowdir,'s');
        fprintf('bflowdir (%s) removed\n', filename_sequence_basename_frames_or_video.bflowdir);
        filename_sequence_basename_frames_or_video.bflowdir=[];
    end
end

if ( (exist(filenames.filename_colour_images,'file')) && (cleanifexisting>1) )
    load(filenames.filename_colour_images);
    fprintf('Loaded colour images\n');
else
    %reads the frames
    cim=Readpictureseries(filename_sequence_basename_frames_or_video.basename,...
        filename_sequence_basename_frames_or_video.number_format,filename_sequence_basename_frames_or_video.closure,...
        filename_sequence_basename_frames_or_video.startNumber,noFrames,printonscreen);
    if (printonscreen)
        close all;
    end
    
    cim=Adjustimagesize(cim,videocorrectionparameters,printonscreen);
    %Adjustimagesize(cim,videocorrectionparameters,true);
    
    %saves the images
    save(filenames.filename_colour_images, 'cim','-v7.3');
    fprintf('Loaded colour images and saved\n');
end


%Computes the flows
if ( (exist(filenames.filename_flows,'file')) && (cleanifexisting>2) )
    load(filenames.filename_flows);
    fprintf('Loaded flows\n');
else
    %gets the flows
    fprintf('Computing all flows\n');
    tic
    flows.whichDone=zeros(1,noFrames); %Addflow does not change the flows which appear to be already done
    flows.flows=cell(1,noFrames);
    
    if ( (isfield(options,'usebflow')) && (options.usebflow) )
        [flows,filename_sequence_basename_frames_or_video]=Computebflow(filename_sequence_basename_frames_or_video,flows,noFrames,cim,filenames);
        %The function also modifies the fields btracksfile and bflowdir of filename_sequence_basename_frames_or_video
    else
        for i=1:noFrames
            flows=Addflow(flows,cim,i,noFrames,printonscreen);
        end
    end
    
    if (any(flows.whichDone==0))
        fprintf('Flow computation\n');
        flows=0; ucm2=0;
        return;
    end
    
    if (printonscreen)
        close all;
    end

    %saves the flows
    save(filenames.filename_flows, 'flows','-v7.3');
    toc
    fprintf('Flows computed and saved\n');
end


processsomeframes=[];
if ( (isfield(options,'testthesegmentation')) && (options.testthesegmentation) )
    printonscreeninsidefunction=false;
    
    %Read the single of mutliple gt annotations
    ntoreadmgt=Inf; %1, 2, .. Inf number of gts to read
    maxgtframes=Inf; %Limit max frame for gt (impose same test set)
    [multgts,gtfound,nonemptygt]=Loadmultgtimagevideo(noFrames,filename_sequence_basename_frames_or_video,ntoreadmgt,maxgtframes,printonscreeninsidefunction); %#ok<ASGLU> %,numbernonempty

    %verify that at least a gt image is present
    if (~gtfound)
        error('Segmentation test requested, but no gt found\n');
    end
    
    processsomeframes=find(any(nonemptygt,1));
end


if ( (~isfield(options,'origucm2')) || (isempty(options.origucm2)) || (options.origucm2) )
    replacetheucm=(cleanifexisting<=3);
    
    %%%Ucmorig
    
    %reads the segmented video frames
    [ucm2,valid]=Readpictureseries(ucm2filename.basename,...
        ucm2filename.number_format,ucm2filename.closure,...
        ucm2filename.startNumber,noFrames,printonscreen);

    if ( (~valid) || (replacetheucm) )

        additionalucmname=[]; %[]
        allowwarping=[]; %[] Boolean is for default: warping is used for wrpbasename cases
        [basenameforucm2,numberforucm2,closureforucm2,startNumberforucm2]=...
            Nameucmfiles(filename_sequence_basename_frames_or_video,cim,additionalucmname,allowwarping,flows,replacetheucm,printonscreen);

        %launch the segmentation algorithm in linux with basenameforucm2,
        %numberforucm2, closureforucm2, startNumberforucm2 to compute ucm2
        %and save them into ucm2filename
        clear flows; clear cim; %to free memory for the computation
        ucm2procvalid=Getchosensegmentation(basenameforucm2,numberforucm2,closureforucm2,startNumberforucm2,...
            noFrames,ucm2filename,options,printonscreen,replacetheucm,processsomeframes);
        if (~ucm2procvalid)
            fprintf('Could not compute the hierarchical segmentation (not a linux session?)\n');
            flows=0; cim=0;
            return;
        end

        %read the cim and flows and ucm2 files again, this part does not
        %check but assumes that the files all exist
        fprintf('Computation of hierarchical segments completed\n');
        load(filenames.filename_colour_images);
        load(filenames.filename_flows);
        [ucm2,valid]=Readpictureseries(ucm2filename.basename,...
            ucm2filename.number_format,ucm2filename.closure,...
            ucm2filename.startNumber,noFrames,printonscreen);
        fprintf('Re-loaded the colour images and flows and loaded the ucm2s (valid %d)\n',valid);
    end
else %This section skips deleting and reloading cim and flows
    replacetheucm=(cleanifexisting<=3);
    
    %Recipient for generated UCM2 segmentation with flow
    ucm2flow=ucm2filename;
    if ( (isfield(options,'usebflow')) && (options.usebflow) )
        ucm2flow.basename=[ucm2filename.basename,'bnew'];
    else
        ucm2flow.basename=[ucm2filename.basename,'new'];
    end
    
    
    %%%Ucmexp1notmed
    usepureflow=true; %true(just flow in ab), false(color ab with flow)
    usetanh=2; %true(tanh), false(linear remapping), 2((1-e^-x)/(1+e^-x))
    usemeanstd=false; %true(mean, std), false([min,max] or [0,1])
    minmax=[0,1];
    Rgb=Getnewimages(cim,flows,usepureflow,usetanh,usemeanstd,minmax,printonscreen);
    

    %Images from flow
    if ( (isfield(options,'usebflow')) && (options.usebflow) )
        colorflowname='bcfn'; %'colorflow'(color ab with flow), 'cfp'(just flow in ab), 'cfn'(just flow in ab normalized with min/max flows)
    else
        colorflowname='cfn'; %'colorflow'(color ab with flow), 'cfp'(just flow in ab), 'cfn'(just flow in ab normalized with min/max flows)
    end
    allowwarping=false;
    [basenameforcolor,numberforcolor,closureforcolor,startNumberforcolor]=...
        Nameucmfiles(filename_sequence_basename_frames_or_video,Rgb,colorflowname,allowwarping,flows,replacetheucm,printonscreen);
    
    %Images from original images
    if ( (isfield(options,'usebflow')) && (options.usebflow) )
        additionalucmname='bucm'; %TODO: this basename should be emtpy
    else
        additionalucmname='ucm'; %TODO: this basename should be emtpy
    end
    allowwarping=false;
    [basenameforucm2,numberforucm2,closureforucm2,startNumberforucm2]=...
        Nameucmfiles(filename_sequence_basename_frames_or_video,cim,additionalucmname,allowwarping,flows,replacetheucm,printonscreen);

    ucm2procvalid=Getchosensegmentationwithcolor(basenameforucm2,numberforucm2,closureforucm2,startNumberforucm2,...
        noFrames,ucm2flow,options,printonscreen,basenameforcolor,numberforcolor,closureforcolor,startNumberforcolor,replacetheucm,processsomeframes);
    if (~ucm2procvalid)
        fprintf('Could not compute the hierarchical segmentation (not a linux session?)\n');
        flows=0; cim=0;
        return;
    end
    
    %Adopt the new colored segmentation
    fprintf('Computation of colored hierarchical segments completed\n');
    [ucm2,valid]=Readpictureseries(ucm2flow.basename,...
        ucm2flow.number_format,ucm2flow.closure,...
        ucm2flow.startNumber,noFrames,printonscreen);
    fprintf('Loaded the ucm2s (valid %d)\n',valid);
end
%For interrupting calculation after segmentation
% flows=0; cim=0;
% return;


%Run benchmark code from Berkeley: add images to the directory
if ( (isfield(options,'testthesegmentation')) && (~isempty(options.testthesegmentation)) && (options.testthesegmentation) )
    if ( (isfield(options,'segaddname')) && (~isempty(options.segaddname)) )
        additionalmasname=options.segaddname;
    else
        additionalmasname='MAHIS_benchmark'; fprintf('Using standard additional name %s, please confirm\n',additionalmasname); pause;
    end
    Addcurrentimageforrpmultgt(cim,ucm2,filename_sequence_basename_frames_or_video,videocorrectionparameters,filenames,additionalmasname,printonscreen);
    
    return;
end

%Run benchmark code from Berkeley: process images in the directory
if (false)
    if ( (isfield(options,'segaddname')) && (~isempty(options.segaddname)) )
        additionalmasname=options.segaddname;
    else
        additionalmasname='MAHIS_benchmark'; fprintf('Using standard additional name %s, please confirm\n',additionalmasname); pause;
    end
    nthresh=255;
    requestdelconf=true;
    Computerpimvid(filenames,nthresh,additionalmasname,requestdelconf,0,'r',false,false);
    
%     Removebenchmarkdirimvid(filenames,additionalmasname);
%     Removetheoutputimvid(filenames,additionalmasname);
end


%Filter the flow temporally and compute statistcs
if (temporalmedianfilter)
    [flows]=Mediantimefilter(flows,temporalmediandepth,twolessedges); %,flowwasmodified
    fprintf('Flows temporally median filtered\n');
end


%Filter the flows
if ( (isfield(options,'filter_flow')) && (options.filter_flow) )
    if ( (isfield(options,'pre_filter_flow')) && (options.pre_filter_flow) )
        %for compatibility, if not indicated in options the flow is not pre-filtered
        if ( (exist(filenames.filename_filtered_flows,'file')) && (cleanifexisting>4) )
            load(filenames.filename_filtered_flows);
            fprintf('Loaded filtered flows\n');
        else %Filter the flow
            filtertic=tic;
            
            %Level at which to threshold the UCM2 to get the superpixels
            if ( (isfield(options,'ucm2level')) && (~isempty(options.ucm2level)) )
                Level=options.ucm2level;
            else
                Level=1;
            end
            %Get the labels at all frames at Level
            allthelabels=Getalllabels(ucm2,Level);

            %Filter the flows, not applied if flows.whichDone(f)==3
            flowfilter='median'; %median, bilateral
            if (strcmp(flowfilter,'median'))
                [flows,flowwasmodified]=Medianfilterflows(flows,allthelabels);
            else
                [flows,flowwasmodified]=Filtertheflows(flows,allthelabels);
            end
            if ( (flowwasmodified) || (~(exist(filenames.filename_filtered_flows,'file'))) ) %saves the flows if modified
                fprintf('Flows filtered\n');
                try
                    save(filenames.filename_filtered_flows, 'flows','-v7.3');
                    fprintf('Filtered flows saved\n');
                catch ME %#ok<NASGU>
                    fprintf('Filtered flows not saved (try..catch)\n');
                end
                toc(filtertic)
            else
                fprintf('Flows already filtered\n');
            end
        end
    end
    %To restore unfiltered flows
    % load(filenames.filename_flows);
end


if ( (isfield(options,'newucmtwo')) && (options.newucmtwo) ) %Compute temporally coherent ucm2, default value false
    if (   (exist(filenames.newucmtwo,'file'))   &&   (cleanifexisting>5)   &&   ...
            (... %parenthesis for the or cases
            (~options.testnewsegmentation)  ||...
            ( (options.testnewsegmentation) && (Isallsegsalreadycomputed(filenames,options)) )...
            )...%parenthesis for the or cases
               )
        load(filenames.newucmtwo);
        if (options.testnewsegmentation)
            allthesegmentations=Loadallsegs(filenames,options);
        end
        fprintf('Loaded newucmtwo file\n');
    else
        
        nofigure=1;
        printonscreen=false;
        dimtouse=6;
        
        timetic=tic;
        if ( (~isfield(options,'faffinityv')) || (isempty(options.faffinityv)) )
            [newucm2,allthesegmentations]=Getucmmetricmergingwithdistance(filenames,ucm2,flows,printonscreen,nofigure,dimtouse,options,...
                filename_sequence_basename_frames_or_video,videocorrectionparameters,cim);
        else % Subsets of ucm2 and flows allow to consider only some frames
            partlength=min(options.faffinityv,numel(ucm2));
            partucm2=ucm2(1:partlength);
            partcim=cim(1:partlength);
            partflows.whichDone=flows.whichDone(1:partlength);
            partflows.flows=flows.flows(1:partlength);
            [newucm2,allthesegmentations]=Getucmmetricmergingwithdistance(filenames,partucm2,partflows,printonscreen,nofigure,dimtouse,options,...
                filename_sequence_basename_frames_or_video,videocorrectionparameters,partcim);
        end
        toc(timetic)
        %Printthevideoonscreensuperposed(Doublebackconv(allthesegmentations{10}), true, 1, true, [], [], true, cim);
        
        save(filenames.newucmtwo, 'newucm2','-v7.3');

        outputimages=false;
        if (outputimages)
%             Printthevideoonscreen(newucm2, true, 10);
            newucm2basename=[filenames.idxpicsandvideobasedir,'Pics',filesep,'image'];
            Writepictureseries(newucm2,newucm2basename,'%03d','.bmp',0,numel(newucm2),true,true);
        end
    
        %Compatibility test
        if ( (~exist('allthesegmentations','var')) || (isempty(allthesegmentations)) )
            allthesegmentations=[];
        end

        %Run benchmark code from Berkeley on the newucm2: add images to the directory
        if ( (isfield(options,'testnewsegmentation')) && (~isempty(options.testnewsegmentation)) && (options.testnewsegmentation) )
            if ( (isfield(options,'newsegname')) && (~isempty(options.newsegname)) )
                additionalmasname=options.newsegname;
            else
                additionalmasname='Segmcfstltifefff'; fprintf('Using standard additional name %s, please confirm\n',additionalmasname); pause;
            end
            maxgtframes=Inf; %used to restrict gt frames (impose same test set)
            minframes=min([numel(cim), numel(newucm2), maxgtframes]);
            Addcurrentimageforrpmultgt(cim(1:minframes),newucm2(1:minframes),filename_sequence_basename_frames_or_video,videocorrectionparameters,filenames,additionalmasname,printonscreen,allthesegmentations);
        end
    end
    
    clear ucm2;
    ucm2=newucm2;
    clear newucm2;
end


%Clustering statistics benchmark
if (  ( (isfield(options,'testmanifoldclustering')) && (~isempty(options.testmanifoldclustering)) && (options.testmanifoldclustering) )  ||...
        ( (isfield(options,'testnewsegmentation')) && (~isempty(options.testnewsegmentation)) && (options.testnewsegmentation) )  )
    return;
end

        
%Run VS benchmark code (Boundary PR, SC, PRI, VI)
if (false)
    if ( (isfield(options,'newsegname')) && (~isempty(options.newsegname)) )
        additionalmasname=options.newsegname;
    else
        additionalmasname='VS_benchmark'; fprintf('Using standard additional name %s, please confirm\n',additionalmasname); pause;
    end
    nthresh=255;
    requestdelconf=true;
    Computerpimvid(filenames,nthresh,additionalmasname,requestdelconf,0,'r',false);
    
    nthresh=51;
    additionalmasname='VS_benchmark'; Computerpimvid(filenames,nthresh,additionalmasname,requestdelconf,0,'r',false);
    requestdelconf=false;

%     Removebenchmarkdirimvid(filenames,additionalmasname);
%     Removetheoutputimvid(filenames,additionalmasname);


    additionalmasname='VS_benchmark';
    Retrievevideosegmentations(filenames,additionalmasname);
    Retrievevideosegmentations(filenames,additionalmasname,'marple1',2);
    
end


%Run per-pixel error benchmark
if (false)
    if ( (isfield(options,'clustaddname')) && (~isempty(options.clustaddname)) )
        additionalname=options.clustaddname;
    else
        additionalname='VS_perpixelerror_benchmark'; fprintf('Using standard additional name %s, please confirm\n',additionalname); pause;
    end
    requestdelconf=true;
    Computecm(filenames,additionalname,requestdelconf);

%     Removebenchmarkmcdir(filenames,additionalname);
%     Removemctheoutput(filenames,additionalname);

requestdelconf=false;
additionalname='VS_perpixelerror_benchmark'; Computecm(filenames,additionalname,requestdelconf,'g');
requestdelconf=true;

end


