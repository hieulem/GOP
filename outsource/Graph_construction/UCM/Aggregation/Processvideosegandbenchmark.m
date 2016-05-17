function [allthesegmentations,newucm2]=Processvideosegandbenchmark(cim,flows,ucm2,filenames,options,...
            filename_sequence_basename_frames_or_video,videocorrectionparameters,printonscreen)

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end



timetic=tic;
dimtouse=6;
%Process video segmentation
allthesegmentations=Getvideosegmentation(filenames,ucm2,flows,printonscreen,dimtouse,options,filename_sequence_basename_frames_or_video,videocorrectionparameters,cim);
fprintf('Time elapsed for the whole video segmentation process '); toc(timetic); fprintf('\n\n\n\n\n\n');


if (isempty(allthesegmentations))
    error('allthesegmentations computation');
end

save(options.savepath,'allthesegmentations');


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
Addforbenchmarkcbm(allthesegmentations,options,filenames,filename_sequence_basename_frames_or_video,videocorrectionparameters,cim,printonscreen);



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
    %When allthesegmentations is passed newucm2 is not used
end













