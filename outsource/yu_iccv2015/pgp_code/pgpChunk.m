%pgpChunk.m
%
%streaming version of the parametric graph partitioning for video
%segmentation


function output = pgpChunk( inputDIR, motionDIR, doFrames, spType, numSP, fitMethod, toShow, maxInt, maxHue, maxLab, maxM, maxO) 


% addpath('.\ers_matlab_wrapper_v0.2.1');
% addpath('.\SLIC');
% addpath('.\rubner_EMD\');
% addpath('.\utilities\');
% addpath(genpath('E:\matlab2011b\work\video_segmentation\optic_flow\'));
% addpath('E:\matlab2011b\work\video_segmentation\Bilateral Filtering\');

%input frames' directory
% clear all;
% close all;

%segtrak2
% inputDIR = 'E:\matlab2011b\work\video_segmentation\data\SegTrackv2\JPEGImages\drift\';
% motionDIR = 'E:\matlab2011b\work\video_segmentation\data\SegTrackv2\motions\';
% load([motionDIR, 'drift.mat']);

%segtrak
% inputDIR = 'E:\matlab2011b\work\video_segmentation\data\SegTrackv2\JPEGImages\girl\';
% motionDIR = 'E:\matlab2011b\work\video_segmentation\data\SegTrackv2\motions\';
% load([motionDIR, 'girl.mat']);

%gTech
% inputDIR = 'E:\matlab2011b\work\video_segmentation\data\GaTech\originals\waterski_jpg\';
% motionDIR = 'E:\matlab2011b\work\video_segmentation\data\GaTech\motions\';
% load([motionDIR, 'waterski_jpg.mat']);

%chen
% inputDIR = 'E:\matlab2011b\work\video_segmentation\data\Chen_Xiph.org\paris_fa\frames\';
% motionDIR = 'E:\matlab2011b\work\video_segmentation\data\Chen_Xiph.org\motions\';
% load([motionDIR, '\paris_fa.mat']);

%youtube object
% inputDIR = 'E:\matlab2011b\work\video_segmentation\data\youtube_objects\categories\aeroplane\data\0001\shots\001\';
% motionDIR = 'E:\matlab2011b\work\video_segmentation\data\youtube_objects\motion\aeroplane\0001\001\';
% load([motionDIR, 'ofMotion.mat']);

t0 = tic;

%spType = 'ers';
%fitMethod = 2; %1 is mle, 2 is nls
%numSP = 300;
useLog = 1;
toResize = 0;
%toShow = 0;

% maxInt = 1;
% maxHue = 0.5;
% maxLab = 0.5;
% maxO = 1;
% maxM = 1;

inFrames = dir(inputDIR);
inFrames(1) = [];  %.
inFrames(1) = [];  %..
%doFrames = 1:length(inFrames);
% doFrames = 1:150;
numFrames = length(doFrames);
% numFrames = 150;

isGray = 0;
if size(imread([inputDIR, inFrames(1).name]), 3) == 1
    isGray = 1;
end

tE = tic;
disp('Obtaining superpixels for each frame...');

%perform superpixel segmentation on all frames
labelsList = zeros(numFrames,1);
origImg = imread([inputDIR, inFrames(1).name]);
dImg = origImg;    
if size(dImg,1) > size(dImg,2) & size(dImg,1) > 400 & toResize == 1
    dImg = imresize(dImg, [ 400 NaN]);
elseif size(dImg,2) > size(dImg,1) & size(dImg,2) > 400 & toResize == 1
    dImg = imresize(dImg, [ NaN 400]);
end
rowSize = size(dImg, 1);
colSize = size(dImg, 2);
% 
% rowSize = 160;
% colSize = 125;

imgTotal = rowSize*colSize;
labels = zeros(rowSize, colSize, numFrames); 
% mag = labels;
% angles = mag;
inputImg = cell(numFrames,1);
inputImgG = cell(numFrames,1); %gray scale
mag = inputImg;
angles = inputImg;


lImg = cell(numFrames,1);
aImg = cell(numFrames,1);
bImg = cell(numFrames,1);

hueImg = cell(numFrames,1);
satImg = cell(numFrames,1);


currCount = 0;
count = 1;
tic

%pre-processing step
for i = 1:numFrames
    [i, numFrames];
    
%     system(['RollingGuidanceFilter -i ', inputDIR, inFrames(doFrames(i)).name, ' -o out.png -iter 7']);
    
    inputImg{i,1} = imread([inputDIR, inFrames(doFrames(i)).name]);
%     inputImg{i,1} = imread('out.png');
    %figure, imshow(inputImg{i,1});
    
    if size(inputImg{i,1},1) > size(inputImg{i,1},2) & size(inputImg{i,1},1) > 400 & toResize == 1
        inputImg{i,1} = imresize(inputImg{i,1}, [ 400 NaN]);
    elseif size(inputImg{i,1},2) > size(inputImg{i,1},1) & size(inputImg{i,1},2) > 400 & toResize == 1
        inputImg{i,1} = imresize(inputImg{i,1}, [ NaN 400]);
    end
    
%     inputImg{i,1} = t(1:rowSize, 1:colSize,:); 
    
    inputImgG{i} = double(rgb2gray(inputImg{i,1}))./255;
    
    %% get the hue image
    labImg = RGB2Lab(inputImg{i,1});
    lImg{i} = labImg(:,:,1);
    aImg{i} = labImg(:,:,2);
    bImg{i} = labImg(:,:,3);
    
    hueImg{i} = rgb2hue(inputImg{i,1});  %hue
    hsvImg = rgb2hsv(inputImg{i,1});
    satImg{i} = hsvImg(:,:,2);  %saturation
    
    %turn into bicone
    satImg{i} = biconeSat(satImg{i}, lImg{i}); %try using L from lab for lightness measure
    
    labels(:,:,i) = currCount;
    
    %if it is a greyscale image
    if (size(inputImg{i,1},3) == 1)
        inputImg{i,1}(:,:,2) = inputImg{i,1}(:,:,1);
        inputImg{i,1}(:,:,3) = inputImg{i,1}(:,:,1);
    end
    
    if strcmp(spType, 'ers') == 1
        
        %get the superpixels using Entropy Rate Superpixel
        tempL = mex_ers(double(inputImg{i,1}),numSP);
        
        if min(min(tempL)) == 0
            tempL = tempL + 1;
        end

    else
        %slic
        tempL = slicWrapper( inputImg{i,1}, 2, numSP );
        
        if min(min(tempL)) == 0
            tempL = tempL + 1;
        end
    end
    
    labels(:,:,i) = labels(:,:,i) + tempL;
    %inputImg{i,1} = double(inputImg{i,1});
    
    %compute gradient orientations
    [grad_xr, grad_yu] = gradient(double(rgb2gray(inputImg{i,1})));
    mag{i}= sqrt(grad_xr.^2 + grad_yu.^2);
    angles{i} = atan2(grad_xr, grad_yu);

    labelsList(i) = max(max(labels(:,:,i)));
    inputImg{i,1} = double(inputImg{i,1});
    currCount = max(max(labels(:,:,i)));
    count = count + 1;
end
disp(sprintf('done, %.2f sec\n', toc(tE)));

%uv = estimate_flow_interface(inputImg{1}, inputImg{2}, 'classic+nl-fast');

tE = tic;
disp('Preprocessing...');
spList = cell(1,max(max(labels(:,:,end))));
labelCentroids1 = zeros(max(max(labels(:,:,end))),2);

%generate the superpixel's pixel list
currID = 1;
fromSP = 1;
toSP = 1;
count = 1;
searchRatio = 0.01;

if maxM == 0
    searchRatio = 0.02;
end

moveLength = round(searchRatio * (rowSize+colSize)/2); %percentage of the average video width

for i = 1:numFrames
    [i numFrames];
    
    if i > 1
        fromSP = labelsList(i-1)+1;
    end
    
    toSP = labelsList(i);
    
    %save the pixel list for every superpixel
    [B1,I1,J1] = unique(labels(:,:,i));
    J1(:,2) = 1:rowSize*colSize;
    J1 = sortrows(J1,1);
    [B2,I2,J2] = unique(J1(:,1));
    t = 0;
    t(2:length(I2),1) = I2(1:end-1);
    I3 = I2-t;
    spList(fromSP:toSP) = mat2cell(J1(:,2), I3');

    %find the temporal-neighborhood pixels
    for j = fromSP:toSP
        [ri, ci] = ind2sub([rowSize, colSize], spList{count});
        labelCentroids1(count,:) = [(min(ri)+max(ri))/2, (min(ci)+max(ci))/2];
        count = count + 1;
    end
end
disp(sprintf('done, %.2f sec\n', toc(tE)));

%figure, imshow(drawBoundary(labels(:,:,10), inputImg{10}));


%% find the neighbors of each superpixel (spatial and temporal) 
tE = tic;
disp('Finding temporal neighbors maps...');

%spatial neighbors
spNeighbor = find_neighbors3d(labels, max(max(labels(:,:,end))), 0); 


%temporal neighbors
count = 1;
currPos = 1;
tConnections = zeros(searchRatio*numSP*numFrames*numSP,2);

if maxM > 0
    
    load(motionDIR);
    
    %search around the motion direction
    uv1 = cell(numFrames,1);
    uv2 = cell(numFrames,1);
    for i = 1:numFrames-1
        if toResize == 1 & size(uv{doFrames(i)}(:,:,1), 1) > size(uv{doFrames(i)}(:,:,1), 2) & size(uv{doFrames(i)}(:,:,1), 1) > 400
            uv1{i} = imresize(uv{doFrames(i)}(:,:,1), [400 NaN]);
            uv2{i} = imresize(uv{doFrames(i)}(:,:,2), [400 NaN]);
        elseif toResize == 1 & size(uv{doFrames(i)}(:,:,1), 2) > size(uv{doFrames(i)}(:,:,1), 1) & size(uv{doFrames(i)}(:,:,1), 2) > 400 
            uv1{i} = imresize(uv{doFrames(i)}(:,:,1), [NaN 400]);
            uv2{i} = imresize(uv{doFrames(i)}(:,:,2), [NaN 400]);
        else
            uv1{i} = uv{doFrames(i)}(:,:,1);
            uv2{i} = uv{doFrames(i)}(:,:,2);
        end
    end
    uv1{numFrames} = ones(rowSize, colSize); %dummy frame
    uv2{numFrames} = ones(rowSize, colSize);
    
end

for i = 1:numFrames-1
    [i numFrames-1];
    
    if maxM > 0
        tNeighbors = find_neighborsT( labelCentroids1, labels(:,:,i), labels(:,:,i+1), spList, moveLength*2, uv1{i}, uv2{i});
    else
        tNeighbors = find_neighborsT( labelCentroids1, labels(:,:,i), labels(:,:,i+1), spList, moveLength*2,[],[]);
    end
    
    for j = 1:length(tNeighbors)
        tConnections(currPos:currPos+length(tNeighbors{j})-1,:) = [repmat(count, [length(tNeighbors{j}),1]), tNeighbors{j}];
        spNeighbor{count} = [spNeighbor{count}; tNeighbors{j}];
        count = count + 1;
        currPos = currPos + length(tNeighbors{j});
    end

end
tConnections(currPos:end,:) = [];
temporalInd = sub2ind([labelsList(end), labelsList(end)], tConnections(:,1), tConnections(:,2));
disp(sprintf('done, %.2f sec\n', toc(tE)));


%% obtain edge maps
% tE = tic;
% disp('Computing edge maps...');
% edgeI = genEdgeMaps(inputImgG, [], 'intensity');
% edgeHue = genEdgeMaps(hueImg, [], 'hue');
% edgeLAB = genEdgeMaps(aImg, bImg, 'lab');
% edgeM = genEdgeMaps(uv1, uv2, 'motion');
% edgeO = genEdgeMaps(mag, [], 'orientation');
% disp(sprintf('done, %.2f sec\n', toc(tE)));

% tic
% myData = wblInit( edgeI, labelsList, spList, sparseI2, 0.1);
% toc

%% populate the affinities

tE = tic;

for i = 1:length(inputImgG);
    inputImgG{i} = round(inputImgG{i}.*255);
end

disp('Computing affinity matrices...');
maxLabels = max(max(labels(:,:,end)));
if maxM > 0
    [from, to, wi, wc, wo, wl] = populateAffin_old(labelsList, maxLabels, spNeighbor, spList, inputImgG, hueImg, satImg, mag, angles, labelCentroids1, uv1, uv2);
else
    [from, to, wi, wc, wo, wl] = populateAffin_noMotion(labelsList, maxLabels, spNeighbor, spList, inputImgG, hueImg, satImg, mag, angles, labelCentroids1);
end
%[~, ~, wcHue] = populateAffin_hue(labelsList, maxLabels, spNeighbor, spList, hueImg);

if maxLab > 0
    minA = min(min(min(cell2mat(aImg))));
    minB = min(min(min(cell2mat(bImg))));
    maxA = max(max(max(cell2mat(aImg))));
    maxB = max(max(max(cell2mat(bImg))));
    aImg2 = aImg;
    bImg2 = bImg;
    [a, b] = linTransform(min([minA, minB]), max([maxA, maxB]), 1, 20);
    %[aB, bB] = linTransform(min(min(min(cell2mat(bImg)))), max(max(max(cell2mat(bImg)))), 150);
    for i = 1:length(aImg)
        aImg2{i} = round(aImg{i}.*a + b);
        bImg2{i} = round(bImg{i}.*a + b);
    end
    wcLAB = populateAffin_oldLAB(labelsList, maxLabels, spNeighbor, spList, aImg2, bImg2);
    
end
disp(sprintf('done, %.2f sec\n', toc(tE)));

if maxM > 0
    
    minUV = min([min(min(min(cell2mat(uv1)))), min(min(min(cell2mat(uv2))))]);
    maxUV = max([max(max(max(cell2mat(uv1)))), max(max(max(cell2mat(uv2))))]);
    
    [a, b] = linTransform(minUV, maxUV, 1, 50);
    uvMag = cell(numFrames,1);
    for i = 1:numFrames-1
        uv1{i} = round(uv1{i}.*a + b);
        uv2{i} = round(uv2{i}.*a + b);
        
        uvMag{i} = sqrt(uv1{i}.^2 + uv2{i}.^2);
        
        
    end
    uv1{numFrames} = ones(rowSize, colSize); %dummy frame
    uv2{numFrames} = ones(rowSize, colSize);
    
    
    tE = tic;
    disp('Computing the motion affinity matrix...');
    %motion feature
    
    %motion similarity for spacial neighbors only
    wm = populateAffin_oldMotion(labelsList, maxLabels, spNeighbor, spList, uv1, uv2, numFrames-1, labelCentroids1);
    disp(sprintf('done, %.2f sec\n', toc(tE)));
end

%set all features to its non-zero minimum
% wi(wi == 0) = min(nonzeros(wi));
% wc(wc == 0) = min(nonzeros(wc));
% wo(isnan(wo)) = 0;
% wo2 = wo;
% wo2(wo == 0) = min(nonzeros(wo));
% wl(wl == 0) = min(nonzeros(wl));
% wcLAB(wcLAB == 0 ) = min(nonzeros(wcLAB));
% wm(wm == 0) = eps;
% ignoreMotionInd = find(wm == 10);
% wm(ignoreMotionInd) = 1;
% [ignoreMotionInd] = sub2ind([max(to), max(to)], from(ignoreMotionInd), to(ignoreMotionInd));

tE = tic;
disp('Generating minimum spanning tree...');

wi(wi == 0) = eps;
wc(wc == 0) = eps;
%wc(wc >= 1) = 0;
wo(isnan(wo)) = 0;
% wo2 = wo;
% wo2(wo == 0) = eps;
wl(wl == 0) = eps;
%wl(wl >= 1) = 0;
totalVal = wi.*wl;

if maxLab > 0
    wcLAB(wcLAB == 0 ) = eps;
    totalVal = totalVal.*wcLAB;
end

if maxHue > 0
    totalVal = totalVal.*wc;
end

if maxM > 0
    wm(wm == 0) = eps;
    ignoreMotionInd = find(wm == 10);
    wm(ignoreMotionInd) = 1;
    [ignoreMotionInd] = sub2ind([max(to), max(to)], from(ignoreMotionInd), to(ignoreMotionInd));
    totalVal = totalVal.*wm;
end
% [coeff, score, variances] = princomp([wi, wc, wcLAB, wm, wl]);
% coeff = abs(coeff(:,1));
% totalVal = wi.*coeff(1,1) + wc.*coeff(2,1) + wcLAB.*coeff(3,1) + wm.*coeff(4,1) + wl.*coeff(5,1);
% minP = min(totalVal)-eps;
% totalVal = (totalVal-minP)';

% if useLAB == 1
%     totalVal = totalVal.*wcLAB;
% end
% if useHue == 1
%     totalVal = totalVal.*wc;
% end
% if useMotion == 1
%     totalVal = totalVal.*wm;
% end
% if useLocation == 1
%     totalVal = totalVal.*wl;
% end

DG = sparse(from, to, totalVal, max(to), max(to));

%the feature affinity matrices
sparseI = sparse(from, to, wi, max(to), max(to)); %all upper triangles

if maxHue > 0
    sparseC = sparse(from, to, wc, max(to), max(to));
end
if maxLab > 0
    sparseCLAB = sparse(from, to, wcLAB, max(to), max(to));
end
sparseO = sparse(from, to, wo, max(to), max(to));
% sparseOmin = sparse(from, to, wo2, max(to), max(to));
sparseL0 = sparse(from, to, wl, max(to), max(to));
sparseL = spalloc(max(to), max(to), length(temporalInd));
sparseL(temporalInd) = sparseL0(temporalInd); %only considers location if it is a temporal connection, for distribution fitting

if maxM > 0
    sparseM = sparse(from, to, wm, max(to), max(to)); 
end

%pick top k most similar (assume a region got splitted into at most k
%new sub-regions), from the temporal connections
k = 1;
tConnections(:,3) = DG(sub2ind([size(sparseI,1), size(sparseI,2)], tConnections(:,1), tConnections(:,2)));
tConnections = sortrows(tConnections, [1, 3]);

tConnectionsB = sortrows([tConnections(:,2), tConnections(:,1), tConnections(:,3)], [1,3]); %backwards
keepTopK(tConnections, k);
keepTopK(tConnectionsB, k);
tConnections = sortrows(tConnections);
tConnectionsB = sortrows([tConnectionsB(:,2), tConnectionsB(:,1), tConnectionsB(:,3)]);
% 
% tConnections(tConnections(:,3) > 0,3) = 1;
% tConnectionsB(tConnectionsB(:,3) > 0,3) = 1;
% removeInd = find(tConnections(:,3) - tConnectionsB(:,3) ~= 0);

% removeInd = find((tConnectionsB(:,3) + tConnections(:,3)) == 0);
removeInd = (tConnectionsB(:,3) + tConnections(:,3)) == 0;
removeSub = tConnections(removeInd,1:2);
removeInd2 = sub2ind([size(sparseI,1), size(sparseI,2)], removeSub(:,1), removeSub(:,2));

% wi(removeInd) = 0;
% wc(removeInd) = 0;
% wcLAB(removeInd) = 0;
% wm(removeInd) = 0;
% wl(removeInd) = 0;
% [coeff, score, variances] = princomp([wi, wc, wcLAB, wm, wl]);
% coeff = abs(coeff(:,1));
% totalVal = wi.*coeff(1,1) + wc.*coeff(2,1) + wcLAB.*coeff(3,1) + wm.*coeff(4,1) + wl.*coeff(5,1);
% minP = min(totalVal)-eps;
% totalVal = (totalVal-minP)';


sparseI(removeInd2) = 0;


% sparseOmin(removeInd2) = 0;
sparseO(removeInd2) = 0;
sparseL(removeInd2) = 0;

DG = sparseI.*sparseL;

if maxHue > 0
    sparseC(removeInd2) = 0;
    DG = DG.*sparseC;
end
if maxLab > 0
    sparseCLAB(removeInd2) = 0;
    DG = DG.*sparseCLAB;
end

if maxM > 0
    sparseM(removeInd2) = 0;
    DG = DG.*sparseM;
    sparseM(ignoreMotionInd) = 0;
end



%finally, build the MST
[S, C] = graphconncomp(DG, 'WEAK', true);


ST0 = spalloc(labelsList(end), labelsList(end), 2*labelsList(end));

%get MST for each sub trees, and combine them into a forest
for i = 1:S
    [i S];
    
    DG2 = DG;
    
    nonInd = find(C ~= i);
    
    DG2(nonInd,:) = 0;
    DG2(:, nonInd) = 0;
    
    [mst,pred] = graphminspantree(tril(DG2+ DG2'));
    
    %copy to the main forest
    ind = find(mst);
    ST0(ind) = mst(ind);
    
end
ST0 = ST0';
clear mst;

disp(sprintf('done, %.2f sec\n', toc(tE)));


% tic
% [ST0, pred] = graphminspantree(tril(DG+ DG'));
% toc
% ST0 = ST0';

tE = tic;
disp('Computing thresholds with WMM and performing edge labeling...');

ST1 = ST0;

%% perform edge removal using naive bayes

%max feature magnitudes
currMaxI = max(max(cell2mat(lImg)));
currMaxC = max(max(cell2mat(satImg)));
currMaxO = max(max(cell2mat(mag)));
currMaxM = 0;

if maxM > 0
    currMaxM = max(max(cell2mat(uvMag)));
end

sampleRate = 0.1;
c2Penalty = 1;

    
    tic
    beginLB = 1;
    endLB = labelsList(end-1);
    
    %for the temporal graph connection
    %[fromST,toST,~] = find(ST1(beginLB:endLB, beginLB:endLB));
    [fromST,toST,~] = find(ST0(beginLB:endLB, :));
    
    %perform outlier removal
%     sparseI2 = sparseI(beginLB:endLB,:);
%     sparseC2 = sparseC(beginLB:endLB,:);
%     sparseCLAB2 = sparseCLAB(beginLB:endLB,:);
%     sparseO2 = sparseO(beginLB:endLB,:);
    [sparseI2, outerFi] = outlierRemoval(sparseI(beginLB:endLB,:), 3);
    if maxHue > 0
    [sparseC2, outerFc] = outlierRemoval(sparseC(beginLB:endLB,:), 3);
    end
    if maxLab > 0
    [sparseCLAB2, outerFclab] = outlierRemoval(sparseCLAB(beginLB:endLB,:), 3);
    end
    [sparseO2, outerFo] = outlierRemoval(sparseO(beginLB:endLB,:), 3);
    if maxM > 0
        [sparseM2, outerFm] = outlierRemoval(sparseM(beginLB:endLB,:), 3);
    end
    %[sparseL2, outerLm] = outlierRemoval(sparseL(beginLB:endLB,:), 3);
    
    percentile = 0.6;
    
    %fit mixture of Weibull for the temporal merging by specified chunk
%     initDataI = wblInit( beginLB, edgeI, labelsList, spList, sparseI2, sampleRate, 'intensity');
    initDataI = [];
    [~, a1i1, ~, b1i1, ~, ~, resnormI21, optNi1, subX1] = wblMixture_EM2( beginLB, sparseI2, labelsList, fitMethod, 1, 'inensity', toShow );
    [p1i a1i a2i b1i b2i c2i resnormI2 optNi, subX2] = wblMixture_EM2( beginLB, sparseI2, labelsList, fitMethod, 2, 'intensity', toShow );
    
    if fitMethod == 1
        [aicI1, ~] = aicbic(resnormI21, 2, length(subX1));
        [aicI2, ~] = aicbic(resnormI2, 6, length(subX2));
    else
        
        aicI1 = aicRSS( optNi1, resnormI21, 2 ); %model selection
        aicI2 = aicRSS( optNi, resnormI2, 6 ); %model selection
    end
    [aicI1, aicI2];
    if aicI1 < aicI2
        threshI = wblinv(percentile, a1i1, b1i1);
    else
        threshI = findDip(subX1, p1i, a1i, a2i, b1i, b2i, c2i);
    end
    [lowAI, lowBI] = linTransform( eps, threshI, -1, 0);
    [hiAI, hiBI] = linTransform( threshI, max(max(sparseI2)), 0, c2Penalty);
    
    %hue
%     initDataHue = wblInit( beginLB, edgeHue, labelsList, spList, sparseC2, sampleRate, 'hsv');
if maxHue > 0
    initDataHue = [];
    [~, a1c1, ~, b1c1, ~, ~, resnormC21, optNc1, subX1] = wblMixture_EM2( beginLB, sparseC2, labelsList, fitMethod, 1, 'color HSV', toShow );
    [p1c a1c a2c b1c b2c c2c resnormC2 optNc, subX2] = wblMixture_EM2( beginLB, sparseC2, labelsList, fitMethod, 2, 'color HSV', toShow );
    
    if fitMethod == 1
        [aicC1, ~] = aicbic(resnormC21, 2, length(subX1));
        [aicC2, ~] = aicbic(resnormC2, 6, length(subX2));
    else
        aicC1 = aicRSS( optNc1, resnormC21, 2 ); %model selection
        aicC2 = aicRSS( optNc, resnormC2, 6 ); %model selection
    end
    [aicC1, aicC2];
    if aicC1 < aicC2
        threshC = wblinv(percentile, a1c1, b1c1);
    else
        threshC = findDip(subX1, p1c, a1c, a2c, b1c, b2c, c2c);
    end
    [lowAC, lowBC] = linTransform( eps, threshC, -1, 0);
    [hiAC, hiBC] = linTransform( threshC, max(max(sparseC2)), 0, c2Penalty);
end
    
    %LAB
%     initDataLab = wblInit( beginLB, edgeLAB, labelsList, spList, sparseCLAB2, sampleRate ,'lab');
if maxLab > 0
    initDataLab = [];
    [~, a1clab1, ~, b1clab1, ~, ~, resnormCLAB21, optNclab1, subX1] = wblMixture_EM2( beginLB, sparseCLAB2, labelsList, fitMethod, 1, 'color LAB', toShow );
    [p1clab a1clab a2clab b1clab b2clab c2clab resnormCLAB2 optNclab, subX2] = wblMixture_EM2( beginLB, sparseCLAB2, labelsList, fitMethod, 2, 'color LAB', toShow );
    
    if fitMethod == 1
        [aicLAB1, ~] = aicbic(resnormCLAB21, 2, length(subX1));
        [aicLAB2, ~] = aicbic(resnormCLAB2, 6, length(subX2));
    else
        aicLAB1 = aicRSS( optNclab1, resnormCLAB21, 2 ); %model selection
        aicLAB2 = aicRSS( optNclab, resnormCLAB2, 6 ); %model selection
    end
    [aicLAB1, aicLAB2];
    if aicLAB1 < aicLAB2
        threshLAB = wblinv(percentile, a1clab1, b1clab1);
    else
        threshLAB = findDip(subX1, p1clab, a1clab, a2clab, b1clab, b2clab, c2clab);
    end
    [lowALAB, lowBLAB] = linTransform( eps, threshLAB, -1, 0);
    [hiALAB, hiBLAB] = linTransform( threshLAB, max(max(sparseCLAB2)), 0, c2Penalty);
end
    
    %motion
%     initDataM = wblInit( beginLB, edgeM, labelsList, spList, sparseM2, sampleRate ,'motion');
if maxM > 0
    initDataM = [];
    mErr0 = 0;
    
    try
        [~, a1m1, ~, b1m1, ~, ~, resnormM21, optNm1, subX1] = wblMixture_EM2( beginLB, sparseM2, labelsList, fitMethod, 1, 'motion', toShow );
    catch err
        mErr0 = 1;
    end
    
    if mErr0 ~= 1
        try
            [p1m a1m a2m b1m b2m c2m resnormM2 optNm, subX2] = wblMixture_EM2( beginLB, sparseM2, labelsList, fitMethod, 2, 'motion', toShow );
        catch err
            resnormM2 = Inf;
            optNm = optNm1;
        end
        
        if fitMethod == 1
            [aicM1, ~] = aicbic(resnormM21, 2, length(subX1));
            [aicM2, ~] = aicbic(resnormM2, 6, length(subX2));
        else
        
            aicM1 = aicRSS( optNm1, resnormM21, 2 ); %model selection
            aicM2 = aicRSS( optNm, resnormM2, 6 ); %model selection
        end
        
        [aicM1, aicM2];
        if aicM1 < aicM2
            threshM = wblinv(0.95, a1m1, b1m1);
        else
            threshM = findDip(subX1, p1m, a1m, a2m, b1m, b2m, c2m);
        end
        [lowAM, lowBM] = linTransform( eps, threshM, -1, 0);
        [hiAM, hiBM] = linTransform( threshM, max(max(sparseM2)), 0, c2Penalty);
    end
    
end
    %[p1l a1l a2l b1l b2l c2l resnormL2 optNl] = wblMixture_EMNLS( sparseL2, numSP, fitMethod, 'sum', 2, 'location', 1 );
    
    Oerr = 0;
    if maxO > 0
        try
            startO = min(min(nonzeros(sparseO2)));
            tempO = sparseO2-startO;
            tempO(tempO < 0) = 0;
%             initDataO = wblInit( beginLB, edgeO, labelsList, spList, tempO, sampleRate, 'orientation');
            initDataO = [];
            [~, a1o1, ~, b1o1, ~, ~, resnormO21, optNo1, subX1] = wblMixture_EM2( beginLB, tempO, labelsList, fitMethod, 1, 'Orientation', toShow );
            [p1o a1o a2o b1o b2o c2o resnormO2 optNo, subX2] = wblMixture_EM2( beginLB, tempO, labelsList, fitMethod, 2, 'Orientation', toShow );
            
            if fitMethod == 1
                [aicO1, ~] = aicbic(resnormO21, 2, length(subX1));
                [aicO2, ~] = aicbic(resnormO2, 6, length(subX2));
            else
            
                aicO1 = aicRSS( optNo1, resnormO21, 2 ); %model selection
                aicO2 = aicRSS( optNo, resnormO2, 6 ); %model selection
            end
            
            [aicO1, aicO2];
            if aicO1 < aicO2
                threshO = wblinv(percentile, a1o1, b1o1);
            else
                threshO = findDip(subX1, p1o, a1o, a2o, b1o, b2o, c2o);
            end
            [lowAO, lowBO] = linTransform( eps, threshO, -1, 0);
            [hiAO, hiBO] = linTransform( threshO, max(max(tempO)), 0, c2Penalty);
    
    
        catch err
            Oerr = 1;
        end
    else
        Oerr = 1;
    end
  
    
    for j = 1:length(fromST)
        oErr2 = Oerr;

        %compute the posterior of the corresponded class
%         wblI = log(wblpdf(sparseI(fromST(j)+beginLB-1, toST(j))+eps, a1i, b1i)+eps);
%         wblC = log(wblpdf(sparseC(fromST(j)+beginLB-1, toST(j))+eps, a1c, b1c)+eps);
%         wblCLAB = log(wblpdf(sparseCLAB(fromST(j)+beginLB-1, toST(j))+eps, a1clab, b1clab)+eps);
%         wblO = 0;
%         wblM = 0;
        

        iScore = sparseI(fromST(j)+beginLB-1, toST(j))*lowAI+lowBI;
        if sparseI(fromST(j)+beginLB-1, toST(j)) > threshI
            iScore = min(1, sparseI(fromST(j)+beginLB-1, toST(j))*hiAI+hiBI);
        end
        
        if maxHue > 0
            cScore = sparseC(fromST(j)+beginLB-1, toST(j))*lowAC+lowBC;
            if sparseC(fromST(j)+beginLB-1, toST(j)) > threshC
                cScore = min(1, sparseC(fromST(j)+beginLB-1, toST(j))*hiAC+hiBC);
            end
        end
        
        if maxLab > 0
            labScore = sparseCLAB(fromST(j)+beginLB-1, toST(j))*lowALAB+lowBLAB;
            if sparseCLAB(fromST(j)+beginLB-1, toST(j)) > threshLAB
                labScore = min(1, sparseCLAB(fromST(j)+beginLB-1, toST(j))*hiALAB+hiBLAB);
            end
        end
        
        if maxM > 0
            
            mErr = 0;
            
            if mErr0 == 1 || sparseM(fromST(j)+beginLB-1, toST(j)) == 0
                mScore = 0;
                wblM = 0;
                mErr = 1;
                if useLog == 0
                    wblM = 1;
                end
            else
                
                wblM = log(wblpdf(sparseM(fromST(j)+beginLB-1, toST(j))+eps, a1m, b1m)+eps);
                
                mScore = sparseM(fromST(j)+beginLB-1, toST(j))*lowAM+lowBM;
                if sparseM(fromST(j)+beginLB-1, toST(j)) > threshM
                    mScore = min(1, sparseM(fromST(j)+beginLB-1, toST(j))*hiAM+hiBM);
                end
            end
        end
        
        if  maxO > 0 && Oerr == 0 && sparseO(fromST(j)+beginLB-1, toST(j))>= startO
            %wblO = log(wblpdf(sparseO(fromST(j)+beginLB-1, toST(j))-startO+eps, a1o, b1o)+eps);
            oScore = sparseO(fromST(j)+beginLB-1, toST(j))*lowAO+lowBO;
            if sparseO(fromST(j)+beginLB-1, toST(j)) > threshO
                oScore = min(1, sparseO(fromST(j)+beginLB-1, toST(j))*hiAO+hiBO);
            end
            
            if useLog == 0
                wblO = wblpdf(sparseO(fromST(j)+beginLB-1, toST(j))-startO+eps, a1o, b1o)+eps;
            end
        else
            oErr2 = 1;
        end
        
        if oErr2 == 1
            p1o = 0;
            oScore = 0;
        end

        %compute the adaptive feature weights
        maxWeights = [maxInt, maxHue, maxLab, maxO, maxM];
        currMaxes = [currMaxI, currMaxC, currMaxO, currMaxM];
        if maxM > 0
            [intW, hueW, labW, oriW, motionW] = findWeights(maxWeights, currMaxes, labelsList, fromST(j), toST(j), spList, satImg, lImg, uvMag, mag, mErr);
            fScore = intW*iScore+oriW*oScore+motionW*mScore;
        else
            [intW, hueW, labW, oriW, ~] = findWeights(maxWeights, currMaxes, labelsList, fromST(j), toST(j), spList, satImg, lImg, [], mag, []);
            fScore = intW*iScore+oriW*oScore;
        end
        
        if maxHue > 0
            fScore = fScore + hueW*cScore;
        end
        
        if maxLab > 0
            fScore = fScore + labW*labScore;
        end
        
        
        
        if fScore >=0
            ST1(fromST(j)+beginLB-1, toST(j)) = 0;
        else
            ST1(fromST(j)+beginLB-1, toST(j)) = fScore + 1;
        end
        
%         totalP1 = intW*p1i+hueW*p1c+labW*p1clab+oriW*p1o+motionW*p1m;
%         fNum = (p1i+p1c+p1clab+abs(oErr2-1)*p1o+abs(mErr-1)*p1m)/(3+abs(oErr2-1)+abs(mErr-1));
%         
%         c1 = log(fNum)+intW*wblI+hueW*wblC+labW*wblCLAB+oriW*wblO+motionW*wblM;
%         if useLog == 0
%             c1 = (fNum)*wblI*wblC*wblCLAB*wblO*wblM;
%         end
%         
%         %compute the posterior of the potentially incorrect correspondence class
%         wblI = log(wblpdf3(sparseI(fromST(j)+beginLB-1, toST(j))+eps, a2i, b2i, c2i)+eps);
%         wblC = log(wblpdf3(sparseC(fromST(j)+beginLB-1, toST(j))+eps, a2c, b2c, c2c)+eps);
%         wblCLAB = log(wblpdf3(sparseCLAB(fromST(j)+beginLB-1, toST(j))+eps, a2clab, b2clab, c2clab)+eps);
%         wblO = 0;
%         wblM = 0;
%         
%         if useLog == 0
%             wblI = wblpdf3(sparseI(fromST(j)+beginLB-1, toST(j))+eps, a2i, b2i, c2i)+eps;
%             wblC = wblpdf3(sparseC(fromST(j)+beginLB-1, toST(j))+eps, a2c, b2c, c2c)+eps;
%             wblCLAB = wblpdf3(sparseCLAB(fromST(j)+beginLB-1, toST(j))+eps, a2clab, b2clab, c2clab)+eps;
%             wblO = 0;
%             wblL = 0;
%             wblM = wblpdf3(sparseM(fromST(j)+beginLB-1, toST(j))+eps, a2m, b2m, c2m)+eps;
%         end
%         
%         if mErr == 1 || (aicM1 < aicM2)
%             wblM = 0;
%             if useLog == 0
%                 wblM = 1;
%             end
%         else
%             wblM = log(wblpdf3(sparseM(fromST(j)+beginLB-1, toST(j))+eps, a2m, b2m, c2m)+eps);
%         end
%         
%         if Oerr == 0 && sparseO(fromST(j)+beginLB-1, toST(j))>= startO
%             wblO = log(wblpdf3(sparseO(fromST(j)+beginLB-1, toST(j))-startO+eps, a2o, b2o, c2o)+eps);
%             if useLog == 0
%                 wblO = wblpdf3(sparseO(fromST(j)+beginLB-1, toST(j))-startO+eps, a2o, b2o, c2o)+eps;
%             end
%         end
%         
%         
%         c2 = log(1-fNum)+intW*wblI+hueW*wblC+labW*wblCLAB+oriW*wblO+motionW*wblM;
%         if useLog == 0
%             c2 = (1-fNum)*wblI*wblC*wblCLAB*wblO*wblM;
%         end
%         
%         if c2 >= c1
%             ST1(fromST(j)+beginLB-1, toST(j)) = 0;
%         else
%             ST1(fromST(j)+beginLB-1, toST(j)) = 1;
%         end
    end
    
    %     subST = ST1(beginLB:endLB,beginLB:endLB) + ST1(beginLB:endLB,beginLB:endLB)';
    %     subST = subST > 0;
    %
    %     [S, C] = graphconncomp(subST);
    toc


%ST1 = ST1 > 0;

[S, C] = graphconncomp(ST1, 'WEAK', true);

%generate the per-frame superpixel adjacency matrix
% tic
% spAdjMatrix = cell(length(labelsList), 1);
% initSP = 1;
% for i = 1:length(labelsList)
%     if i > 1
%         initSP = labelsList(i-1)+1;
%     end
%     
%     tempMatrix = spalloc(labelsList(end), labelsList(end), 10*(labelsList(i)-initSP+1));
%     for j = initSP:labelsList(i)
%         tempMatrix(j,spNeighbor{j}(spNeighbor{j}<=labelsList(i))) = 1;
%     end
%     spAdjMatrix{i} = tempMatrix;
% end
% toc
%     


%post process, make sure no proto-objects are spatially disjoint
spList = spList';
ST1 = checkDisjoint( ST1, labelsList, S, C, spList, zeros(size(inputImgG{1})), labels);

%[S, C] = graphconncomp(ST2, 'WEAK', true);

disp(sprintf('done, %.2f sec\n', toc(tE)));

%% produce the new merged label maps
%doFrames = 1:numFrames;
% 
% tE = tic;
% disp('Generating outputs...');

% finalLabels = zeros(rowSize, colSize, numFrames);
% %subVolume = mergedLabels(:,:,doFrames);
% 
% 
% for i = 1:numFrames
% 
%     
%     tempLB = zeros(rowSize, colSize);
%     
%     uniqueR = unique(labels(:,:,i));
%     
%     for j = 1:length(uniqueR)
%         
%         %ind = find(labels(:,:,doFrames(i)) == uniqueR(j));
%         ind = labels(:,:,i) == uniqueR(j);
%         
%         tempLB(ind) = C(uniqueR(j));
%         
%     end
%     
%     finalLabels(:,:,i) = tempLB;
% end
% 

% %now color them up
% customColors = round(rand(S,3).*255);
% 
% %save the outputs
% %writePath1 = 'E:\matlab2011b\work\video_segmentation\outputs\';
% for i = 1:numFrames
% 
%     colorFrame = zeros(rowSize, colSize, 3);
%     colorIDs = unique(finalLabels(:,:,i));
%     
%     for j = 1:length(colorIDs)
%         ind = find(finalLabels(:,:,i) == colorIDs(j));
%         colorFrame(ind) = customColors(colorIDs(j),1);
%         colorFrame(ind+rowSize*colSize) = customColors(colorIDs(j),2);
%         colorFrame(ind+2*rowSize*colSize) = customColors(colorIDs(j),3);
%     end
%     
%     numZ = '0000';
%     
%     if doFrames(i) < 10
%         writeNum = [numZ, num2str(doFrames(i))];
%     elseif doFrames(i) < 100
%         writeNum = ['000', num2str(doFrames(i))];
%     elseif doFrames(i) < 1000
%         writeNum = ['00', num2str(doFrames(i))];
%     elseif doFrames(i) < 10000
%         writeNum = ['0', num2str(doFrames(i))];
%     else
%         writeNum = num2str(doFrames(i));
%     end
%     
%     imwrite(uint8(colorFrame), [writePath1, 'colorImg_', writeNum, '.png'], 'BitDepth', 8);
% end
% 
% disp(sprintf('done, %.2f sec\n', toc(tE)));
% 
% output{1} = toc(t0);
% 
% %compute the average duration for each st-proto-object
% pDuration = zeros(S,1);
% for i = 1:S
%     for j = 1:length(doFrames)
%         if ~isempty(find(finalLabels(:,:,j) == i, 1))
%             pDuration(i,1) = pDuration(i,1) + 1;
%         end
%     end
% end
% 
% 
% output{2} = S;
% output{3} = mean(pDuration);

output{1} = ST1;
output{2} = labelsList;
output{3} = labels;

fprintf('Total processing time: %.2f sec\n\n', toc(t0));

% trackLabels = [20 19 29 25] ;
% [outSegImg, outSegMask, outBoxImg, outBoxMask] = trackRegions( trackLabels, finalLabels, inputImg );
% 
%write out the tracked output
% for i = 1:length(doFrames)
%     [i length(doFrames)]
%     
%     numZ = '0000';
%     
%     if doFrames(i) < 10
%         writeNum = [numZ, num2str(doFrames(i))];
%     elseif doFrames(i) < 100
%         writeNum = ['000', num2str(doFrames(i))];
%     elseif doFrames(i) < 1000
%         writeNum = ['00', num2str(doFrames(i))];
%     elseif doFrames(i) < 10000
%         writeNum = ['0', num2str(doFrames(i))];
%     else
%         writeNum = num2str(doFrames(i));
%     end
%     
%     imwrite(uint8(outSegImg{i}), [writePath1, 'segImg_', writeNum, '.png'], 'BitDepth', 8); 
%     imwrite(uint8(outBoxImg{i}), [writePath1, 'boxImg_', writeNum, '.png'], 'BitDepth', 8); 
% end
% 
% cmapVideo = VideoWriter('out.avi');
% cmapVideo.FrameRate = 5;
% open(cmapVideo);
% for i = 1:length(doFrames)
% 
%     [i length(doFrames)]
% 
%     colorFrame = zeros(rowSize, colSize, 3);
%     colorIDs = unique(finalLabels(:,:,i));
% 
%     for j = 1:length(colorIDs)
%         ind = find(finalLabels(:,:,i) == colorIDs(j));
%         colorFrame(ind) = customColors(colorIDs(j),1);
%         colorFrame(ind+rowSize*colSize) = customColors(colorIDs(j),2);
%         colorFrame(ind+2*rowSize*colSize) = customColors(colorIDs(j),3);
%     end
% 
%     writeVideo(cmapVideo, uint8(colorFrame));
% end
% close(cmapVideo);
% 

















