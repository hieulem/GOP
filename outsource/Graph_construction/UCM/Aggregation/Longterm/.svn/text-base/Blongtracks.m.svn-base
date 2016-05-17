function filename_sequence_basename_frames_or_video=Blongtracks(filename_sequence_basename_frames_or_video,noFrames,filenames,cim)


basename=filename_sequence_basename_frames_or_video.basename;
numberformat=filename_sequence_basename_frames_or_video.number_format;
% nameclosure=filename_sequence_basename_frames_or_video.closure;
startnumber=filename_sequence_basename_frames_or_video.startNumber;

filesepfound=strfind(basename,filesep);
orignamesdir=basename(1:filesepfound(end));
basejustname=basename(filesepfound(end)+1:end);

newnameclosure='btmp.ppm';
    
printonscreen=false;
printthetextonscreen=false;
valid=Writepictureseries(cim,basename,numberformat,newnameclosure,startnumber,noFrames,printonscreen,printthetextonscreen);
if (~valid)
    fprintf('Writing of new b images with ppm extension\n');
    return;
end


%Create bmf file
bmftmpfile=[orignamesdir,'bmftmp.bmf'];
fid=fopen(bmftmpfile,'wt');
fprintf(fid,'%d %d\n',noFrames,1);

%Write ppm filenames into the bmf file
for i=startnumber:(noFrames+startnumber-1)
    filenamewrite=[basejustname,num2str(i,numberformat),newnameclosure];
    fprintf(fid,'%s\n',filenamewrite);
end
%mogrify -format ppm *.jpg

fclose(fid);

%Execute long term trajectory computation
motionsegcommand=['UCM',filesep,'Aggregation',filesep,'Quantitative',filesep,'Broxcode',...
    filesep,'motionsegBM'];
% setenv('LD_LIBRARY_PATH', '/home/khoreva/VSG_home/VSS/:$LD_LIBRARY_PATH');
system( ['chmod u+x ',motionsegcommand] );
system( [motionsegcommand,' ',sprintf('%s %d %d %d', bmftmpfile, 0, noFrames, 4)] );
    %./motionsegBM marple1/marple1.bmf 0 100 4

%Move output file
outfilename=['Tracks',num2str(noFrames),'.dat'];
if ( (~isfield(filename_sequence_basename_frames_or_video,'btracksfile')) || (isempty(filename_sequence_basename_frames_or_video.bdeffileorig)) )
    trackfilename='Tracksnoframes.dat';
else
    nobframes=Readnobframes(filename_sequence_basename_frames_or_video.bdeffileorig);
    trackfilename=['Tracks',num2str(nobframes),'.dat'];
%     trackfilename=['Tracks',num2str(noFrames),'.dat'];
end
system( ['mv ',orignamesdir,'BroxMalikResults',filesep,outfilename,' ',filenames.filename_directory,trackfilename] );
%Set output filenames
filename_sequence_basename_frames_or_video.btracksfile=[filenames.filename_directory,trackfilename];
filename_sequence_basename_frames_or_video.bflowdir=[orignamesdir,'BroxMalikResults',filesep];

%Clear all temporary files
delete(bmftmpfile);
for i=startnumber:(noFrames+startnumber-1)
    newpicturefilename=[basename,num2str(i,numberformat),newnameclosure];
    delete(newpicturefilename);
end
%The graphical output of point tracks are not deleted
% system( ['rm -rf ',orignamesdir,filesep,'BroxMalikResults'] );

if (~exist([filenames.filename_directory,trackfilename],'file'))
    error(['File ',filenames.filename_directory,trackfilename,' not existent']);
end



function btracksfile=Backup_move_output(filename_sequence_basename_frames_or_video,noFrames,orignamesdir,filenames) %#ok<DEFNU>

%Move output file
if (isempty(filename_sequence_basename_frames_or_video.bdeffileorig))
    trackfilename='Tracksnoframes.dat';
else
    trackfilename=['Tracks',num2str(noFrames),'.dat'];
end
system( ['mv ',orignamesdir,'BroxMalikResults',filesep,trackfilename,' ',filenames.filename_directory,trackfilename] );
%Set output filename
btracksfile=[filenames.filename_directory,trackfilename];
