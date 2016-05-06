%trackRegions.m
%
%given a set of labels, draw their combined boundary as successive frames
%

function [outSegImg, outSegMask, outBoxImg, outBoxMask] = trackRegions( trackLabels, labels, images )

rowSize = size(labels,1);
colSize = size(labels,2);
numFrames = size(labels,3);

outSegImg = cell(numFrames,1);
outSegMask = zeros(rowSize, colSize, numFrames);
outBoxImg = outSegImg;
outBoxMask = outSegMask;

%find the perimeter and the bounding boxes on each frame
for i = 1:numFrames
    [i numFrames]
    
    tempInd = [];
    for j = 1:length(trackLabels)
        tempInd = unique([tempInd; find(labels(:,:,i) == trackLabels(j))]);
    end
    
    tempMat = zeros(rowSize, colSize);
    tempMat(tempInd) = 1;
    
    perimInd = find(bwmorph(tempMat, 'remove') == 1);
    
    %prepare the outputs
    tempImg = images{i};
    
    tempImg(perimInd) = 255;
    tempImg(perimInd+rowSize*colSize) = 0;
    tempImg(perimInd+2*rowSize*colSize) = 0;
    
    outSegImg{i} = tempImg;
    outSegMask(:,:,i) = tempMat;
    
    %for bounding boxes
    tempImg = images{i};
    [rT, cT] = ind2sub([rowSize, colSize], perimInd);
    
    startCol = min(cT);
    startRow = min(rT);
    toCol = max(cT);
    toRow = max(rT);
    
    %draw the box
    %left line
    tempImg(startRow:toRow,startCol,1) = 255;
    tempImg(startRow:toRow,startCol,2) = 0;
    tempImg(startRow:toRow,startCol,3) = 0;
    
    tempImg(startRow,startCol:toCol,1) = 255; %top line
    tempImg(startRow,startCol:toCol,2) = 0;
    tempImg(startRow,startCol:toCol,3) = 0;
    
    tempImg(startRow:toRow,toCol,1) = 255;  %right line
    tempImg(startRow:toRow,toCol,2) = 0;
    tempImg(startRow:toRow,toCol,3) = 0;
    
    tempImg(toRow,startCol:toCol,1) = 255; %bottom line
    tempImg(toRow,startCol:toCol,2) = 0;
    tempImg(toRow,startCol:toCol,3) = 0;
    
    outBoxImg{i} = tempImg;
    
    tempMat = zeros(rowSize, colSize);
    
    tempMat(startRow:toRow,startCol:toCol) = 1;
    outBoxMask(:,:,i) = tempMat;
    
end





