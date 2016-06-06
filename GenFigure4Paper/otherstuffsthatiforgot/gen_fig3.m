names ={'bird_of_paradise','birdfall','bmx','cheetah','drift','frog','girl','hummingbird','monkey','monkeydog','parachute','penguin','soldier','worm'};
name = names{9}
gt = ['../video/Seg/GroundTruth/', name,'/1'];
input = ['../video/Seg/JPEGImages/', name];


% d = 'soldier';
% d =input
% d2 = ['GT',d];
% d3 = ['ours',d];
% d4 = ['theirs',d];
% 
% mkdir(d2);mkdir(d3);mkdir(d4);
% a = dir(d);a(1:2) = [];
% g= dir(gt);g(1:2)=[];
% o = dir(input);o(1:2)=[];
% 
% for i=1:length(a)
%     ip=  imread(fullfile(input,o(i).name));
%      ip2 =ip;
%     gtim = imread(fullfile(gt,g(i).name));
%     
%    
%     ip = ip/1.5;
%     ip(:,:,2) = ip(:,:,2) + gtim(:,:,2)/2;
%   %  imwrite(ip,fullfile(d2,a(i).name));
%     
%     
%     tmp = allthesegmentations{2}(:,:,i) ;
%     tmp(tmp==2) = 0;
%     ip2=ip2/1.5;
%     ip2(:,:,2) = ip2(:,:,2) + tmp*100;
%     
%     imwrite(ip2,fullfile(d4,a(i).name));
%     
% end



% d2 = 'GTmonkey';
% d4 = 'ourmk100';
% d3 = 'theirmk100';
% b1 = dir(d2);b1(1:2) = [];
% b2 = dir(d3);b2(1:2) = [];
% b3 = dir(d4);b3(1:2) = [];
% ch=1:4:20
% im1 =[];im2=[];im3=[];
% im = imread(fullfile(d3,b2(ch(1)).name));
% for i=1:length(ch)
%     im1 = [im1, 255*ones(size(im,1),1,3),imresize(imread(fullfile(d2,b1(ch(i)).name)),[240,427]), 255*ones(size(im,1),1,3)];
%     im2 = [im2, 255*ones(size(im,1),1,3),imread(fullfile(d3,b2(ch(i)).name)), 255*ones(size(im,1),1,3)];
%     im3 = [im3, 255*ones(size(im,1),1,3),imread(fullfile(d4,b3(ch(i)).name)), 255*ones(size(im,1),1,3)];
%     b2(ch(i)).name
% end


% d2 = 'GTsoldier'
% d4 = 'mysol'
% d3 = 'theirsol'
% b1 = dir(d2);b1(1:2) = [];
% b2 = dir(d3);b2(1:2) = [];
% b3 = dir(d4);b3(1:2) = [];
% ch=1:4:20
% im1 =[];im2=[];im3=[];
% im = imread(fullfile(d3,b2(ch(1)).name));
% % for i=1:length(ch)
% %     im1 = [im1, 255*ones(size(im,1),1,3),imresize(imread(fullfile(d2,b1(ch(i)).name)),[240,427]), 255*ones(size(im,1),1,3)];
% %     im2 = [im2, 255*ones(size(im,1),1,3),imread(fullfile(d3,b2(ch(i)).name)), 255*ones(size(im,1),1,3)];
% %     im3 = [im3, 255*ones(size(im,1),1,3),imread(fullfile(d4,b3(ch(i)).name)), 255*ones(size(im,1),1,3)];
% %     b2(ch(i)).name
% % end
% for i=1:length(ch)
%     im1 = [im1, 255*ones(size(im,1),1,3),imread(fullfile(d2,b1(ch(i)).name)), 255*ones(size(im,1),1,3)];
%     im2 = [im2, 255*ones(size(im,1),1,3),imread(fullfile(d3,b2(ch(i)).name)), 255*ones(size(im,1),1,3)];
%     im3 = [im3, 255*ones(size(im,1),1,3),imread(fullfile(d4,b3(ch(i)).name)), 255*ones(size(im,1),1,3)];
%     b2(ch(i)).name
% end

% d2 = 'garden_fa';
% d3 = 'theirgar400';
% d4 = 'ourgar400';
% d5 = '2';
% d6 = '3';
% b2 = dir(d2);b2(1:2) = [];
% b3 = dir(d3);b3(1:2) = [];
% b4 = dir(d4);b4(1:2) = [];
% b5 = dir(d5);b5(1:2) = [];
% b6 = dir(d6);b6(1:2) = [];
%ch=5:7:50
 d2 = 'GTmonkey';
 
 d3 = 'theirmk100';
 d4 = 'ourmk100';
 d5 = '2';
 d6 = '3';
 b2 = dir(d2);b2(1:2) = [];
b3 = dir(d3);b3(1:2) = [];
b4 = dir(d4);b4(1:2) = [];
b5 = dir(d5);b5(1:2) = [];
b6 = dir(d6);b6(1:2) = [];
ch=14:2:22
im1 =[];im2=[];im3=[];im4=[];im5=[];
im = imread(fullfile(d2,b2(ch(1)).name));
for i=1:length(ch)
    im1 = [im1, 255*ones(size(im,1),1,3),imresize(imread(fullfile(d2,b2(ch(i)).name)),[270,480]), 255*ones(size(im,1),1,3)];
    im2 = [im2, 255*ones(size(im,1),1,3),imresize(imread(fullfile(d3,b3(ch(i)).name)),[270,480]), 255*ones(size(im,1),1,3)];
    im3 = [im3, 255*ones(size(im,1),1,3),imresize(imread(fullfile(d4,b4(ch(i)).name)),[270,480]), 255*ones(size(im,1),1,3)];
    im4 = [im4, 255*ones(size(im,1),1,3),imresize(imread(fullfile(d5,b5(ch(i)).name)),[270,480]), 255*ones(size(im,1),1,3)];
    im5 = [im5, 255*ones(size(im,1),1,3),imresize(imread(fullfile(d6,b6(ch(i)).name)),[270,480]), 255*ones(size(im,1),1,3)];
    b3(ch(i)).name;
end



imshow([im1;...
    255*ones(1,size(im1,2),3);255*ones(1,size(im1,2),3);255*ones(1,size(im1,2),3);...
    im2;255*ones(1,size(im1,2),3);255*ones(1,size(im1,2),3);255*ones(1,size(im1,2),3);...
    im3;255*ones(1,size(im1,2),3);255*ones(1,size(im1,2),3);255*ones(1,size(im1,2),3);...
    im4;255*ones(1,size(im1,2),3);255*ones(1,size(im1,2),3);255*ones(1,size(im1,2),3);im5])
print('-depsc','f1')

