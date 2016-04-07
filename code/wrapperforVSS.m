function [ affinity_matrix ] = wrapperforVSS( labelled_level_video,flowpath,flowfile,path )
%WRAPPERFORVSS Summary of this function goes here

%%realign sp map

d = dir(path);d(1:2) = [];
sp =labelled_level_video;
ssp = min(sp,[],3);
numi = length(d);
meta = imread(fullfile(path,d(i).name));
[h,w,~] = size(meta);
img = zeros(size(meta,1),size(meta,2),3,numi);
for i=1:numi
    img(:,:,:,i) = imread(fullfile(path,d(i).name));
    sp(:,:,i) = sp(:,:,i) - ssp(i)+1;
end
splist = max(sp,[],3);
%%

%%
%%Spatial edge:
model=load('models/forest/modelBsds'); 
model=model.model;
model.opts.nms=1; model.opts.nThreads=4;
model.opts.multiscale=1; model.opts.sharpen=0;
sed = zeros(h,w,numi);
for i=1:numi
    [sed(:,:,i),~,~,~]=edgesDetect(img(:,:,:,ii),model);
end
%%

%%Motion boundary
%%
[motionboundaries,~] = computeflowandmotionb( img,flowpath,flowfile );


edge = sed + motionboundaries;
%%aff
affinity_matrix  = compute_affinitymatrix( sp,splist,edge,img);
end


