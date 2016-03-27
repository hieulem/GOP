function [dist ] = geocompute( graph,i )
%GEOCOMPUTE Summary of this function goes here
%   Detailed explanation goes here
EPS = 1e-6;
EPS2 = 1e-20;

[A, path, ~] = graphshortestpath(graph, i );
for j =1:size(path,2)
    dist(j) = size(path{j},2);
end

dist = dist*EPS2 + A* (1+EPS) ;
end

