close all;
clear;
addpath(genpath('.'));
addpath(genpath('../outsource/'));

%% load pre-trained edge detection model and set opts (see edgesDemo.m)
model=load('models/forest/modelBsds'); model=model.model;
model.opts.nms=-1; model.opts.nThreads=4;
model.opts.multiscale=0; model.opts.sharpen=2;

%% set up opts for spDetect (see spDetect.m)
opts = spDetect;
opts.nThreads = 4;  % number of computation threads
opts.k = 700;       % controls scale of superpixels (big k -> big sp)
opts.alpha = .5;    % relative importance of regularity versus data terms
opts.beta = .9;     % relative importance of edge versus color terms
opts.merge = 0;     % set to small value to merge nearby superpixels at end
opts.bounds = 0;


img(:,:,:,1) = imread('00010.png');
img(:,:,:,2) = imread('00020.png');


[E(:,:,1),~,~,segs]=edgesDetect(img(:,:,:,1),model);
[sp(:,:,1),V] = spDetect(img(:,:,:,1),E(:,:,1),opts); 

[E(:,:,2),~,~,segs]=edgesDetect(img(:,:,:,2),model);
[sp(:,:,2),V] = spDetect(img(:,:,:,2),E(:,:,2),opts); 

sp = sp+1;
figure();imagesc(sp(:,:,1));
figure();imagesc(sp(:,:,2));




%%Spatial edge:
model=load('models/forest/modelBsds'); 
model=model.model;
model.opts.nms=0; model.opts.nThreads=4;
model.opts.multiscale=0; model.opts.sharpen=0;
model2=model;
model2.opts.nms=1; model2.opts.nThreads=4;
model2.opts.multiscale=1; model2.opts.sharpen=2;
[h,w,~,numi] = size(img);
sed = single(zeros(h,w,numi));
for i=1:numi
    [i1,~,~,~]= edgesDetect(img(:,:,:,i),model);
   % [i2,~,~,~]= edgesDetect(img(:,:,:,i),model2);
    sed(:,:,i) = i1;%+i2;
end

edge= double(sed + 1e-20);

for i=1:numi
    splist(i) = max(max(sp(:,:,i)));
end

save('meta');