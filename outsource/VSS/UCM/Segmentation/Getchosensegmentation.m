function valid=Getchosensegmentation(basenameforucm2,numberforucm2,closureforucm2,startNumberforucm2,...
    noFrames,ucm2filename,options,printtodisplay,...
    replaceucmanyway,processsomeframes,saveworkfiles, saveworkimages)
% printtodisplay=printonscreen;

if ( (~exist('processsomeframes','var')) || (isempty(processsomeframes)) )
    processsomeframes=[];
end
if ( (~exist('replaceucmanyway','var')) || (isempty(replaceucmanyway)) )
    replaceucmanyway=false;
end
if ( (~exist('printtodisplay','var')) || (isempty(printtodisplay)) )
    printtodisplay=false;
end
if ( (~exist('saveworkimages','var')) || (isempty(saveworkimages)) )
    saveworkimages=false;
end
if ( (~exist('saveworkfiles','var')) || (isempty(saveworkfiles)) )
    saveworkfiles=false;
end

if (~ispc)
    valid=Getthesegments(basenameforucm2,numberforucm2,closureforucm2,startNumberforucm2,...
        noFrames,ucm2filename,printtodisplay,...
        replaceucmanyway,processsomeframes,saveworkfiles,saveworkimages);
else
    valid=false;
end

