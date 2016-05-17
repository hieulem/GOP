function Rgb=Getnewimages(cim,flows,usepureflow,printonscreen)
% Rgb=Getnewimages(cim,flows,true,true);

if ( (~exist('usepureflow','var')) || (isempty(usepureflow)) )
    usepureflow=false;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

printonscreeninsidefunction=false;

minL=0; maxL=100;
minab=-86.1812575110439383; maxab=98.2351514395151639;

noFrames=numel(cim);
Rgb=cell(1,noFrames);
for f=1:noFrames
    
    %Add normalised U and V vectors to the a and b channels
    [velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});
    if (f<noFrames)
        Uflow=velUp;
        Vflow=velVp;
    else
        Uflow=velUm;
        Vflow=velVm;
    end
    
    theimage=cim{f};
    Lab=Rgbtolab(theimage);
    if (printonscreeninsidefunction)
        fprintf('L channel (%.16f,%.16f)\na channel (%.16f,%.16f)\nb channel (%.16f,%.16f)\n',...
            min(min(Lab(:,:,1))),max(max(Lab(:,:,1))),...
            min(min(Lab(:,:,2))),max(max(Lab(:,:,2))),...
            min(min(Lab(:,:,3))),max(max(Lab(:,:,3))) );
    end

    usemeanstd=true;
    [aprime,bprime]=Rerangeflows(Uflow,Vflow,minab,maxab,usemeanstd);
    % Lprime=Rerangeimage(sqrt((Uflow.^2)+(Vflow.^2)),minL,maxL,usemeanstd);

    if (usepureflow)
        Lab(:,:,1)=0.5*minL+0.5*maxL;
        Lab(:,:,2)=aprime;
        Lab(:,:,3)=bprime;
    else
        % Lab(:,:,1)=0.5*Lab(:,:,1)+0.5*Lprime;
        Lab(:,:,2)=0.5*Lab(:,:,2)+0.5*aprime;
        Lab(:,:,3)=0.5*Lab(:,:,3)+0.5*bprime;
    end
    if (printonscreeninsidefunction)
        Init_figure_no(302), imagesc(Lab(:,:,2)), title('a channel');
        Init_figure_no(303), imagesc(Lab(:,:,3)), title('b channel');
    end
    
    Rgb{f}=Labtorgb(Lab);
end

if (printonscreen)
    for f=1:noFrames
        Init_figure_no(20), imshow(Rgb{f})
        set(gcf, 'color', 'white');
        title( ['Image at frame ',num2str(f)] );
        pause(0.5)
    end
end