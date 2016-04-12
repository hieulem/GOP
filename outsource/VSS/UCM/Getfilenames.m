function filenames=Getfilenames(directory,casedir,options)

if (~exist('casedir','var'))
    casedir=[];
end
if (~exist('options','var'))
    options=[];
end

if (isempty(casedir))
    wherefs=strfind(directory,filesep);
    if (numel(wherefs)<=1)
        filenames.filename_directory=directory;
        casedir=[];
    else
        casedir=directory(wherefs(end-1)+1:wherefs(end)-1); %excludes filesep
        directory=directory(1:wherefs(end-1)); %includes filesep
        filenames.filename_directory=[directory,casedir,filesep];
    end
else
    filenames.filename_directory=[directory,casedir,filesep];
end
    
if (~isempty(casedir))
    casedirname=lower(casedir);
    wherefs=strfind(casedirname,filesep);
    casedirname(wherefs)='_';
else
    casedirname=[];
end

filenames.casedirname=casedirname; %lower case name of the chosen case with filesep's replaced with underscores
filenames.filename_colour_images=[filenames.filename_directory,'cim.mat'];
if ( (isfield(options,'usebflow')) && (options.usebflow) )
    filenames.filename_flows=[filenames.filename_directory,'bflows.mat'];
    filenames.filename_filtered_flows=[filenames.filename_directory,'bfilteredflows.mat'];
else
    filenames.filename_flows=[filenames.filename_directory,'flows.mat'];
    filenames.filename_filtered_flows=[filenames.filename_directory,'filteredflows.mat'];
end

filenames.idxpicsandvideobasedir=[filenames.filename_directory,'Videopicsidx',filesep];
filenames.the_isomap_yre=[filenames.idxpicsandvideobasedir,'yre.mat'];
filenames.videopicsidx_idx=[filenames.idxpicsandvideobasedir,'Idx',filesep];
filenames.videopicsidx_pics=[filenames.idxpicsandvideobasedir,'Pics',filesep];
filenames.videopicsidx_videos=[filenames.idxpicsandvideobasedir,'Videos',filesep];
filenames.the_tree_structure=[filenames.idxpicsandvideobasedir,'treestructure.mat'];

filenames.shareddir=[directory,'Shared',filesep]; %includes filesep

filenames.newucmtwo=[filenames.filename_directory,'newucmtwo.mat'];
filenames.benchmark=[filenames.shareddir,'Benchmark',filesep];
filenames.segres=[filenames.shareddir,'Benchmark',filesep];



