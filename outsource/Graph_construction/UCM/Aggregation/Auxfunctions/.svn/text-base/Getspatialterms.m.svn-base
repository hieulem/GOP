function newsimilarities=Getspatialterms(similarities,framebelong)
%The function adds spatial similarities based on temporal similarities
%This implementation does not take into account the frames

%to make sure that similarities matrix is simmetric
similarities=max(similarities,similarities');

newsimilarities=similarities;

noterms=size(similarities,1);

if ( (~exist('framebelong','var')) || (isempty(framebelong)) )
    framebelong=ones(1,noterms);
end

for i=1:noterms
    
    neighbours=find(similarities(i,:));
    
    noneighbours=numel(neighbours);
    for j=1:noneighbours
        
        neighboursofneighbour=find(similarities(neighbours(j),:));
        
        newneighboursneighbour=neighboursofneighbour(framebelong(neighboursofneighbour)==framebelong(i));
        
%         newsimilarities(i,newneighboursneighbour)=max( newsimilarities(i,newneighboursneighbour) , similarities(i,neighbours(j))*similarities(neighbours(j),newneighboursneighbour) );
            %results with st
            %this behavior is already included in the manifold construction
            
        newsimilarities(i,newneighboursneighbour)=max( newsimilarities(i,newneighboursneighbour) , min(similarities(i,neighbours(j)),similarities(neighbours(j),newneighboursneighbour)) );

        %This version deletes elements from the array
        % neighboursofneighbour(framebelong(neighboursofneighbour)~=framebelong(i))=[];
        % newsimilarities(i,neighboursofneighbour)=max( newsimilarities(i,neighboursofneighbour) , similarities(i,neighbours(j))*similarities(neighbours(j),neighboursofneighbour) );
        
    end
    
end

newsimilarities=max(newsimilarities,newsimilarities');


%TODO: consider why all connections mean no connections
%TODO: see effect of nodims