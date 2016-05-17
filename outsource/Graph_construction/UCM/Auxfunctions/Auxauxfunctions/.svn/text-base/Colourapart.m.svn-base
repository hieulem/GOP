function image=Colourapart(parttocolour,image,colourformask,colourratio)
%colourformask may be a uint8 3D-array specifying colour, or a 3D-array
%with values in [0,1]
%colourratio is a double in [0,1]

if (~isa(colourformask,'uint8'))
    colourformask=uint8(round(colourformask*255*colourratio));
end
noncolourratio=(1-colourratio);

cparttocolour=cat(3,parttocolour,parttocolour,parttocolour);
colourtogive=cat(3,repmat(colourformask(1),size(parttocolour)),...
    repmat(colourformask(2),size(parttocolour)),repmat(colourformask(3),size(parttocolour)));
dissimage=uint8(cat(3,double(image(:,:,1))*noncolourratio,double(image(:,:,2))*noncolourratio,double(image(:,:,3))*noncolourratio));
image(cparttocolour)=colourtogive(cparttocolour)+dissimage(cparttocolour);

