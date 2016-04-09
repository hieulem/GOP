function nobframes=Readnobframes(defdatfile)
%defdatfile=filename_sequence_basename_frames_or_video.bdeffile;
%Background has region number 1
%mColor2Region(colour +1)=region number +1

fid = fopen(defdatfile);

dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>

tline = fgetl(fid); %numbers of regions in string format
mRegionNo=str2double(tline); %number of regions including background

%mColor2Region(colour of the region +1) = index of region with 1 background
mColor2Region=zeros(256,1);
for i=1:mRegionNo
    dummy = fgetl(fid); %#ok<NASGU>
    tline = fgetl(fid);
    newnumber=str2double( tline );
    mColor2Region(newnumber+1) = i; %map of colours shifted of 1
end

dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>

%Confusion penalty matrix
aPenalty=zeros(mRegionNo);
for j=1:mRegionNo
    tline = fgetl(fid);
    startpos=1;
    for i=1:mRegionNo
        [anumber,startpos]=Findnextnumber(tline,startpos,' ');
        aPenalty(i,j)=anumber;
    end
end
        
dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>

tline = fgetl(fid);
nobframes=str2double(tline); %total number of frames

fclose(fid);

