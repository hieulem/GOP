function [firstnonempty,firstisvalid]=Getfirstgtnonempty(gtimages,framesforevaluation,noFrames)


if ( (~exist('noFrames','var')) || (isempty(noFrames)) )
    noFrames=numel(gtimages);
end
if ( (~exist('framesforevaluation','var')) || (isempty(framesforevaluation)) )
    framesforevaluation=1:noFrames;
end

firstnonempty=0;
for frame=framesforevaluation
    if (isempty(gtimages{frame}))
        continue;
    else
        firstnonempty=frame;
        break;
    end
end

if (firstnonempty==0)
    firstisvalid=false;
else
    firstisvalid=true;
end
