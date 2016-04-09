function [cim,nfigure]=Adjustimagesize(cim,videocorrectionparameters,printtoscreen,isgroundtruth)
%use: newcim=Adjustimagesize(cim,videocorrectionparameters,printtoscreen,isgroundtruth);

% videocorrectionparameters.deinterlace=true;
% videocorrectionparameters.rszratio=0.8;
    %if 0 image is not resized
% videocorrectionparameters.croparea=[640 480 +-20 +-10];
    %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left



if ( (~exist('isgroundtruth','var')) || (isempty(isgroundtruth)) )
    isgroundtruth=false;
end
if ( (~exist('printtoscreen','var')) || (isempty(printtoscreen)) )
    printtoscreen=false;
end
if ( (~exist('videocorrectionparameters','var')) || (~isstruct(videocorrectionparameters)) )
    return; %no changes are made in this case
end

noFrames=numel(cim);
nfigure=10;

firstnonempty=0;
for i=1:noFrames
    if (~isempty(cim{i}))
        firstnonempty=i;
        break;
    end
end
if ( firstnonempty==0 )
    fprintf('Sequence is empty\n');
    return;
end



%de-interlace the images if deinterlace is defined and true
if ( (isfield(videocorrectionparameters,'deinterlace')) && (videocorrectionparameters.deinterlace) )
    cim=Deinterlaceimages(cim);
    fprintf('Size of de-interlaced images is (%d,%d)\n',size(cim{firstnonempty},1),size(cim{firstnonempty},2))
end



%resize the images if rszratio is defined and ~=0
if ( (isfield(videocorrectionparameters,'rszratio')) && (videocorrectionparameters.rszratio~=0) )
    for i=1:noFrames
        if (isempty(cim{i}))
            continue;
        end
        if (isgroundtruth) %A different method is adopted in the case of ground truth, to not create new label values
            cim{i}=imresize(cim{i},videocorrectionparameters.rszratio,'nearest');
        else
            cim{i}=imresize(cim{i},videocorrectionparameters.rszratio);
        end
    end
    fprintf('Size of re-sized images is (%d,%d)\n',size(cim{firstnonempty},1),size(cim{firstnonempty},2))
end



%crop the images if croparea is defined
if ( (isfield(videocorrectionparameters,'croparea')) && (~isempty(videocorrectionparameters.croparea)) )
    cim=Croptheimages(cim,videocorrectionparameters.croparea);
        %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
    fprintf('Size of cropped images is (%d,%d)\n',size(cim{firstnonempty},1),size(cim{firstnonempty},2))
end



if (printtoscreen)
    Init_figure_no(nfigure);
    for i=1:noFrames
        if (isempty(cim{i}))
            continue;
        end
        imshow(cim{i});
        title(['frame ',num2str(i,'%02d')]);
        pause(0.5)
    end
    fprintf('Size of adjusted images is (%d,%d)\n',size(cim{firstnonempty},1),size(cim{firstnonempty},2))
end
