function [ affinity_matrix ] = wrapperforCP( labelled_level_video,flowpath,flowfile,path )
%WRAPPERFORVSS Summary of this function goes here

%%realign sp map

d = dir(path);d(1:2) = [];
sp =labelled_level_video;
numi = length(d);
for i=1:numi
    ssp(i) = min(min(sp(:,:,i)));
end

meta = imread(fullfile(path,d(1).name));
[h,w,~] = size(meta);
img =  uint8(zeros(size(meta,1),size(meta,2),3,numi));
for i=1:numi
    img(:,:,:,i) = imread(fullfile(path,d(i).name));
    sp(:,:,i) = sp(:,:,i) - ssp(i)+1;
    splist(i) = max(max(sp(:,:,i)));
end

%%
tic
%%
%%Spatial edge:
model=load('models/forest/modelBsds'); 
model=model.model;
model.opts.nms=0; model.opts.nThreads=4;
model.opts.multiscale=0; model.opts.sharpen=0;
sed = single(zeros(h,w,numi));
parfor i=1:numi
    [sed(:,:,i),~,~,~]=edgesDetect(img(:,:,:,i),model);
end
%%
tmp=toc;
display(['Spatial edges extraction : ',num2str(tmp)]);
%%Motion boundary
%%
tic
[motionboundaries,~] = computeflowandmotionb( img,flowpath,flowfile );
tmp=toc;
display(['Motion boundaries extraction : ',num2str(tmp)]);
affinity_matrix=0;
%edge = sed + motionboundaries + 1e-20;
%%aff
%tic
%affinity_matrix  = compute_affinitymatrix( sp,splist,edge,img);
%tmp = toc;
%display(['Aff computation : ',num2str(tmp)]);
end


