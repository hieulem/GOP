%findNeighbors3d.m
%
%given a set of pixel region, find what are the neighbors of this pixel.

function output = findNeighbors3d( inputImg, inputImg2, inputPixels )

%tempInd = find(inputImg == inputImg(inputPixels(1)));
tempImg = inputImg == inputImg(inputPixels(1));

se1 = strel('square', 3);
tempImg2 = imdilate(tempImg, se1, 'same');
%tempImg2 = bwmorph(tempImg, 'dilate');
tempImg3 = tempImg2 - tempImg;

tempInd2 = tempImg3 == 1;

%the neighboring labels are returned
output = unique(inputImg(tempInd2));

%for the temporal domain neighbors, has to be overlapping
%or, maybe try touching as well?
if ~isempty(inputImg2)
    output = [output; unique(inputImg2(inputPixels))];
end

if output(1) == 0
    output(1) = [];
end

