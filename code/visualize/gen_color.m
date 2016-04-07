% source_frame=2;
% target_frame =3;
% 
% spi1 = sp(:,:,source_frame);
% spi2 = sp(:,:,target_frame);
% mapp = [[1:splist(target_frame)]',MAP{source_frame}'];
% sp_test = convertspmap(spi2,[[1:splist(target_frame)]',MAP{source_frame}']);
% aa(:,:,1) = spi1;
% aa(:,:,2) = sp_test;
% gen_color;


%sp2= sp;

allsp =double(0);
%map{1} = [[1:splist(1)]',[1:splist(1)]'];
sp2 = sp;
for frame=1:2
    numsp = double(splist(frame));  
    ind=map{frame}(:,2)==0 ;
    map{frame}= map{frame}  + allsp;
     map{frame}(:,2) = map{frame}(:,2) + numsp;
     if ~isempty(ind)
        map{frame}(ind,2) = 0;
     end
    
    sp2(:,:,frame) = sp2(:,:,frame) + allsp;
    allsp = allsp +numsp;
    %map{frame} = convertmap2map(map{frame},map{frame-1});
%    convertmap2map(map{frame},map{frame-1});
end

map{21} = [[(allsp+1):(allsp+splist(21))]',[(allsp+1):(allsp+splist(21))]'];
for frame=20:-1:1
    map{frame} = convertmap2map(map{frame},map{frame+1});
end


video_name ='girl2';
for i=1:21
    i;
    s=sp2(:,:,i);
    
    s = convertspmap(s,map{i});
    sp2(:,:,i) = s;
end


S = max(max((max(sp2))));
customColors = round(rand(S,3).*255);
doFrames=size(sp2,3);
%save the outputs
writePath1 = ['hist_', video_name];
mkdir(writePath1);
k= pwd;
cd(writePath1);
[rowSize, colSize,~] = size(sp);



for i = 1:doFrames
    
    [i length(doFrames)]
    
    colorFrame = zeros(rowSize, colSize, 3);
    colorIDs = unique(sp2(:,:,i));
    
    for j = 1:length(colorIDs)
        ind = find(sp2(:,:,i) == colorIDs(j));
        colorFrame(ind) = customColors(colorIDs(j),1);
        colorFrame(ind+rowSize*colSize) = customColors(colorIDs(j),2);
        colorFrame(ind+2*rowSize*colSize) = customColors(colorIDs(j),3);
    end
    
    numZ = '0000';
    
    writeNum = num2str(i);

    
    imwrite(uint8(colorFrame), [writePath1, 'colorImg_', writeNum, '.png'], 'BitDepth', 8);
end

cd(k);
addpath('eval_code');
num = evaluation_segtrackV2(writePath1,gtpath)