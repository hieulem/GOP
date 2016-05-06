%pgpMain.m
%
%main functio for the Parametric Graph Partitioning method for video
%partitioning.
%
%

function preprocess( inputDIR, saveName, spType, numSP) 

tP = tic;

toResize = 0;

inFrames = dir(inputDIR);
inFrames(1) = [];  %.
inFrames(1) = [];  %..
doFrames = 1:length(inFrames);
% doFrames = 1:150;
numFrames = length(doFrames);
% numFrames = 150;

isGray = 0;
if size(imread([inputDIR, inFrames(1).name]), 3) == 1
    isGray = 1;
end


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

tP = toc(tP);

save(saveName);



