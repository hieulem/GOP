function Representlabeledregions(image,track,dist_track_mask,labels,th,labelsfc)

if ( (~exist('th','var')) || (isempty(th)) || (~exist('labelsfc','var')) || (isempty(labelsfc)) || (th<=1) )
    useth=false;
else
    useth=true;
end

%initialisation of necessary parts (strel and frameEdge)
% SE=Getstrel();
dimIi=size(image,1);
dimIj=size(image,2);
% frameEdge=Getframeedge(dimIi,dimIj);

% blank_mask=false(dimIi,dimIj);

partnotdone=true(dimIi,dimIj);

%image=cim{nframe};
colouredimage=image;

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
        if (~all(all(dist_track_mask{1,m}))) %so we exclude the whole frame
            mask=(dist_track_mask{1,m}&partnotdone);

            parttocolour=cat(3,mask,mask,mask);
            colourtogive=cat(3,repmat(col(1),size(mask)),repmat(col(2),size(mask)),repmat(col(3),size(mask)));
%             colouredimage(parttocolour)=colouredimage(parttocolour)-colourtogive(parttocolour); %subtracting only blue makes the marked regions yellow
            colouredimage(parttocolour)=colourtogive(parttocolour); %subtracting only blue makes the marked regions yellow
        end
    end
end
figure(nofigure), imshow(colouredimage+uint8(round(image/3)))
set(gcf, 'color', 'white');


