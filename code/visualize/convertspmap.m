function [ B ] = convertspmap( A, map)
%CONVERTSPMAP Summary of this function goes here
%   Detailed explanation goes here
%   s1 = mx2
B= A;
for i=1:size(map,1)
    B(A==map(i,1)) = map(i,2);
end
end

