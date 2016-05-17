function Representlabeledregionsatcentre(imagefc,dist_track_mask,labels,th,labelsfc)

if ( (~exist('th','var')) || (isempty(th)) || (~exist('labelsfc','var')) || (isempty(labelsfc)) || (th<=1) )
    useth=false;
else
    useth=true;
end

fc=round( (size(dist_track_mask,1)-1)/2 ) + 1; %central frame

%initialisation of necessary parts (strel and frameEdge)
% SE=Getstrel();
dimIi=size(imagefc,1);
dimIj=size(imagefc,2);
% frameEdge=Getframeedge(dimIi,dimIj);

% blank_mask=false(dimIi,dimIj);

partnotdone=true(dimIi,dimIj);

%imagefc=cim{fc};
colouredimage=imagefc;

nofigure=17;

%track = [ which frame , x or y , which trajectory ]
% dist_track_mask{which frame,which trajectory}=mask
%group{which group}=[tracks/dist_track_mask belonging to it]

% noTracks=size(track,3);
% noTracks=size(dist_track_mask,2);

alllabels=unique(labels);

for jj=1:numel(alllabels)
    col=uint8(round(GiveDifferentColours(alllabels(jj))*255*2/3));
    
    if ( (useth) && (numel(find(labelsfc==alllabels(jj)))<th) )
        continue;
    end
    for m=find(labels==alllabels(jj))
        if (~all(all(dist_track_mask{fc,m}))) %so we exclude the whole frame
            mask=(dist_track_mask{fc,m}&partnotdone);

            parttocolour=cat(3,mask,mask,mask);
            colourtogive=cat(3,repmat(col(1),size(mask)),repmat(col(2),size(mask)),repmat(col(3),size(mask)));
%             colouredimage(parttocolour)=colouredimage(parttocolour)-colourtogive(parttocolour); %subtracting only blue makes the marked regions yellow
            colouredimage(parttocolour)=colourtogive(parttocolour); %subtracting only blue makes the marked regions yellow
        end
    end
end
figure(nofigure), imshow(colouredimage+uint8(round(imagefc/3)))
set(gcf, 'color', 'white');


