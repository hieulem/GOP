function newcim=Deinterlaceimages(cim,keepboth,printtoscreen)
%use: newcim=Deinterlaceimages(cim);

if ( (~exist('keepboth','var')) || (isempty(keepboth)) )
    keepboth=false;
end
if ( (~exist('printtoscreen','var')) || (isempty(printtoscreen)) )
    printtoscreen=false;
end

noFrames=numel(cim);

if (noFrames<1)
    fprintf('Sequence is empty\n');
    newcim=cim;
    return;
end

firstnonempty=0;
for i=1:noFrames
    if (~isempty(cim{i}))
        firstnonempty=i;
        break;
    end
end
if ( firstnonempty==0 )
    fprintf('Sequence is empty\n');
    newcim=0;
    return;
end

dim=size(cim{firstnonempty});
dimIi=dim(1);
dimIj=dim(2);
% dimIc=dim(3);

newdimIi=floor(dimIi/2);
newdimIj=floor(dimIj/2);

if (keepboth)
    newcim=cell(1,2*noFrames);
else
    newcim=cell(1,noFrames);
end

count=0;
for i=1:noFrames
    if (isempty(cim{i}))
        count=count+1;
        if (keepboth)
            count=count+1;
        end
        continue;
    end
    
    if (keepboth)
        newimage=cim{i}(1:2:newdimIi*2,:,:);
        newimage=imresize(newimage,[newdimIi,newdimIj]);
        count=count+1;
        newcim{count}=newimage;
    end
    
    newimage=cim{i}(2:2:newdimIi*2,:,:);
    newimage=imresize(newimage,[newdimIi,newdimIj]);
    count=count+1;
    newcim{count}=newimage;
end

if (printtoscreen)
    Init_figure_no(1);
    for i=1:count
        if (isempty(newcim{i}))
            continue;
        end
        imshow(newcim{i});
        title(['frame ',num2str(i,'%03d')]);
        pause(1)
    end
    fprintf('Sizes of de-interlaced image are (%d,%d)\n',size(newcim{1},1),size(newcim{1},2))
end

