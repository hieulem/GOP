function [alldistances, mapping]=Computeincreasingdistances(D,Y,dimtouse,manifolddistancemethod)
%Notes: if using original distances in D it must be made sure that the D
%transformation does not truncate the affinities

if ( (~exist('manifolddistancemethod','var')) || (isempty(manifolddistancemethod)) ) %[option for setclustermethod='distances'] 'origd','euclidian'(default),'spectraldiffusion'
    manifolddistancemethod='euclidian'; %default option
end
fprintf('Distance merging, manifolddistancemethod %s\n',manifolddistancemethod);



%Compute backmap, used for address cases of not connected points (zeros)
nopoints=size(D,1);
backmap=zeros(1,nopoints);
for i=1:size(Y.index)
    backmap(Y.index(i))=i;
end

thed=Getchosend(Y,dimtouse);

if ( (strcmp(manifolddistancemethod,'euclidian')) || (strcmp(manifolddistancemethod,'spectraldiffusion')) )
    mappedcoord=Y.coords{thed}(:,:);
    %mappedX = [ dimtouse x no_data_points ]
    if (strcmp(manifolddistancemethod,'spectraldiffusion'))
        if (~isfield(Y,'lambda'))
            %lambda = [ dimtouse+1 x 1 ]
            mappedcoord=mappedcoord./repmat( sqrt(Y.lambda(2:end)) , 1 , size(mappedcoord,2) );
        end
    end
end
        
[r,c,v]=find(D);
alldistances=zeros(1,numel(r));
mapping=zeros(2,numel(r));
count=0;
for i=1:numel(r)
    if (r(i)<=c(i))
        continue;
    end
    
    count=count+1;
    
    %Points here are corrently backmapped, or used with D
    if (strcmp(manifolddistancemethod,'euclidian'))
        rcoord=backmap(r(i));
        ccoord=backmap(c(i));
        if ( (rcoord==0) || (ccoord==0) )
            fprintf('Null coordinate value\n');
            alldistances(count)=Inf;
            continue;
        end
        alldistances(count)=Eucldist(mappedcoord(:,rcoord),mappedcoord(:,ccoord));
        
    elseif (strcmp(manifolddistancemethod,'origd'))
        alldistances(count)=v(count); %Original distances provide better results
        
    elseif (strcmp(manifolddistancemethod,'spectraldiffusion'))
        rcoord=backmap(r(i));
        ccoord=backmap(c(i));
        if ( (rcoord==0) || (ccoord==0) )
            fprintf('Null coordinate value\n');
            alldistances(count)=Inf;
            continue;
        end
        alldistances(count)=sum(mappedcoord(:,rcoord).*mappedcoord(:,ccoord));
        
    else
        error('manifolddistancemethod not recognized');
    end
    
    mapping(:,count)=[r(i);c(i)];
end
alldistances(count+1:end)=[]; %delete superfluous memory
mapping(:,count+1:end)=[]; %delete superfluous memory

[alldistances,idx]=sort(alldistances,'ascend');
mapping(:,:)=mapping(:,idx);

%At distance alldistances(i) the following two points are merged
% point1=mapping(1,i);
% point2=mapping(2,i);



%Normalize according to max neighbour distance
NORMALIZEWITHNEIGHBORHOOD=false;
if (NORMALIZEWITHNEIGHBORHOOD)
    fprintf('Normalization with max neighbor\n');
    newdistances=alldistances;
    allpoints=unique(mapping(:));
    for i=1:numel(allpoints)
        neighs=[ find(mapping(1,:)==i) , find(mapping(2,:)==i) ];
        newdistances(neighs)=max( alldistances(neighs)/max(alldistances(neighs)) , newdistances(neighs) );
    end
    alldistances=newdistances;
end



