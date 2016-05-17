function [allthelabels,numberofsuperpixelsperframe]=Getalllabels(ucm2,Level,noFrames,printonscreen)
%use Labellevelframes for array output

if ( (~exist('Level','var')) || (isempty(Level)) )
    Level=1;
end
if ( (~exist('noFrames','var')) || (isempty(noFrames)) )
    noFrames=numel(ucm2);
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

allthelabels=cell(1,noFrames);
numberofsuperpixelsperframe=zeros(1,noFrames);
for f=1:noFrames
    labels2 = bwlabel(ucm2{f} < Level);
    labels = labels2(2:2:end, 2:2:end);

    allthelabels{f}=labels;
    numberofsuperpixelsperframe(f)=max(labels(:));
end

if (printonscreen)
    Printthevideoonscreen(allthelabels, printonscreen, 1);
end