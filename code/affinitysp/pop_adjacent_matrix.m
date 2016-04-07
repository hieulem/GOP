function [ Z ] = pop_adjacent_matrix( img )
%POP_ADJACENT_MATRIX Summary of this function goes here
%   Detailed explanation goes here

labels = unique(img);
nLabels = length(labels);
Z = zeros(nLabels,nLabels);

for iLabel = 1:nLabels
   msk = img == labels(iLabel);
   adjacentPixelMask = imdilate(msk,true(3)) & ~msk;
   Z(iLabel, unique(img(adjacentPixelMask))) =1;
   Z(unique(img(adjacentPixelMask)),iLabel) =1;
end
end

