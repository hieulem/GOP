function allGis=Computeallgiswithmean(Gif)

noGis=numel(Gif.Gis);
noLevels=numel(Gif.Gis{1}.T);

mapTracToTrajectories=[];
for g=1:noGis
    for l=1:noLevels
        mapTracToTrajectories=[mapTracToTrajectories,Gif.Gis{g}.mapTracToTrajectories{l}];
    end
end

mapTracToTrajectories=unique(mapTracToTrajectories);

noTracks=numel(mapTracToTrajectories);
allGis.mapTracToTrajectories=mapTracToTrajectories;
allGis.T=false(noTracks);
allGis.P=zeros(noTracks);
Pcounts=zeros(noTracks);

for g=1:noGis
    for l=1:noLevels
        
        %find all correspondences
        mapTracToTrajectories=Gif.Gis{g}.mapTracToTrajectories{l};
        correspondences=zeros(1,numel(mapTracToTrajectories));
        for k=1:numel(correspondences)
            correspondences(k)=Translatefromfirsttosecond(mapTracToTrajectories,k,allGis.mapTracToTrajectories);
        end
        
        %find all true elements in Gif.Gis{g}.T{l}
        [r,c]=find(Gif.Gis{g}.T{l});
        
        %for all those with c>=r *
        for k=1:numel(r)
            if (r(k)>c(k))
                continue;
            end
            
            %update T
            allGis.T(correspondences(r(k)),correspondences(c(k)))=true;
            Pcounts(correspondences(r(k)),correspondences(c(k)))=Pcounts(correspondences(r(k)),correspondences(c(k)))+1;
            
            %update P
            allGis.P(correspondences(r(k)),correspondences(c(k)))=allGis.P(correspondences(r(k)),correspondences(c(k)))+...
                Gif.Gis{g}.P{l}(r(k),c(k));
        
            %* do the same for the symmetric value
            if r(k)~=c(k)
                allGis.T(correspondences(c(k)),correspondences(r(k)))=allGis.T(correspondences(r(k)),correspondences(c(k)));
                allGis.P(correspondences(c(k)),correspondences(r(k)))=allGis.P(correspondences(r(k)),correspondences(c(k)));
                Pcounts(correspondences(c(k)),correspondences(r(k)))=Pcounts(correspondences(r(k)),correspondences(c(k)));
            end
        end
    end
end

allGis.P(allGis.T)=allGis.P(allGis.T)./Pcounts(allGis.T);
