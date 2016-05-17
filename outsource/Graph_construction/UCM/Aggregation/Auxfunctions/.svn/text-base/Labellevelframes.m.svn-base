function [labelledlevelvideo,numberofsuperpixelsperframe]=Labellevelframes(ucm2,Level,noFrames,printonscreen)
%Applies bwlabel at each frame to ucm2 and sample the image pixels
%(labels2(2:2:end, 2:2:end)). Each frame is stored into
%labelledlevelvideo(:,:,f)
%use Getalllabels for cell output

if ( (~exist('Level','var')) || (isempty(Level)) )
    Level=1; %level of interest (255:-1:1)
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

labels2=bwlabel(ucm2{1} < Level);
oneimage = labels2(2:2:end, 2:2:end);

dimimage=size(oneimage);

labelledlevelvideo=zeros([dimimage,noFrames]);
numberofsuperpixelsperframe=zeros(1,noFrames);
for frame=1:noFrames
    labels2 = bwlabel(ucm2{frame} < Level);
    labels=labels2(2:2:end, 2:2:end);
    labelledlevelvideo(:,:,frame) = labels;
    numberofsuperpixelsperframe(frame)=max(labels(:));
end

if (printonscreen)
    Printthevideoonscreen(labelledlevelvideo, printonscreen, 1);
end