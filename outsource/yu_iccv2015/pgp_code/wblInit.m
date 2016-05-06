%wblInit.m
%
%extract edge information from the input image frames, and use the
%superpixels that has an edge between as component 2 guess, otherwise
%component 1 guess.
%
%edgeMaps is a cell array 

function output = wblInit( beginLB, edgeMaps, labelsList, spList, affMatrix, sampleRate , fType)


%randomly sample certain percent of the affMatrix rows, it follows the same
%distrubition anyway.
subInd = sort(randsample(1:size(affMatrix,1), round(sampleRate*size(affMatrix,1))));


edgeSize = 0.3; %percentage of the edge pixels that exist within a boundary
if strcmp(fType, 'motion') == 1
    edgeSize = 0.1;
end

if strcmp(fType, 'orientation') == 1
    edgeSize = 0.5;
end

currF = 1;
tempEdge = edgeMaps{1};

data2 = zeros(10*length(subInd), 1);
count2 = 1;

data1 = data2;
count1 = 1;
%given edge maps,
for i = 1:length(subInd)
    if mod(i, 100) == 0
        [i length(subInd)]
    end
    
%     if subInd(i)-1+beginLB == 11069
%         keyboard
%     end
%     
%     if subInd(i) == 269
%         keyboard
%     end

    tttt = find(affMatrix(subInd(i),:));
    
    fromF = find(subInd(i)-1+beginLB <= labelsList,1); %current working frame number
    
    if currF ~= fromF
        currF = fromF;
        tempEdge = edgeMaps{fromF};
    end
    
    %ttT = tttt(tttt > labelsList(fromF)); %temporal
    %ttS = setdiff(tttt, ttT);   %spacial
    ttS = tttt(tttt <= labelsList(fromF)); %spacial
    
    for j = 1:length(ttS)
        tempImg = zeros(size(tempEdge,1), size(tempEdge,2));
        
        img1 = tempImg;
        img2 = tempImg;
        
        img1(spList{subInd(i)-1+beginLB}) = 1;
        img2(spList{ttS(j)}) = 1;
        
        tempImg = imdilate(img1, strel('disk', 1))& imdilate(img2, strel('disk', 1));
        
        ind = find(tempImg == 1);
        
        %edge percentage
        edgeP = length(find(tempEdge(ind) == 1))/length(ind);
    
        if edgeP > edgeSize
            data2(count2) = affMatrix(subInd(i),ttS(j));
            count2 = count2 + 1;
        else
            data1(count1) = affMatrix(subInd(i),ttS(j));
            count1 = count1 + 1;
        end
        
    end

end

data2(count2:end) = [];
data1(count1:end) = [];

output{1} = data1;
output{2} = data2;
%fit single weibuls to those guys to get the initial guesses




