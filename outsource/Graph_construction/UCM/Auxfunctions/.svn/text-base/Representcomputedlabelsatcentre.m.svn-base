function Representcomputedlabelsatcentre(imagefc,track,labels)


fc=round( (size(track,1)-1)/2 ) + 1;

% dimIi=size(imagefc,1);
dimIj=size(imagefc,2);

nofigure=13;

%track = [ which frame , x or y , which trajectory ]
%group{which group}=[tracks/dist_track_mask belonging to it]

noTracks=size(track,3);

alllabels=unique(labels);

figure(nofigure), imshow(imagefc)
set(gcf, 'color', 'white');
hold on
for k=1:noTracks
    line(track(:,1,k),track(:,2,k),'Color','y'); 
    plot(track(:,1,k),track(:,2,k),'+g');
end
for jj=1:numel(alllabels)
    col=GiveDifferentColours(alllabels(jj));
    for m=find(labels==alllabels(jj))
        plot(track(fc,1,m),track(fc,2,m),'o','Color',col,'LineWidth',3);
    end
    plot(dimIj-2,jj*10,'o','Color',col,'LineWidth',3);
end
hold off

