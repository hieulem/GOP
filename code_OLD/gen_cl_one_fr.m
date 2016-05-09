function [ colorFrame ] = gen_cl_one_fr( sp )

 S = max((max(sp)));
 customColors = round(rand(S,3).*255);


[rowSize, colSize] = size(sp);
colorFrame = zeros(rowSize, colSize, 3);


    colorIDs = unique(sp(:,:));
    
    for j = 1:length(colorIDs)
        ind = find(sp == colorIDs(j));
        colorFrame(ind) = customColors(colorIDs(j),1);
        colorFrame(ind+rowSize*colSize) = customColors(colorIDs(j),2);
        colorFrame(ind+2*rowSize*colSize) = customColors(colorIDs(j),3);
    end
    
 
end

