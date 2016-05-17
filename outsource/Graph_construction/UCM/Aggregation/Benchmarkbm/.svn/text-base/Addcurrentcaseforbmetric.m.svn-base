function Addcurrentcaseforbmetric(labelledvideo,stepk,filename_sequence_basename_frames_or_video,filenames,additionalbname)

if ( (~exist('additionalbname','var')) || (isempty(additionalbname)) )
    additionalbname='Bmcstltifeff';
end


[thebenchmarkdir,theDir,trackDir] = Benchmarkcreatebmetricdirs(filenames, additionalbname); %,isvalid
% rmdir(theDir,'s')
% rmdir(trackDir,'s')
% rmdir(thebenchmarkdir,'s')


%Write output to files

%Write tracks
noFrames=size(labelledvideo,3);
trackfilename=sprintf('C%g_%s_t%g.txt',stepk,filenames.casedirname,noFrames);
fulltrackfilename = fullfile(trackDir,trackfilename);
Writeblabelledvideo(labelledvideo,fulltrackfilename);

%Write def filename
if ( (isfield(filename_sequence_basename_frames_or_video,'bdeffile')) && (~isempty(filename_sequence_basename_frames_or_video.bdeffile)) )
    thedeffile=filename_sequence_basename_frames_or_video.bdeffile;
else
    fprintf('\nUsing a general name for the def filename\n\n');
    thedeffile='Def.dat';
end
filesfilename=sprintf('C%g_%s.txt',stepk,filenames.casedirname);
fullfilesfilename = fullfile(theDir,filesfilename);
fid = fopen(fullfilesfilename,'w');
if fid==-1,
    error('Could not open file %s for writing.',fullfilesfilename);
end
fprintf(fid,'%s\n%s\n', fulltrackfilename, thedeffile);
fclose(fid);

