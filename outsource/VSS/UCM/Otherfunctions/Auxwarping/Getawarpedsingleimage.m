function [theimage,validtop]=Getawarpedsingleimage(theflow,theimage,useinterp,validtop,printonscreen)
%The function warps the image theimage according to theflow, the computed flow
%from a reference image to theimage
%In other words theflow contains the displacement between the reference
%image and theimage, and this function warps theimage back to the reference image
% frame=10;
% theflow=cat(3,flows.flows{frame}.Up,flows.flows{frame}.Vp);
% tmpprint=true;
% Init_figure_no(50), imshow(cim{frame})
% title( 'Reference image' );
% useinterp=false;
% [Ccpm,validtop]=Getawarpedsingleimage(theflow,cim{frame+1},useinterp,[],tmpprint);


if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('useinterp','var')) || (isempty(useinterp)) )
    useinterp=true;
end
if ( (~exist('validtop','var')) || (isempty(validtop)) )
    rows=size(theimage,1);
    cols=size(theimage,2);
    validtop=true(rows,cols);
end

if (printonscreen)
    Init_figure_no(51), imshow(uint8(theimage))
    title( 'Original image' );
end

if (useinterp)
    [theimage,validtop]=Getsinglewarpedimagewithinterp(theflow,theimage,validtop);
else
    [theimage,validtop]=Getsinglewarpedimagewithoutinterp(theflow,theimage,validtop);
end

if (printonscreen)
    Init_figure_no(52), imshow(uint8(theimage))
    title( 'Warped image' );
end