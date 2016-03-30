function newcim=Croptheimages(cim,goodcroparea)
%[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left

noFrames=numel(cim);

firstnonempty=0;
for i=1:noFrames
    if (~isempty(cim{i}))
        firstnonempty=i;
        break;
    end
end
if ( firstnonempty==0 )
    fprintf('Sequence is empty\n');
    newcim=cim;
    return;
end

dimIi=size(cim{firstnonempty},1);
dimIj=size(cim{firstnonempty},2);

if (numel(goodcroparea)<1)
    thewidth=dimIj;
else
    thewidth=goodcroparea(1);
end
if (numel(goodcroparea)<2)
    theheight=dimIi;
else
    theheight=goodcroparea(2);
end


if (thewidth>dimIj)
    thewidth=dimIj;
    fprintf('Defined width is too large\n');
end
if (theheight>dimIi)
    theheight=dimIi;
    fprintf('Defined height is too large\n');
end

xstart=floor((dimIj-thewidth)/2)+1;
ystart=floor((dimIi-theheight)/2)+1;


if (numel(goodcroparea)<3)
    thexjshift=0;
else
    thexjshift=goodcroparea(3);
end

if ( ((xstart+thewidth-1+thexjshift)<=dimIj) && ((xstart+thexjshift)>=1) )
    xstart=xstart+thexjshift;
else
    fprintf('X shift not allowed\n');
end


if (numel(goodcroparea)<4)
    theyishift=0;
else
    theyishift=goodcroparea(4);
end

if ( ((ystart+theheight-1+theyishift)<=dimIi) && ((ystart+theyishift)>=1) )
    ystart=ystart+theyishift;
else
    fprintf('Y shift not allowed\n');
end


thecroparea=[xstart,ystart,thewidth-1,theheight-1];
newcim=cell(1,noFrames);
for i=1:noFrames
    if (isempty(cim{i}))
        continue;
    end
    newcim{i}=imcrop(cim{i},thecroparea); %thecroparea=[x/j_min(incl) y/i_min(incl) width-1 height-1]
end
