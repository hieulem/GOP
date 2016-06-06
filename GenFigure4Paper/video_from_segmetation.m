function [ output_args ] = video_from_segmetation( out,sp1,sp2 )
%VIDEO_FROM_SEGMETATION Summary of this function goes here
%   Detailed explanation goes here
v = VideoWriter(out);
v.FrameRate = 15;
open(v);


S = max(max((max(sp1))));
customColors = round(rand(S,3).*255);
doFrames=size(sp1,3);

[rowSize, colSize,~] = size(sp1);
colorFrame = zeros(rowSize, colSize, 3);


for i = 1:doFrames
    
    [i length(doFrames)];
    
    colorFrame = zeros(rowSize, colSize, 3);
    colorIDs = unique(sp1(:,:,i));
    
    for j = 1:length(colorIDs)
        ind = find(sp1(:,:,i) == colorIDs(j));
        colorFrame(ind) = customColors(colorIDs(j),1);
        colorFrame(ind+rowSize*colSize) = customColors(colorIDs(j),2);
        colorFrame(ind+2*rowSize*colSize) = customColors(colorIDs(j),3);
    end
    v1{i} = uint8(colorFrame);
    
    %writeVideo(v,uint8(colorFrame));
    
end


S = max(max((max(sp2))));
customColors = round(rand(S,3).*255);
doFrames=size(sp2,3);

[rowSize, colSize,~] = size(sp2);
colorFrame = zeros(rowSize, colSize, 3);


for i = 1:doFrames
    
    [i length(doFrames)];
    
    colorFrame = zeros(rowSize, colSize, 3);
    colorIDs = unique(sp2(:,:,i));
    
    for j = 1:length(colorIDs)
        ind = find(sp2(:,:,i) == colorIDs(j));
        colorFrame(ind) = customColors(colorIDs(j),1);
        colorFrame(ind+rowSize*colSize) = customColors(colorIDs(j),2);
        colorFrame(ind+2*rowSize*colSize) = customColors(colorIDs(j),3);
    end
    v2{i} = uint8(colorFrame);
    
    %
    
end


for i=1:doFrames
    writeVideo(v,[v1{i},v2{i}]);
end

close(v);

end

