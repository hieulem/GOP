function [newucm2,allthesegmentations]=Getucmmetricmergingwithdistance_withnewaff(filenames,ucm2,flows,printonscreen,...
    nofigure,dimtouse,options,filename_sequence_basename_frames_or_video,videocorrectionparameters,cim,gehoptions)



%% Input setup and similarities computation

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
if ( (~exist('nofigure','var')) || (isempty(nofigure)) )
    nofigure=1;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
printonscreeninsidefunction=false;

manifoldmethod='laplacian'; %'iso','isoii','laplacian'

%Level at which to threshold the UCM2 to get the superpixels
if ( (isfield(options,'ucm2level')) && (~isempty(options.ucm2level)) )
    Level=options.ucm2level;
else
    Level=1;
end

noFrames=numel(ucm2);

%Standard values for isomap and tree structure files and directory
% filenames.the_isomap_yre=[filenames.filename_directory,'Videopicsidx',filesep,'yre.mat'];
% filenames.idxpicsandvideobasedir=[filenames.filename_directory,'Videopicsidx',filesep];
% filenames.the_tree_structure=[filenames.filename_directory,'Videopicsidx',filesep,'treestructure.mat'];
tmpfilenames=filenames; %This is used to save partial results in partial files
%Changing filenames will also change the location of partial files

%Prapares a labelledlevelvideo for the requested Level (bwlabel and pixel sample)
[labelledlevelvideo,numberofsuperpixelsperframe]=Labellevelframes(ucm2,Level,noFrames,printonscreen);
% [labelledlevelcell,numberofsuperpixelsperframe]=Getalllabels(ucm2,Level,noFrames,printonscreen);



[mapped,framebelong,noallsuperpixels]=Mappedfromlabels(labelledlevelvideo); %,maxnumberofsuperpixelsperframe
fprintf('%d labels in total at level %d\n',noallsuperpixels, Level);
%mapped provides the index transformation from (frame,label) to similarities
%for inverse mapping
%[frame,label]=find(mapped==indexx);
%or
%[framebelong,labelsatframe,numberofelements]=Getmappedframes(mapped);



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
[similarities]=Getcombinedsimilarities_withnewaff(labelledlevelvideo,flows, ucm2, cim, mapped, ...
    filename_sequence_basename_frames_or_video, options, theoptiondata, filenames,...
    noallsuperpixels, framebelong, numberofsuperpixelsperframe, requestedaffinities, printonscreeninsidefunction,gehoptions);
%,STT,LTT,ABA,ABM,STM,STA

% if ( (isfield(options,'saveaff')) && (options.saveaff) && (isfield(options,'affaddname')) && (~isempty(options.affaddname)))
%     filename_to_assign='';
%     save(filename_to_assign,'similarities','mapped');
% end






%% Computation of clustering and ucm2



%Parameter setup
mergesegmoptions.n_size=0; %default is 7, 0 when neighbours have already been selected, (includes self-connectivity)
mergesegmoptions.saveyre=false; %The option also controls the loading
mergesegmoptions.setclustermethod='adhoc'; %'linear','log','distlinear','distlog','numberofclusters','logclusternumber','adhoc'
mergesegmoptions.desireducmlevels=255; %number of ucm2 levels, mainly for visualization purposes
mergesegmoptions.numberofclusterings=10; %Desired number of merge iterations or clustering numbers required, not used for k-means
mergesegmoptions.includeoversegmentation=true; %include oversegmented video into allthesegmentations and newucm2



[allthesegmentations,newucm2]=Clustermergesegment_withnewaff(ucm2,similarities,mapped,noFrames,options,...
    filenames,dimtouse,manifoldmethod,mergesegmoptions,noallsuperpixels,Level,filename_sequence_basename_frames_or_video,videocorrectionparameters,cim,printonscreen);
fprintf('\n\n\nVideo segmentation completed\n\n\n\n\n');



%% Print output

if (printonscreen)
    Init_figure_no(nofigure);
    for f=1:noFrames
        figure(nofigure), imagesc(newucm2{f})
        title(['New ucm2 frame ',num2str(f)]);
        pause(0.1);
    end
    f=ceil((noFrames-1)/2); %Leaves video positioned on central frame
    figure(nofigure), imagesc(newucm2{f})
    title(['New ucm2 frame ',num2str(f)]);
    pause(1);
    close(nofigure);
end




