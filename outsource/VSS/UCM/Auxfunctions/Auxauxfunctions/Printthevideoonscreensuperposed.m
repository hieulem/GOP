function [coloredvideo,activeframes]=Printthevideoonscreensuperposed(thevideo, printonscreen, nofigure, toscramble, showcolorbar, writethevideo,treatoutliers,cim,mixpropvideo,outputfile,printthetext)
% thevideo=labelledvideo;
% thevideo(100:150,100:150,10)=-10;
% Printthevideoonscreensuperposed(thevideo, true, 1, true, [], [], true,cim);

if ( (~exist('printthetext','var')) || (isempty(printthetext)) )
    printthetext=true;
end
if ( (~exist('outputfile','var')) || (isempty(outputfile)) )
    outputfile=[];
end
if ( (~exist('mixpropvideo','var')) || (isempty(mixpropvideo)) )
    mixpropvideo=0.5;
end
if ( (~exist('cim','var')) || (isempty(cim)) )
    cim=[];
end
if ( (~exist('treatoutliers','var')) || (isempty(treatoutliers)) )
    treatoutliers=false;
end
if ( (~exist('writethevideo','var')) || (isempty(writethevideo)) )
    writethevideo=false;
end
if ( (~exist('showcolorbar','var')) || (isempty(showcolorbar)) )
    showcolorbar=false;
end
if ( (~exist('toscramble','var')) || (isempty(toscramble)) )
    toscramble=false;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('nofigure','var')) || (isempty(nofigure)) )
    nofigure=1;
end

thevideo=Printthevideoonscreen(thevideo, false, nofigure, toscramble, showcolorbar, false, treatoutliers,[],printthetext);
% thevideo=Printthevideoonscreen(thevideo, true, nofigure, true, false, false,true);

if (iscell(thevideo))
    noFrames=numel(thevideo);
    newvideo=zeros(size(thevideo{1},1),size(thevideo{1},2),noFrames);
    for f=1:noFrames
        newvideo(:,:,f)=thevideo{f};
    end
else
    noFrames=size(thevideo,3);
    newvideo=thevideo;
end

themax=double(max(newvideo(:)));

repratio = 2*(themax+1)/themax;
dimIi=size(newvideo,1);
dimIj=size(newvideo,2);
coloredvideo=cell(1,noFrames);
for f=1:noFrames
    coloredvideo{f}=zeros(dimIi,dimIj,3);
end
theframe=zeros(dimIi,dimIj);
theidmask=zeros(dimIi,dimIj);
for i=1:themax
    col=GiveDifferentColours(i,repratio);
    coloredframe=cat(3,ones(dimIi,dimIj).*col(1),ones(dimIi,dimIj).*col(2),ones(dimIi,dimIj).*col(3));
    for f=1:noFrames
        if (~any(newvideo(:)==i))
            continue;
        end
        theframe=newvideo(:,:,f);
        theidmask=(theframe==i);
        theidvol=cat(3,theidmask,theidmask,theidmask);
        coloredvideo{f}(theidvol)=coloredframe(theidvol);
    end
end

activeframes=true(1,noFrames);
if (~isempty(cim))
    for f=1:noFrames
        if (~isempty(cim{f}))
            coloredvideo{f}= uint8(255*mixpropvideo*coloredvideo{f} + double(cim{f})*(1-mixpropvideo));
        else
            coloredvideo{f}=ones([dimIi,dimIj]).*(-10);
            activeframes(f)=false;
        end
    end
else
    for f=1:noFrames
        coloredvideo{f}= uint8( 255*coloredvideo{f} );
    end
end

Printthevideoonscreen(coloredvideo, printonscreen, nofigure, false, showcolorbar, writethevideo,false,outputfile,printthetext);

% Printthevideoonscreen(coloredvideo, true, nofigure, false, showcolorbar, false, false);
% Init_figure_no(nofigure)
% for f=1:noFrames
%     imshow(coloredvideo{f})
%     pause(0.1)
% end


