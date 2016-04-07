customColors = round(rand(S,3).*255);

%save the outputs
if ~isempty(writePath1)
    for i = 1:length(doFrames)
        
        [i length(doFrames)];
        
        colorFrame = zeros(rowSize, colSize, 3);
        colorIDs = unique(finalLabels(:,:,i));
        
        for j = 1:length(colorIDs)
            ind = find(finalLabels(:,:,i) == colorIDs(j));
            colorFrame(ind) = customColors(colorIDs(j),1);
            colorFrame(ind+rowSize*colSize) = customColors(colorIDs(j),2);
            colorFrame(ind+2*rowSize*colSize) = customColors(colorIDs(j),3);
        end
        
        numZ = '0000';
        
        if doFrames(i) < 10
            writeNum = [numZ, num2str(doFrames(i))];
        elseif doFrames(i) < 100
            writeNum = ['000', num2str(doFrames(i))];
        elseif doFrames(i) < 1000
            writeNum = ['00', num2str(doFrames(i))];
        elseif doFrames(i) < 10000
            writeNum = ['0', num2str(doFrames(i))];
        else
            writeNum = num2str(doFrames(i));
        end
        
        imwrite(uint8(colorFrame), [writePath1, 'colorImg_', writeNum, '.png'], 'BitDepth', 8);
    end
end
disp(sprintf('done, %.2f sec\n', toc(tE)));