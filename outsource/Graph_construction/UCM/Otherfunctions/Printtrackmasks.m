function Printtrackmasks(dist_track_mask,image,nofigure,colourratio,colourforimage,colourforedges)

if ( (~exist('nofigure','var')) || (isempty(nofigure)) )
    nofigure=16;
end
if ( (~exist('colourratio','var')) || (isempty(colourratio)) )
    colourratio=1/2;
end
if ( (~exist('colourforimage','var')) || (isempty(colourforimage)) )
    colourforimage=[1,1,0];
end
if ( (~exist('colourforedges','var')) || (isempty(colourforedges)) )
    colourforedges=[1,0,0];
end
thickeredges=false;

Colourtheimage(image,dist_track_mask(1,:),nofigure,colourratio,colourforimage,colourforedges,thickeredges);
figure(nofigure)
title('First frame with regions and region edges marked');

