function filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,bcasename)
%Output of this directory is added to filename_sequence_basename_frames_or_video:
%bdeffileorig, bdeffile, bdeffileframes, bdeffilenb, bdeffilenbf, btracksfile

%deffilebase is decided according to where the Def file is found
%search priority: - [filename_sequence_basename_frames_or_video.gtbasename] without filename beginning
%                 - [filenames.filename_directory]
%                 - [basedrive,'moseg_dataset_orig',filesep,bcasename]

%bcasename='Syntheticarbis';

%Prepare directories to search into
wherefs=strfind(filename_sequence_basename_frames_or_video.gtbasename,filesep);
if (numel(wherefs)<1) %Directory containing the ground truth images
    gtbasedir=filesep;
else
    gtbasedir=filename_sequence_basename_frames_or_video.gtbasename(1:wherefs(end)); %includes filesep
end
mosegcasedir=[basedrive,'moseg_dataset_orig',filesep,bcasename,filesep]; %Directory in moseg_dataset_orig for the video sequence (if present)



bdeffileorig=[bcasename,'Def.dat'];
[deffilebase,valid]=Locatefiledir(bdeffileorig,gtbasedir,filenames.filename_directory,mosegcasedir);
if (valid)
    filename_sequence_basename_frames_or_video.bdeffileorig=[deffilebase,bdeffileorig];
else
    filename_sequence_basename_frames_or_video.bdeffileorig=[];
end

bdeffile=[bcasename,'Defm.dat']; %modified, trajectory lengths are reduced according to UCM and SVS setup, and objects outside removed
[deffilebase,valid]=Locatefiledir(bdeffile,gtbasedir,filenames.filename_directory,mosegcasedir);
if (valid)
    filename_sequence_basename_frames_or_video.bdeffile=[deffilebase,bdeffile];
else
    filename_sequence_basename_frames_or_video.bdeffile=[];
end

bdeffileframes=[bcasename,'Defmf.dat']; %modified, trajectory lengths and end frames (also end frames and objects within are removed)
[deffilebase,valid]=Locatefiledir(bdeffileframes,gtbasedir,filenames.filename_directory,mosegcasedir);
if (valid)
    filename_sequence_basename_frames_or_video.bdeffileframes=[deffilebase,bdeffileframes];
else
    filename_sequence_basename_frames_or_video.bdeffileframes=[];
end

bdeffilenb=[bcasename,'Defnb.dat']; %no background
[deffilebase,valid]=Locatefiledir(bdeffilenb,gtbasedir,filenames.filename_directory,mosegcasedir);
if (valid)
    filename_sequence_basename_frames_or_video.bdeffilenb=[deffilebase,bdeffilenb];
else
    filename_sequence_basename_frames_or_video.bdeffilenb=[];
end

bdeffilenbf=[bcasename,'Defnbf.dat']; %no background some frames
[deffilebase,valid]=Locatefiledir(bdeffilenbf,gtbasedir,filenames.filename_directory,mosegcasedir);
if (valid)
    filename_sequence_basename_frames_or_video.bdeffilenbf=[deffilebase,bdeffilenbf];
else
    filename_sequence_basename_frames_or_video.bdeffilenbf=[];
end



%To locate btracksfile it is necessary to use filename_sequence_basename_frames_or_video.bdeffileorig
%btracksbase are decided according to where the TracksXX.dat or Tracksnoframes.dat file is found
%search priority: - [filename_sequence_basename_frames_or_video.gtbasename] without filename beginning
%                 - [filenames.filename_directory] (tracksnoframes)
%                 - [basedrive,'moseg_dataset_orig',filesep,bcasename,filesep,'BroxMalikResults',filesep]
mosegresultdir=[mosegcasedir,'BroxMalikResults',filesep];

if (isempty(filename_sequence_basename_frames_or_video.bdeffileorig))
    btracksfile='Tracksnoframes.dat'; %This means the trajectory was not part of the BVD dataset or output was computed separately
else
    %nobframes to be extracted from filenames.bdeffile
    nobframes=Readnobframes(filename_sequence_basename_frames_or_video.bdeffileorig);
    btracksfile=['Tracks',num2str(nobframes),'.dat'];
end

[btracksbase,valid]=Locatefiledir(btracksfile,gtbasedir,filenames.filename_directory,mosegresultdir);
if (valid)
    filename_sequence_basename_frames_or_video.btracksfile=[btracksbase,btracksfile];
else
    filename_sequence_basename_frames_or_video.btracksfile=[];
end



%Locate the optical flow .flo files computed with the algorithm of Brox, if
%present, or return an empty value for the struct field
mosegresultdir=[mosegcasedir,'BroxMalikResults',filesep];
wherefs=strfind(filename_sequence_basename_frames_or_video.basename,filesep);
if (numel(wherefs)<1) %Directory containing the original images
    origbasedirplusresults=[filesep,'BroxMalikResults',filesep];
else
    origbasedirplusresults=[filename_sequence_basename_frames_or_video.basename(1:wherefs(end)),'BroxMalikResults',filesep]; %includes filesep
end
bflowfile='ForwardFlow000.flo'; %we assume all directories containing optical flow outputs have this filename at least
[bflowdir,valid]=Locatefiledir(bflowfile,origbasedirplusresults,mosegresultdir);
if (valid)
    filename_sequence_basename_frames_or_video.bflowdir=bflowdir;
else
    filename_sequence_basename_frames_or_video.bflowdir=[];
end
