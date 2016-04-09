function [multgts,valid,nfigure]=Readmultipleannotations(filename_sequence_basename_frames_or_video,noFrames,ntoreadmgt,printonscreen)
%In case of multiple gt images the basename denotes the directory basename,
%while the number format and closure apply to the single files inside the
%directories. These files may have an arbitrary name, but the first (with
%the extension as for closure) is used to read the dir in each dir.

if ( (~exist('ntoreadmgt','var')) || (isempty(ntoreadmgt)) )
    ntoreadmgt=Inf;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

[p,n,e]=fileparts(filename_sequence_basename_frames_or_video.gtbasename); %#ok<NASGU,ASGLU>

thedirs = dir([p,filesep,'*']);
% thedirs = dir([filename_sequence_basename_frames_or_video.gtbasename,'*']);

%Keep directories only
for i = numel(thedirs):-1:1
    if (~thedirs(i).isdir) || (strcmp(thedirs(i).name,'.')) || (strcmp(thedirs(i).name,'..'))
        thedirs(i)=[];
    end
end

%Read the specified number of multiple gts (ntoreadmgt) into multgts
ntoread=min(ntoreadmgt,numel(thedirs));
multgts=cell(1,ntoread);
valid=false(1,ntoread); nfigure=10;
for i = 1:ntoread
    allfiles=dir(fullfile(p,thedirs(i).name, ['*',filename_sequence_basename_frames_or_video.gtclosure] ));
    firstfilename=[p,filesep,thedirs(i).name,filesep,allfiles(1).name];

    newbasename=firstfilename(1: (end-numel(num2str(0,filename_sequence_basename_frames_or_video.gtnumber_format))-numel(filename_sequence_basename_frames_or_video.gtclosure)) );

    [multgts{i},valid(i),nfigure]=Readpictureseries(newbasename,...
        filename_sequence_basename_frames_or_video.gtnumber_format,filename_sequence_basename_frames_or_video.gtclosure,...
        filename_sequence_basename_frames_or_video.gtstartNumber,noFrames,printonscreen);
end


