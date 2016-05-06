%findParents.m
%
%given a sparse matrix of a graph, and a node number, find the list of its
%parents.

function output = findParents( inGraph, nodeID )

if isempty(find(inGraph(:,nodeID), 1)) 
    
    output = nodeID;
    
else
    
    currParents = find(inGraph(:,nodeID));
    tempOut = [];
    for i = 1:length(currParents)
       tempOut = [tempOut; currParents(i); findParents(inGraph, currParents(i))];
    end
    output = unique(tempOut);
end
