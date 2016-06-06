function [ output_args ] = video_from_segmetation_s( img,out,sp,TextMask,rsratio )
addpath('AddTextToImage');
%VIDEO_FROM_SEGMETATION Summary of this function goes here
%   Detailed explanation goes here
vid = VideoWriter(out);
%v.FrameRate = 25;
open(vid);
if ~exist('rsratio','var')
    rsratio =1;
end;

num_segmentation = size(sp,2);
v= cell(num_segmentation,size(sp{1},3));
for ii=1:num_segmentation
    
    S = max(max((max(sp{ii}))));
    customColors = round(rand(S,3).*255);
    doFrames=size(sp{ii},3);
    
    [rowSize, colSize,~] = size(sp{ii});
    colorFrame = zeros(rowSize, colSize, 3);
    
    
    for i = 1:doFrames
        
        [i length(doFrames)];
        
        colorFrame = zeros(rowSize, colSize, 3);
        colorIDs = unique(sp{ii}(:,:,i));
        
        for j = 1:length(colorIDs)
            ind = find(sp{ii}(:,:,i) == colorIDs(j));
            colorFrame(ind) = customColors(colorIDs(j),1);
            colorFrame(ind+rowSize*colSize) = customColors(colorIDs(j),2);
            colorFrame(ind+2*rowSize*colSize) = customColors(colorIDs(j),3);
        end
        v{ii,i} = uint8(colorFrame);
        
        %writeVideo(v,uint8(colorFrame));
        
    end
end;


for i=1:doFrames
    img{i} = imresize(img{i},[size(v{1,1},1),size(v{1,1},2)]);
    s = size(img{1});
    im=[];
    for ii=1:num_segmentation
        
        im1 = img{i}*0.05 +v{ii,i}*0.95 ;
    %  im1 = v{ii,i};
        im1 = AddTextToImage(im1,'baseline',[10,floor(s(2)/4-50)],[1,1,1],'Times New Roman',32,TextMask{ii});
        im = [im,im1];
    end
    %im = [img{i},im];
    if(s(1)>150)
        im = imresize(im, rsratio, 'nearest');
    end;
    imwrite(im,[num2str(i),'.png']);
    writeVideo(vid,im);
end


close(vid);

end

