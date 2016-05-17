function Representspanningtree(T,track,dist_track_mask,image,nofigure,colourratio,colourforimage,colourforedges)


%track = [ which frame , x or y , which trajectory ]
% dist_track_mask{which frame,which trajectory}=mask

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


noTracks=size(dist_track_mask,2);

hold on
for k=1:noTracks
    plot(track(1,1,k),track(1,2,k),'+b');
end
hold off

% line(track(:,1,count),track(:,2,count),'Color','y');
[r,c]=find(T);
for i=1:numel(r)
    if (r(i)>=c(i))
        continue;
    else
        hold on
        line([track(1,1,r(i));track(1,1,c(i))],[track(1,2,r(i));track(1,2,c(i))],'Color','c');
        hold off
    end
end




function Representspanningtree_previous(T,track,dist_track_mask,image,nofigure,colourratio,colourforimage,colourforedges)

%track = [ which frame , x or y , which trajectory ]
%dist_track_mask{which frame,which trajectory}=mask

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

%initialisation of necessary parts (strel and frameEdge)
SE=Getstrel();
frameEdge=Getframeedge(size(image,1),size(image,2));

noncolourratio=1-colourratio;
colourforedges=uint8(round(colourforedges*255));
colourforimage=uint8(round(colourforimage*255*colourratio));
colouredimage=image;

parttocolour=false(size(image,1),size(image,2));
edgetocolour=false(size(image,1),size(image,2));

noTracks=size(dist_track_mask,2);
for k=1:noTracks
    mask=dist_track_mask{1,k};
    
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
colouredimage=colouredimage+uint8(round(image*noncolourratio));

cedgetocolour=cat(3,edgetocolour,edgetocolour,edgetocolour);
colourtogive=cat(3,repmat(colourforedges(1),size(parttocolour)),...
    repmat(colourforedges(2),size(parttocolour)),repmat(colourforedges(3),size(parttocolour)));
colouredimage(cedgetocolour)=colourtogive(cedgetocolour); %subtracting only blue makes the marked regions yellow

figure(nofigure), imshow(colouredimage)
set(gcf, 'color', 'white');

hold on
for k=1:noTracks
    plot(track(1,1,k),track(1,2,k),'+b');
end
hold off

% line(track(:,1,count),track(:,2,count),'Color','y');
[r,c]=find(T);
for i=1:numel(r)
    if (r(i)>=c(i))
        continue;
    else
        hold on
        line([track(1,1,r(i));track(1,1,c(i))],[track(1,2,r(i));track(1,2,c(i))],'Color','c');
        hold off
    end
end

