%find_neighborsT.m
%
%find the temporal neighbors of a region
%
%n is the nxn search window around the motion direction from the current superpixel centroid

function tNeighbors = find_neighborsT( lbCentroids, newLabels, newLabels2, spList, n, uv1, uv2)

rowSize = size(newLabels,1);
colSize = size(newLabels,2);

%find all labels on the next frame within some nxn search window of the
%current region's centroid
searchInd = unique(newLabels);
tNeighbors = cell(length(searchInd),1);

for i = 1:length(searchInd)
    
    r = round(lbCentroids(searchInd(i),1));
    c = round(lbCentroids(searchInd(i),2));
    
    if isempty(uv1)
        
        fromR = max([1, r-round(n/2)]);
        toR = min([r+round(n/2), rowSize]);
        
        fromC = max([1, c-round(n/2)]);
        toC = min([c+round(n/2), colSize]);
        
    else
        avgX = round(mean(uv1(spList{searchInd(i)})));
        avgY = round(mean(uv2(spList{searchInd(i)})));
        
        fromR = max([1, r+avgY-round(n/2)]);
        toR = min([r+avgY+round(n/2), rowSize]);
        
        fromC = max([1, c+avgX-round(n/2)]);
        toC = min([c+avgX+round(n/2), colSize]);
        
    end
    
    %window, as well as the overlapping pixels
    tUnique = unique(newLabels2(fromR:toR, fromC:toC));
    
    tNeighbors{i} = unique([tUnique(:); unique(newLabels2(spList{searchInd(i)}))]);
    
end



