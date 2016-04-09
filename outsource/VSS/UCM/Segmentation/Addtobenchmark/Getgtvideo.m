function [labelledgtvideo,nonemptyindex,numbernonempty,numberofobjects]=Getgtvideo(noFrames,filename_sequence_basename_frames_or_video,videocorrectionparameters,printonscreen)

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

%Prepare parameters
printonscreeninsidefunction=false;



%Read the ground truth video sequence or the frames
gtimages=Readpictureseries(filename_sequence_basename_frames_or_video.gtbasename,...
    filename_sequence_basename_frames_or_video.gtnumber_format,filename_sequence_basename_frames_or_video.gtclosure,...
    filename_sequence_basename_frames_or_video.gtstartNumber,noFrames,printonscreeninsidefunction);
gtimages=Adjustimagesize(gtimages,videocorrectionparameters,printonscreeninsidefunction,true);
if (printonscreeninsidefunction)
    close all;
end
% gtimages{1}=[];
% gtimages{10}=[];

%Visualization of gtimages
if (printonscreen)
    Init_figure_no(10)
    for f=1:numel(gtimages)
        agtimage=gtimages{f};
        if (~isempty(agtimage))
            imshow(agtimage);
        end
        pause(0.1);
    end
end

%Identify the existing ground truth
nonemptygt=false(1,numel(gtimages));
for f=1:noFrames
    nonemptygt(f)=(~isempty(gtimages{f}));
end
numbernonempty=sum(nonemptygt);

%Video sizes
firstnonempty=find(nonemptygt,1,'first');
dimi=size(gtimages{firstnonempty},1);
dimj=size(gtimages{firstnonempty},2);
colornumber=size(gtimages{firstnonempty},3);
numberofpixels=dimi*dimj;

%All colors from the ground truth are arranged into a colomn so as to run matlab unique command
allinrow=zeros(numberofpixels*numbernonempty,colornumber);
count=0;
for f=find(nonemptygt)
    startpos=numberofpixels*count+1;
    endpos=startpos-1+numberofpixels;
    count=count+1;
    for c=1:colornumber
        acolorimage=gtimages{f}(:,:,c);
        allinrow(startpos:endpos,c)=acolorimage(:);
    end
end

%Matlab unique command
[listofcolors,tmp,thenewrow] = unique(allinrow, 'rows'); %#ok<ASGLU>
numberofobjects=size(listofcolors,1);

%Determine a new labelledgtvideo with ground truth
%The indexes are parsed in the same order as for the construction of allinrow
labelledgtvideo=zeros(dimi,dimj,numbernonempty);
count=0;
nonemptyindex=find(nonemptygt);
for f=nonemptyindex
    startpos=numberofpixels*count+1;
    endpos=startpos-1+numberofpixels;
    count=count+1;
    
    animage=zeros(dimi,dimj);
    animage(:)=thenewrow(startpos:endpos);
    labelledgtvideo(:,:,count)=animage;
end

%Visualization of labelledgtvideo (the existing frames, as from nonemptyindex)
if (printonscreen)
    Printthevideoonscreen(labelledgtvideo, printonscreen, 6, false);
end






