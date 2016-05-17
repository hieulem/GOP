function Representtwotrees(Tm,Tp,track,dist_track_mask,image)

%track = [ which frame , x or y , which trajectory ]
% dist_track_mask{which frame,which trajectory}=mask

%initialisation of necessary parts (strel and frameEdge)
SE=Getstrel();
frameEdge=Getframeedge(size(image,1),size(image,2));

blank_mask=false(size(image,1),size(image,2));

noTracks=size(dist_track_mask,2);

for k=1:noTracks
    if (~all(all(dist_track_mask{1,k}))) %so we exclude the whole frame
        mask=dist_track_mask{1,k};
        
        blue_part_mask=cat(3,blank_mask,blank_mask,mask);
        image(blue_part_mask)=0; %subtracting only blue makes the marked regions yellow
    end

    edge=xor( dist_track_mask{1,k} , (imerode(dist_track_mask{1,k}, SE) & frameEdge) );

    %this makes the contours of regions red
    red_part_edge=cat(3,edge,blank_mask,blank_mask);
    green_part_edge=cat(3,blank_mask,edge,blank_mask);
    blue_part_edge=cat(3,blank_mask,blank_mask,edge);
    image(red_part_edge)=255;
    image(green_part_edge)=0;
    image(blue_part_edge)=0;
end

figure(16)
imshow(image)
set(gcf, 'color', 'white');
title('First frame with regions and region edges marked, whole frame excluded from the picture, if any');

hold on
for k=1:noTracks
    plot(track(1,1,k),track(1,2,k),'+r');
end
hold off

if (~isempty(Tm))
    Showt(Tm,track,'b');
end
if (~isempty(Tp))
    Showt(Tp,track,'k');
end


function Showt(T,track,colour)

if ( (~exist('colour','var')) || (isempty(colour)) )
    colour='b';
end

% line(track(:,1,count),track(:,2,count),'Color','y');
for i=1:size(T,1)
    r=find(T(i,:)==1);
    for k=r
        if (k==i) %so as not to draw a line between a point and himself
            continue;
        end
        hold on
        line([track(1,1,i);track(1,1,k)],[track(1,2,i);track(1,2,k)],'Color',colour);
        hold off
    end
end

