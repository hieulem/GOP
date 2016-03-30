function [gtmasks,validobjectmasks]=Gtmasksfromallcodes(gtimages,imagesizetwo,nomaxframes,noallobjects,allcode,framesforevaluation,noFrames,printonscreen,textallobjects)

if ( (~exist('noFrames','var')) || (isempty(noFrames)) )
    noFrames=numel(gtimages);
end
if ( (~exist('framesforevaluation','var')) || (isempty(framesforevaluation)) )
    framesforevaluation=1:noFrames;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('textallobjects','var')) || (isempty(textallobjects)) )
    printonscreen=false;
end


%Compute gtmasks by using allcode
gtmasks=false(imagesizetwo(1),imagesizetwo(2),nomaxframes,noallobjects);
validobjectmasks=false(nomaxframes,noallobjects);
for frame=framesforevaluation
    if (isempty(gtimages{frame}))
        continue;
    end
    for i=1:noallobjects
        if (numel(size(gtimages{frame}))>2)
            tmpmask=cat(3,ones(imagesizetwo).*allcode(i,1),ones(imagesizetwo).*allcode(i,2),ones(imagesizetwo).*allcode(i,3));
            gtmasks(:,:,frame,i)=all(gtimages{frame}==tmpmask,3);
        else
            tmpmask=ones(imagesizetwo).*allcode(i);
            gtmasks(:,:,frame,i)=(gtimages{frame}==tmpmask);
        end
        if (any(any(gtmasks(:,:,frame,i)))) %this identifies masks where the objects occur
            validobjectmasks(frame,i)=true;
            if (printonscreen)
                Init_figure_no(1);
                imshow(squeeze(gtmasks(:,:,frame,i)));
                title(['Frame ',num2str(frame),' - code ',textallobjects{i}]);
                pause(0.1);
            end
        end
    end
end
