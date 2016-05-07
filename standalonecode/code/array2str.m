function [ str ] = array2str( a )
%ARRAY2STR Summary of this function goes here
%   Detailed explanation goes here
str='';
for i=1:length(a)
    str=[str,'_',num2str(a(i))];
end
str=[str,'_'];
end

