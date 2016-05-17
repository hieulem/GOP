function Tmi=Gettatframei(allGis,Tm,Gif,frame)

g=find(Gif.frame==frame);
l=1;

%find all correspondences
mapTracToTrajectories=allGis.mapTracToTrajectories;
correspondences=zeros(1,numel(mapTracToTrajectories));
for k=1:numel(correspondences)
    correspondences(k)=Translatefromfirsttosecond(mapTracToTrajectories,k,Gif.Gis{g}.mapTracToTrajectories{l});
end


%find all true elements in Tm
[r,c]=find(Tm);

Tmi=false(numel(Gif.Gis{g}.mapTracToTrajectories{l}));
for k=1:numel(r)

    if ( correspondences(r(k)) && correspondences(c(k)) )
        Tmi(correspondences(r(k)),correspondences(c(k)))=true;
    end

end
