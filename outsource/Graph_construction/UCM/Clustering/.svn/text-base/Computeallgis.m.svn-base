function [allGis,tlevelone]=Computeallgis(Gif,howmanyframes,upwhichlevel,keepminprob)

% allGis.mapTracToTrajectories
% allGis.P
% allGis.T
%tlevelone is the T matrix at the first level, which may be used to impose
%that no connections are created by higher level links

%Use:
% allGis=Computeallgis(Gif,howmanyframes);
    %howmanyframes=1:endf; _[]
% [allGis,tlevelone]=Computeallgis(Gif);
% allGis=Computeallgis(Gif,39:82);
%if howmanyframes is not specified or empty all those in Gif are
%considered
% upwhichlevel=1;
% allGis=Computeallgis(Gif,[],upwhichlevel);
    %only up to level probabilities are considered

% allGis=Computeallgiswithmean(Gif); %uses the mean instead

%alternative ways which have been tried
% -keeping minimum probabilities only across levels or for bigger length
%- keeping more certain probabilities (closer to 0 or 1) across levels


noGis=numel(Gif.Gis);
noLevels=numel(Gif.Gis{1}.T);

%upwhichlevel only considers merging probabilities up to the specified
%value
if ( (exist('upwhichlevel','var')) && (~isempty(upwhichlevel)) )
    noLevels=min(noLevels,upwhichlevel);
end

%keepminprob is used to keep the minimum value of the probability that two
%trajectories are clustered together
if ( (~exist('keepminprob','var')) || (isempty(keepminprob)) )
    keepminprob=false;
end

if ( (~exist('howmanyframes','var')) || (isempty(howmanyframes)) )
    whichGis=1:noGis;
else
    whichGis=zeros(1,numel(howmanyframes));
    for i=1:numel(howmanyframes)
        whichGis(i)=find(Gif.frame==howmanyframes(i),1);
    end
end

mapTracToTrajectories=[];
for g=whichGis
    for l=1:noLevels
        mapTracToTrajectories=[mapTracToTrajectories,Gif.Gis{g}.mapTracToTrajectories{l}];
    end
end

mapTracToTrajectories=unique(mapTracToTrajectories);

noTracks=numel(mapTracToTrajectories);
allGis.mapTracToTrajectories=mapTracToTrajectories;
allGis.T=false(noTracks);
allGis.P=ones(noTracks).*0.5;

tlevelone=false(noTracks); %added for the level one T

for g=whichGis
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
            
            if (l==1) %added for the level one T
                tlevelone(correspondences(r(k)),correspondences(c(k)))=true;
            end
            
            %update P
            Pone=allGis.P(correspondences(r(k)),correspondences(c(k)));
            Ptwo=Gif.Gis{g}.P{l}(r(k),c(k));
            if (keepminprob)
                Pp=min(Pone,Ptwo);
            else
%                 Pp=1./(  1 +  ( (1-Pone).*((1-Ptwo)^l)./ (Pone .* (Ptwo^l)) )  ); _P reweighted
                Pp=1./(  1 +  ( (1-Pone).*(1-Ptwo)./ (Pone .* Ptwo) )  ); 
            end
            if (isnan(Pp))
                %TODO: check that this case should occur no more
                fprintf('\nEncountered a nan in forming allGis, Gis %d, level %d, position (%d,%d),Pone %g, Ptwo %g\n',g,l,r(k),c(k),Pone,Ptwo);
                Pp=0; %or Pp=Pone, which supposes that the accumulated values is the result of already many P
                fprintf('Substituted %g instead\n\n',Pp);
            end
            
            allGis.P(correspondences(r(k)),correspondences(c(k)))=Pp;
        
            %* do the same for the symmetric value
            if r(k)~=c(k)
                allGis.T(correspondences(c(k)),correspondences(r(k)))=allGis.T(correspondences(r(k)),correspondences(c(k)));
                allGis.P(correspondences(c(k)),correspondences(r(k)))=allGis.P(correspondences(r(k)),correspondences(c(k)));
                
                if (l==1) %added for the level one T
                    tlevelone(correspondences(c(k)),correspondences(r(k)))=tlevelone(correspondences(r(k)),correspondences(c(k)));
                end
            end
        end
    end
end

tlevelone(logical(eye(noTracks)))=true; %added for the level one T, actually unnecessary
