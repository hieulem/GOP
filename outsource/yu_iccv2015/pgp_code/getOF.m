
%% segTrack

%dataSet = {'birdfall2', 'cheetah', 'girl', 'monkeydog', 'parachute', 'penguin'};
%fileType = {'png', 'bmp', 'bmp', 'bmp', 'png', 'bmp'};
dataSet = {'bird_of_paradise', 'bmx', 'drift', 'frog', 'hummingbird', 'monkey', 'soldier', 'worm'};
fileType = {'png', 'png', 'png', 'png', 'png', 'png', 'png', 'png'};

imgPath = 'E:\matlab2011b\work\video_segmentation\data\SegTrackv2\JPEGImages\';
savePath = 'E:\matlab2011b\work\video_segmentation\data\SegTrackV2\motions\';

for j = 1:length(dataSet)
    ['segTrack2']
    [j length(dataSet)]
    
    imgs = dir([imgPath, dataSet{j}, '\*.', fileType{j}]);
    uv = cell(length(imgs)-1,1);
    
    for i = 1:length(imgs)-1
        img1 = imread([imgPath, dataSet{j}, '\', imgs(i).name]);
        img2 = imread([imgPath, dataSet{j}, '\', imgs(i+1).name]);
        
        uv{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
    end
    
    save([savePath, dataSet{j}, '.mat'], 'uv');
    
end


%% chen
dataSet = {'bus_fa', 'container_fa', 'garden_fa', 'ice_fa', 'paris_fa', 'salesman_fa', 'soccer_fa', 'stefan_fa'};


imgPath = 'E:\matlab2011b\work\video_segmentation\data\Chen_Xiph.org\';
savePath = 'E:\matlab2011b\work\video_segmentation\data\Chen_Xiph.org\motions\';

for j = 1:length(dataSet)
    ['Chen']
    [j length(dataSet)]
    
    imgs = dir([imgPath, dataSet{j}, '\frames\*.png']);
    uv = cell(length(imgs)-1,1);
    
    for i = 1:length(imgs)-1
        img1 = imread([imgPath, dataSet{j}, '\frames\', imgs(i).name]);
        img2 = imread([imgPath, dataSet{j}, '\frames\', imgs(i+1).name]);
        
        uv{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
    end
    
    save([savePath, dataSet{j}, '.mat'], 'uv');
    
end

%% GA tech
t = dir('E:\matlab2011b\work\video_segmentation\data\GaTech\originals'); 

dataSet = [];
count = 1;
for i = 3:length(t)
    if t(i).isdir == 1
        dataSet{count} = t(i).name;
        count = count + 1;
    end
end

imgPath = 'E:\matlab2011b\work\video_segmentation\data\GaTech\originals\';
savePath = 'E:\matlab2011b\work\video_segmentation\data\GaTech\motions\';

for j = 1:length(dataSet)
    ['GA tech']
    [j length(dataSet)]
    
    imgs = dir([imgPath, dataSet{j}, '\*.jpg']);
    uv = cell(length(imgs)-1,1);
    
    toSeg = min([length(imgs)-1, 100]);
    
    for i = 1:toSeg
        img1 = imread([imgPath, dataSet{j}, '\', imgs(i).name]);
        img2 = imread([imgPath, dataSet{j}, '\', imgs(i+1).name]);
        
        uv{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
    end
    
    save([savePath, dataSet{j}, '.mat'], 'uv');
    
end





