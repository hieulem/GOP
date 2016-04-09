function Rgb=Getnewimages(cim,flows,usepureflow,usetanh,usemeanstd,minmax,printonscreen)
% Rgb=Getnewimages(cim,flows,true,true,true,[],true);
% Rgb=Getnewimages(cim,flows,true,false,false,[],true);
% Rgb=Getnewimages(cim,flows,false,true,true,[],true);

if ( (~exist('minmax','var')) || (isempty(minmax)) )
    [minflow, maxflow]=Minmaxflows(flows, true); %Computation of min and max across all flows (both fw and bw)
    %minflow=[], maxflow=[] normalizes with the maxima at each frame
    % minflow=0; maxflow=25;
else
    minflow=minmax(1);
    maxflow=minmax(2);
end
if ( (~exist('usetanh','var')) || (isempty(usetanh)) )
    usetanh=false;
end
if ( (~exist('usemeanstd','var')) || (isempty(usemeanstd)) )
    usemeanstd=false;
end
if ( (~exist('usepureflow','var')) || (isempty(usepureflow)) )
    usepureflow=false;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

imagepercentage=0.5;
wrppercentage=0.5;

printonscreeninsidefunction=false;

minL=0; maxL=100;
minab=-86.1812575110439383; maxab=98.2351514395151639;


noFrames=numel(cim);
Rgb=cell(1,noFrames);
for f=1:noFrames
    
    %Add normalised U and V vectors to the a and b channels
    [velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});
    phasedifferencep=0;
    phasedifferencem=pi;
    if (f==1)
        velUm=velUp;
        velVm=velVp;
        phasedifferencem=0;
    elseif (f==noFrames)
        velUp=velUm;
        velVp=velVm;
        phasedifferencep=pi;
    end
    
    theimage=cim{f};
    Lab=Rgbtolab(theimage);
    if (printonscreeninsidefunction)
        fprintf('L channel (%.16f,%.16f)\na channel (%.16f,%.16f)\nb channel (%.16f,%.16f)\n',...
            min(min(Lab(:,:,1))),max(max(Lab(:,:,1))),...
            min(min(Lab(:,:,2))),max(max(Lab(:,:,2))),...
            min(min(Lab(:,:,3))),max(max(Lab(:,:,3))) );
    end

    [aprimep,bprimep]=Rerangeflows(velUp,velVp,minab,maxab,usetanh,usemeanstd,phasedifferencep,minflow,maxflow,printonscreeninsidefunction);
    [aprimem,bprimem]=Rerangeflows(velUm,velVm,minab,maxab,usetanh,usemeanstd,phasedifferencem,minflow,maxflow,printonscreeninsidefunction);
%     Lprimep=Rerangeimage(sqrt((velUp.^2)+(velVp.^2)),minL,maxL,usetanh,usemeanstd);
%     Lprimem=Rerangeimage(sqrt((velUm.^2)+(velVm.^2)),minL,maxL,usetanh,usemeanstd);

    if (usepureflow)
        Lab(:,:,1)=0.5*minL+0.5*maxL;
        Lab(:,:,2)=0.5*aprimep+0.5*aprimem;
        Lab(:,:,3)=0.5*bprimep+0.5*bprimem;
    else
        % Lab(:,:,1)=imagepercentage*Lab(:,:,1)+0.5*wrppercentage*Lprime+0.5*wrppercentage*Lprime;
        Lab(:,:,2)=imagepercentage*Lab(:,:,2)+0.5*wrppercentage*aprimep+0.5*wrppercentage*aprimem;
        Lab(:,:,3)=imagepercentage*Lab(:,:,3)+0.5*wrppercentage*bprimep+0.5*wrppercentage*bprimem;
    end
    if (printonscreeninsidefunction)
        Init_figure_no(302), imagesc(Lab(:,:,2)), title('a channel');
        Init_figure_no(303), imagesc(Lab(:,:,3)), title('b channel');
    end
    
    Rgb{f}=Labtorgb(Lab);
end

if (printonscreen)
    Init_figure_no(20);
    for f=1:noFrames
        figure(20), imshow(Rgb{f})
        title( ['Image at frame ',num2str(f)] );
        pause(0.5);
    end
end