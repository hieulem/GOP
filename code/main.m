
addpath(genpath('../outsource'));
clear;
video_name_array = {
    'birdfall';
    'cheetah';
    'monkeydog';
    'girl';
    'penguin';
    'parachute';
    'bmx';
    'drift';
    'hummingbird';
    'monkey';
    'soldier';
    'bird_of_paradise';
    'frog';
    'worm';
    
    };

i=5;video_name = video_name_array{i};
numsp = 400;
supDIR = ['./temp/' video_name, '/'];
mkdir(supDIR);
load(['./CPres/', int2str(numsp), '/',video_name, '.mat']);
%% load pre-trained edge detection model and set opts (see edgesDemo.m)
model=load('models/forest/modelBsds'); model=model.model;
model.opts.nms=-1; model.opts.nThreads=4;
model.opts.multiscale=0; model.opts.sharpen=2;

%% set up opts for spDetect (see spDetect.m)
opts = spDetect;
opts.nThreads = 4;  % number of computation threads
opts.k = 500;       % controls scale of superpixels (big k -> big sp)
opts.alpha = .5;    % relative importance of regularity versus data terms
opts.beta = .9;     % relative importance of edge versus color terms
opts.merge = 0;     % set to small value to merge nearby superpixels at end
opts.bounds = 0;

input.path  = ['../video/SEG/JPEGImages/' video_name '/'];
input.imglist = dir(input.path);input.imglist(1:2) =[];
input.numi = size(input.imglist,1);
i = imread([input.path,input.imglist(1).name]);
i = imresize(i,[240,NaN]);
input.w = size(i,1);input.h = size(i,2);
input.imgs = zeros(input.w,input.h,3,input.numi,'uint8');
%input.Imgs = zeros(input.w,input.h,3,numi,'uint8');
Vs = single(input.imgs);
U = zeros(input.w,input.h,input.numi);
for i =1:input.numi
    input.imgs(:,:,:,i) = imresize(imread([input.path,input.imglist(i).name]),[240,NaN]);
end;
 input.imgs = permute(input.imgs,[1,2,4,3]);
 nseeds =5;
%% compute ultrametric contour map from superpixels (see spAffinities.m)

for i =1:input.numi
    I=squeeze(input.imgs(:,:,i,:));
    [E,~,~,segs]=edgesDetect(I,model);
   % [se,~] = spDetect(I,E,opts); 
   % [Z,~,Y]=spAffinities(se,E,segs,opts.nThreads);
    E = E+1e-20;
    Z = spAffinities_vu(uint32(outputs{1}(:,:,i)),E);
    Z(Z==inf) = 0;
    %[Z,~,Y]=spAffinities(uint32(outputs{1}(:,:,i)),E,segs,opts.nThreads);
    xedges(i,1:size(Z,1),1:size(Z,2)) = Z;
end;
% numx = squeeze(sum(xedges>0,1));
% 
% meanx = squeeze(sum(xedges,1))./numx;
% 
% seeds(i,:) = extract_seeds(nseeds,meanx);
% 
% A = E*0;
% for i=1:10
%     A(sp == se(i)) = 1;
% end;
% A = uint8(repmat(A,[1,1,3]));
% II = I.*A;
% figure(6);imagesc(II+I);
% 

% tic;
% for i=1:input.h
%     i
%     I=squeeze(input.imgs(:,i,:,:));
%     [E,~,~,segs]=edgesDetect(I,model);
%    % [seed(:,:,i),Vs(:,:,:,i)] = spDetect(I,E,opts); 
%     [Z,~,Y]=spAffinities(uint32(squeeze(outputs{1}(:,i,:))),E,segs,opts.nThreads);
%     yedges(i,1:size(Z,1),1:size(Z,2)) = Z;
% end
% toc
% tic
% 
% for i=1:input.w
%     i
%     I=squeeze(input.imgs(i,:,:,:));
%     [E,~,~,segs]=edgesDetect(I,model);
%    % [seed(:,:,i),Vs(:,:,:,i)] = spDetect(I,E,opts); 
%     [Z,~,Y]=spAffinities(uint32(squeeze(outputs{1}(i,:,:))),E,segs,opts.nThreads);
%     zedges(i,1:size(Z,1),1:size(Z,2)) = Z;
% end
% toc
% 
% 
% save([supDIR '/x.mat'],'xedges','-v7.3')
% save([supDIR '/y.mat'],'yedges','-v7.3')
% save([supDIR '/z.mat'],'zedges','-v7.3')

flatten;
%figure(4);playMovie([sp],5,-1,struct('hasChn',0,'showLines',1));
