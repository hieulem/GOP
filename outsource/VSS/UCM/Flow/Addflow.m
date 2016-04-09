function flows=Addflow(flows,cim,frame,noFrames,printonscreen)

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
printonscreenfurtherprints=false; %false, printonscreen

image=cim{frame};
image=ToDblGray(image);
if frame>1
    imagem=cim{frame-1};
    imagem=ToDblGray(imagem);
else
    imagem=image;
end
if frame<noFrames
    imagep=cim{frame+1};
    imagep=ToDblGray(imagep);
else
    imagep=image;
end

rows=size(image,1);
cols=size(image,2);

if (~flows.whichDone(frame))

    [U,V]=meshgrid(1:cols,1:rows); %pixel coordinates

    if frame>1
        flowMinus=TV(image,imagem);
        Um=U+flowMinus(:,:,1);
        Vm=V+flowMinus(:,:,2);
    else
        Um=U;
        Vm=V;
    end
    if frame<noFrames
        flowPlus=TV(image,imagep);
        Up=U+flowPlus(:,:,1);
        Vp=V+flowPlus(:,:,2);
    else
        Up=U;
        Vp=V;
    end
    
    flows.flows{frame}.Um=Um;
    flows.flows{frame}.Vm=Vm;
    flows.flows{frame}.Up=Up;
    flows.flows{frame}.Vp=Vp;

    flows.whichDone(frame)=1; %sets the flag to not repeat the operation
end

% velUm=flows.flows{frame}.Um-U;
% velVm=flows.flows{frame}.Vm-V;
% velUp=flows.flows{frame}.Up-U;
% velVp=flows.flows{frame}.Vp-V;
[velUm,velVm,velUp,velVp]=GetUandV(flows.flows{frame});
% [VelUVm,VelUVp]=GetUandV(flows.flows{frame}); %VelUVm=[:,:,[Um,Vm]] VelUVp=[:,:,[Up,Vp]]

if (printonscreen)
    Init_figure_no(50);
    imagesc(flowToColor(cat(3,velUm,velVm)));
    title( ['Flow from frame ',num2str(max(1,frame)),' to previous frame'] );
    Init_figure_no(51);
    imagesc(flowToColor(cat(3,velUp,velVp)));
    title( ['Flow from frame ',num2str(max(1,frame)),' to following frame'] );
end

Cp=zeros(rows,cols);
Cp(:)=imagep( sub2ind(size(imagep),max(1,min(rows,round(flows.flows{frame}.Vp(:)))),max(1,min(cols,round(flows.flows{frame}.Up(:))))) );
Cm=zeros(rows,cols);
Cm(:)=imagem( sub2ind(size(imagem),max(1,min(rows,round(flows.flows{frame}.Vm(:)))),max(1,min(cols,round(flows.flows{frame}.Um(:))))) );

if (printonscreen)
    Init_figure_no(52), imshow(Cm)
    title( ['Image at frame ',num2str(max(1,frame-1)),' warped with flow'] );
    Init_figure_no(53), imshow(image)
    title( ['Image at frame ',num2str(frame)] );
    Init_figure_no(54), imshow(Cp)
    title( ['Image at frame ',num2str(min(noFrames,frame+1)),' warped with flow'] );
end

if (printonscreenfurtherprints)
    Init_figure_no(55), imshow(imagem)
    title( ['Image at frame ',num2str(max(1,frame-1))] );
    Init_figure_no(56), imshow(image)
    title( ['Image at frame ',num2str(frame)] );
    Init_figure_no(57), imshow(imagep)
    title( ['Image at frame ',num2str(min(noFrames,frame+1))] );
end

if (printonscreen) %Show confidence maps
    %Parameters
    useinterp=true;
    printonscreeninsidefunction=false;
    
    if ( (frame<noFrames) && (flows.whichDone(frame+1)) )
        %Forward flow
        theflow=cat(3,flows.flows{frame}.Up,flows.flows{frame}.Vp);
        backwardflow=cat(3,flows.flows{frame+1}.Um,flows.flows{frame+1}.Vm);
        
        [confidencemap,validity]=Getconfidencemap(theflow,backwardflow,useinterp,printonscreeninsidefunction);
        
        Init_figure_no(58), imagesc(confidencemap); title('Confidence map in pixels to following frame');
        Init_figure_no(59), imagesc(validity); title('Confidence map validity to following frame');
    end
    
    if ( (frame>1) && (flows.whichDone(frame-1)) )
        %Backward flow
        theflow=cat(3,flows.flows{frame}.Um,flows.flows{frame}.Vm);
        backwardflow=cat(3,flows.flows{frame-1}.Up,flows.flows{frame-1}.Vp);

        [confidencemap,validity]=Getconfidencemap(theflow,backwardflow,useinterp,printonscreeninsidefunction);

        Init_figure_no(60), imagesc(confidencemap); title('Confidence map in pixels to previous frame');
        Init_figure_no(61), imagesc(validity); title('Confidence map validity to previous frame');
    end
end




function Warpjustflow(flows,cim,frame,noFrames,printonscreen) %#ok<DEFNU>

%%%Example warp single image
frame=17;

theflow=cat(3,flows.flows{frame}.Up,flows.flows{frame}.Vp);

tmpprint=true;
useinterp=false;
[thewarpedimage,validtop]=Getawarpedsingleimage(theflow,cim{frame+1},useinterp,[],tmpprint);
Init_figure_no(53), imshow(cim{frame})
title( 'Reference image' );
Init_figure_no(54), imshow(validtop)
title( 'Reference image' );

%%%Example print confidence map
frame=15;
theflow=cat(3,flows.flows{frame}.Up,flows.flows{frame}.Vp);
tmpprint=true;
useinterp=false;
[Ubackwarped,validtopu]=Getawarpedsingleimage(theflow,flows.flows{frame+1}.Um,useinterp,[],tmpprint);
[Vbackwarped,validtopv]=Getawarpedsingleimage(theflow,flows.flows{frame+1}.Vm,useinterp,[],tmpprint);

rows=size(Ubackwarped,1);
cols=size(Ubackwarped,2);
[U,V]=meshgrid(1:cols,1:rows); %pixel coordinates

confidencemap=sqrt( (Ubackwarped-U).^2 + (Vbackwarped-V).^2 );
Init_figure_no(55), imagesc(confidencemap);
Init_figure_no(56), imagesc(validtopu&validtopv);


