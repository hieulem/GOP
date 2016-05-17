function [theimage,theflow,magnitude]=Getflowlegend(cols,rows,printonscreen)

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=true;
end
if ( (~exist('cols','var')) || (isempty(cols)) )
    cols=128;
end
if ( (~exist('rows','var')) || (isempty(rows)) )
    rows=128;
end
if (cols<20)
    cols=20;
end
if (rows<20)
    rows=20;
end

dimi=rows; %towards bottom
dimj=cols; %towards right
center=[(dimi-1)/2+1,(dimj-1)/2+1];

maxDist=abs(min(fix(center-5)));

magnitude=zeros(dimi,dimj);
theta=zeros(dimi,dimj);
theflow=zeros(dimi,dimj,2);
for i=1:dimi
    for j=1:dimj
        x=i-center(1);
        y=j-center(2);
        theta(i,j)=atan2(x,y);
        %as u is towards right and v is towards bottom, theta must be
        %consistent and be clock wise starting from u axis
        %otherwise one can write theta(i,j)=atan2(-x,y); and then use
        %-sin(theta(i,j))
        
        distCorrection=min((sqrt(x^2+y^2)/maxDist),1);
        
        magnitude(i,j)=distCorrection;
        
        theflow(i,j,1)= cos(theta(i,j))* distCorrection;
        theflow(i,j,2)= sin(theta(i,j))* distCorrection;
        
    end
end

theimage=flowToColor(theflow);

%u directed towards right, v directed towards bottom

if (printonscreen)
    Init_figure_no(300),imshow(theimage);
    title('Flow legend colour');

    Init_figure_no(301),imagesc(theta);
    title('Flow guide theta');

    Init_figure_no(302),imagesc(magnitude);
    title('Flow guide magnitude');
end


function Labrepresentation()

close all

[theimage,theflow,magnitude]=Getflowlegend(1024,512);
[Lab] = Rgbtolab(theimage,[],[], true);

Init_figure_no(300), imagesc(theflow(:,:,1))
Init_figure_no(301), imagesc(theflow(:,:,2))

minL=0; maxL=100;
minab=-86.1812575110439383; maxab=98.2351514395151639;

usemeanstd=false;usetanh=false;phasedifferencep=0;printonscreeninsidefunction=true;minflow=0;maxflow=1; %minflow=[];maxflow=[];

[aprime,bprime]=Rerangeflows(theflow(:,:,1),theflow(:,:,2),minab,maxab,usetanh,usemeanstd,phasedifferencep,minflow,maxflow,printonscreeninsidefunction);
% aprime=Rerangeimage(theflow(:,:,1),minab,maxab,usetanh,usemeanstd);
% bprime=Rerangeimage(theflow(:,:,2),minab,maxab,usetanh,usemeanstd);

Lab(:,:,1)=0.5*minL+0.5*maxL;
% Lab(:,:,1)= (0.5*minL+0.5*maxL) * sqrt((theflow(:,:,1).^2)+(theflow(:,:,2).^2));

Lab(:,:,2)=aprime;
Lab(:,:,3)=bprime;

[Rgb] = Labtorgb(Lab,[],[], true);

L=50;

