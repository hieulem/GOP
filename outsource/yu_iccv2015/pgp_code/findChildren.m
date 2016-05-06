%findChildren.m
%
%given a sparse matrix of a graph, and a node number, find the list of its
%children.

function output = findChildren( inGraph, nodeID )

if isempty(find(inGraph(nodeID,:), 1)) 
    
    output = nodeID;
    
else
    
    currChildren = find(inGraph(nodeID,:));
    tempOut = [];
    for i = 1:length(currChildren)
       tempOut = [tempOut; currChildren(i); findChildren(inGraph, currChildren(i))];
    end
    output = unique(tempOut);
end
