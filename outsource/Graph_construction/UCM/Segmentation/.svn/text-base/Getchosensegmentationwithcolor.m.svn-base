function valid=Getchosensegmentationwithcolor(basenameforucm2,numberforucm2,closureforucm2,startNumberforucm2,...
    noFrames,ucm2filename,options,printtodisplay,basenameforcolor,numberforcolor,closureforcolor,startNumberforcolor,...
    replaceucmanyway,processsomeframes,saveworkfiles,saveworkimages)

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

if ( (~exist('options','var')) || (~isfield(options,'quickshift')) || (~options.quickshift) )
    if (~ispc)
        valid=Getthesegmentswithcolor(basenameforucm2,numberforucm2,closureforucm2,startNumberforucm2,...
            noFrames,ucm2filename,printtodisplay,basenameforcolor,numberforcolor,closureforcolor,startNumberforcolor,...
            replaceucmanyway,processsomeframes,saveworkfiles,saveworkimages);
    else
        valid=false;
    end
else
    printtodisplay=true;
    valid=Getsegmentswithquickshift(basenameforucm2,numberforucm2,closureforucm2,startNumberforucm2,...
        noFrames,ucm2filename,printtodisplay,replaceucmanyway,processsomeframes);
end



function Visualizetheucm(ucm2) %#ok<DEFNU>


ucm2s=cell(1,numel(ucm2));
for f=1:numel(ucm2)
    ucm2s{f}=ucm2{f}(3:2:end, 3:2:end);
end

nofigure=1;
Init_figure_no(nofigure); colormap('gray');
Printthevideoonscreen(ucm2s,true,nofigure);
Printthevideoonscreen(ucm2s,true,nofigure,[],[],true);


