function filename_sequence_basename_frames_or_video=Olongtracks(filename_sequence_basename_frames_or_video,noFrames,filenames,cim)




otracksfile='Tracksnoframesochsbrox.dat'; %This is the file with the higher-order tracks



%The computed file is kept
[btracksbase,valid]=Locatefiledir(otracksfile,filenames.filename_directory);
if (valid)
    filename_sequence_basename_frames_or_video.otracksfile=[btracksbase,otracksfile];
    return;
end



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
    error('Writing of new b images with ppm extension\n');
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
motionsegcommand=['UCM',filesep,'Aggregation',filesep,'Quantitative',filesep,'Broxcode',filesep,'Higher',filesep,'motionsegOB'];
system( ['chmod u+x ',motionsegcommand] );
system( [motionsegcommand,' ',sprintf('%s %d %d %d', bmftmpfile, 0, noFrames, 8)] );
    %./motionsegOB marple1/marple1.bmf 0 100 8

%Move output file
outfilename=['Tracks',num2str(noFrames),'.dat'];
system( ['mv ',orignamesdir,'OchsBroxResults',filesep,outfilename,' ',filenames.filename_directory,otracksfile] );
%Set output filenames
filename_sequence_basename_frames_or_video.otracksfile=[filenames.filename_directory,otracksfile];
% filename_sequence_basename_frames_or_video.bflowdir=[orignamesdir,'OchsBroxResults',filesep]; %The computed flow is not kept, not this value assigned to the field name


%Clear all temporary files
delete(bmftmpfile);
for i=startnumber:(noFrames+startnumber-1)
    newpicturefilename=[basename,num2str(i,numberformat),newnameclosure];
    delete(newpicturefilename);
end
%The graphical output of point tracks are not deleted
system( ['rm -rf ',orignamesdir,filesep,'OchsBroxResults'] );

if (~exist([filenames.filename_directory,otracksfile],'file'))
    error(['File ',filenames.filename_directory,otracksfile,' not existent']);
end

