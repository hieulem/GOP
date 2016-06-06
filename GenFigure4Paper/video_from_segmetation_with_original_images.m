function [ output_args ] = video_from_segmetation( img,out,sp1,sp2,TextMask1,TextMask2 )
addpath('AddTextToImage');
%VIDEO_FROM_SEGMETATION Summary of this function goes here
%   Detailed explanation goes here
v = VideoWriter([out],'MPEG-4');

%v.FrameRate = 25;
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
    img{i} = imresize(img{i},[size(v1{1},1),size(v1{1},2)]);
    im1 = img{i}*0.05 +v1{i}*0.95 ;
    im2 = img{i}*0.05 +v2{i}*0.95 ;
    im = [im1,im2];
    s = size(im);
    
    im = AddTextToImage(im,'baseline',[10,floor(s(2)/4-50)],[1,1,1],'Times New Roman',32,TextMask1);
    im = AddTextToImage(im,'+our feature',[10,floor(s(2)/4*3-50)],[1,1,1],'Times New Roman',32,TextMask2);

      %  im = imresize(im, 0.5, 'nearest');

    writeVideo(v,im);
end

close(v);

end

