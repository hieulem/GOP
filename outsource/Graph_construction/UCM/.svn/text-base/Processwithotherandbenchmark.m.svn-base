function [allthesegmentations,newucm2]=Processwithotherandbenchmark(cim,filenames,options,...
        filename_sequence_basename_frames_or_video,videocorrectionparameters,printonscreen,ucm2,flows)

if ( (~exist('flows','var')) || (isempty(flows)) )
    flows=[];
end
if ( (~exist('ucm2','var')) || (isempty(ucm2)) )
    ucm2=[];
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end



if ( (isfield(options,'vsmethod')) && (~isempty(options.vsmethod)) && (strcmp(options.vsmethod,'bln')) && ((isempty(ucm2))||(isempty(flows))) )
    error('Computation of bln and ucm2/flows\n');
end
if ( (isfield(options,'vsmethod')) && (~isempty(options.vsmethod)) && ((strcmp(options.vsmethod,'dobho'))||(strcmp(options.vsmethod,'dob'))) && (isempty(ucm2)) )
    error('Computation of dob/dobho and ucm2\n');
end



%Process with other segmentation code
timetic=tic;
if ( (~isfield(options,'faffinityv')) || (isempty(options.faffinityv)) )
    [allthesegmentations,filename_sequence_basename_frames_or_video]=Processwithother(cim,filenames,options,...
        filename_sequence_basename_frames_or_video,videocorrectionparameters,printonscreen,ucm2,flows);
else % Subsets of cim allow to consider only some frames
    partlength=min(options.faffinityv,numel(cim));
    partcim=cim(1:partlength);
    if (~isempty(flows))
        partflows.whichDone=flows.whichDone(1:partlength);
        partflows.flows=flows.flows(1:partlength);
    else
        partflows=[];
    end
    if (~isempty(ucm2)), partucm2=ucm2(1:partlength); else partucm2=[]; end
    [allthesegmentations,filename_sequence_basename_frames_or_video]=Processwithother(partcim,filenames,options,...
        filename_sequence_basename_frames_or_video,videocorrectionparameters,printonscreen,partucm2,partflows);
end
%filename_sequence_basename_frames_or_video is modified within the function and is therefore returned
toc(timetic)
%Printthevideoonscreensuperposed(Doublebackconv(allthesegmentations{10}), true, 1, true, [], [], true, cim);



%In the case of GTNum a new casedir is generated to record all possible GT cases within the same benchmark folder
if ( (isfield(options,'vsmethod')) && (~isempty(options.vsmethod)) && (strcmp(options.vsmethod,'GTCase')) )
    if (  (isfield(options,'GTNum'))  &&  (~isempty(options.GTNum))  )
        GTNum=options.GTNum;
    else
        GTNum=1;
    end
    %Generate additional text for casedirname
    num2text={'one','two','three','four','five'};
    if (GTNum<numel(num2text))
        addtext=['_gt',num2text{GTNum},'_'];
    else
        addtext=['_gt',num2str(GTNum),'_'];
    end
    %Change casedirname to generate multiple GT of humans
    filenames.casedirname=[filenames.casedirname,addtext];
end



for i=1:numel(allthesegmentations)
    if (printonscreen)
        fprintf('Level %d number of labels %d\n',i,numel(unique(allthesegmentations{i})));
        Printthevideoonscreen(Doublebackconv(allthesegmentations{i}),printonscreen,1);
    end
end
%Printthevideoonscreensuperposed(Doublebackconv(allthesegmentations{10}), true, 1, true, [], [], true, cim);



%Compute corresponding UCM2 variable
COMPUTEUCMTWO=false;
if (COMPUTEUCMTWO)
    desireducmlevels=255;
    newucm2=Computeucmtwofromvideosegm(allthesegmentations,desireducmlevels,printonscreen);
    if (isempty(newucm2))
        error('newucm2 computation');
    end
else
    ucmtwolength=size(allthesegmentations{1},3);
    for i=1:numel(allthesegmentations)
        if ( size(allthesegmentations{i},3) ~= ucmtwolength ), ucmtwolength=max(ucmtwolength,size(allthesegmentations{i},3)); fprintf('\n\n\nLevel %d allthesegmentations with different length\n\n\n\n\n',i); end
    end
    newucm2=cell(1,ucmtwolength);
end



%Add the computed video segmentation for benchmark c and bm
minframes=min([numel(cim), numel(newucm2)]);
Addforbenchmarkcbm(allthesegmentations,options,filenames,filename_sequence_basename_frames_or_video,videocorrectionparameters,cim(1:minframes),printonscreen);



%Run benchmark code from Berkeley on the newucm2: add images to the directory
if ( (isfield(options,'testnewsegmentation')) && (~isempty(options.testnewsegmentation)) && (options.testnewsegmentation) )
    if ( (isfield(options,'newsegname')) && (~isempty(options.newsegname)) )
        additionalmasname=options.newsegname;
    else
        additionalmasname='Segmcfstltifefff'; fprintf('Using standard additional name %s, please confirm\n',additionalmasname); pause;
    end
    if ( (isfield(options,'neglectgt')) && (~isempty(options.neglectgt)) )
        neglectgt=options.neglectgt;
    else
        neglectgt=[];
    end
    
    maxgtframes=Inf; %used to restrict gt frames (impose same test set)
    minframes=min([numel(cim), numel(newucm2), maxgtframes]);
    Addcurrentimageforrpmultgt(cim(1:minframes),newucm2(1:minframes),filename_sequence_basename_frames_or_video,videocorrectionparameters,filenames,additionalmasname,printonscreen,allthesegmentations,neglectgt);
end






