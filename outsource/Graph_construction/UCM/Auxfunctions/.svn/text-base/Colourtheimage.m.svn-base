function colouredimage=Colourtheimage(image,mask,nofigure,colourratio,colourforimage,colourforedges,thickeredges)


if ( (~exist('nofigure','var')) || (isempty(nofigure)) )
    nofigure=16;
end
if ( (~exist('colourratio','var')) || (isempty(colourratio)) )
    colourratio=1/2;
end
if ( (~exist('colourforimage','var')) || (isempty(colourforimage)) )
    colourforimage=[1,1,0]; %yellow
end
if ( (~exist('colourforedges','var')) || (isempty(colourforedges)) )
    colourforedges=[1,0,0]; %red
end
if ( (~exist('thickeredges','var')) || (isempty(thickeredges)) )
    thickeredges=false;
end

%initialisation of necessary parts (strel and frameEdge)
SE=Getstrel(thickeredges);
frameEdge=Getframeedge(size(image,1),size(image,2));

noncolourratio=1-colourratio;
colourforedges=uint8(round(colourforedges*255));
colourforimage=uint8(round(colourforimage*255*colourratio));
colouredimage=image;

parttocolour=false(size(image,1),size(image,2));
edgetocolour=false(size(image,1),size(image,2));

if (iscell(mask))
    for k=1:numel(mask)
        if (~all(all(mask{k}))) %so we exclude the whole frame
            parttocolour=(parttocolour|mask{k});
        end

        edge=xor( mask{k} , (imerode(mask{k}, SE) & frameEdge) );
        edgetocolour= (edgetocolour|edge);
    end
else
    if (~all(all(mask))) %so we exclude the whole frame
        parttocolour=(parttocolour|mask);
    end

    edge=xor( mask , (imerode(mask, SE) & frameEdge) );
    edgetocolour= (edgetocolour|edge);
end

cparttocolour=cat(3,parttocolour,parttocolour,parttocolour);
colourtogive=cat(3,repmat(colourforimage(1),size(parttocolour)),...
    repmat(colourforimage(2),size(parttocolour)),repmat(colourforimage(3),size(parttocolour)));
colouredimage(cparttocolour)=colourtogive(cparttocolour); %subtracting only blue makes the marked regions yellow
colouredimage(cparttocolour)=colouredimage(cparttocolour)+uint8(round(image(cparttocolour)*noncolourratio));
%colouredimage=colouredimage+uint8(round(image*noncolourratio));

cedgetocolour=cat(3,edgetocolour,edgetocolour,edgetocolour);
colourtogive=cat(3,repmat(colourforedges(1),size(parttocolour)),...
    repmat(colourforedges(2),size(parttocolour)),repmat(colourforedges(3),size(parttocolour)));
colouredimage(cedgetocolour)=colourtogive(cedgetocolour); %subtracting only blue makes the marked regions yellow

Init_figure_no(nofigure);
imshow(colouredimage)



