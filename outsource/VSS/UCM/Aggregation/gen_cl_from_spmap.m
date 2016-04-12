function [ colorFrame ] = gen_cl_from_spmap( sp,video_name )

 S = max(max((max(sp))));
customColors = round(rand(S,3).*255);
doFrames=size(sp,3);

[rowSize, colSize,~] = size(sp);
colorFrame = zeros(rowSize, colSize, 3);
  if ~isempty(video_name)
writePath1 = [video_name];
mkdir(writePath1);
k= pwd;
cd(writePath1);
  end;

for i = 1:doFrames
    
    [i length(doFrames)];
    
    colorFrame = zeros(rowSize, colSize, 3);
    colorIDs = unique(sp(:,:,i));
    
    for j = 1:length(colorIDs)
        ind = find(sp(:,:,i) == colorIDs(j));
        colorFrame(ind) = customColors(colorIDs(j),1);
        colorFrame(ind+rowSize*colSize) = customColors(colorIDs(j),2);
        colorFrame(ind+2*rowSize*colSize) = customColors(colorIDs(j),3);
    end
    
    numZ = '0000';
    
    writeNum = num2str(i);

    if ~isempty(video_name)
        imwrite(uint8(colorFrame), [ 'colorImg_', writeNum, '.png'], 'BitDepth', 8);
    end;
end
  if ~isempty(video_name)
cd(k);
  end
end

