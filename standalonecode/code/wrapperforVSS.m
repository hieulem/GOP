function [ affinity_matrix ] = wrapperforVSS( labelled_level_video,cim )
%WRAPPERFORVSS Summary of this function goes here
%%realign sp map
sp =labelled_level_video;
numi = size(cim,2);
for i=1:numi
    ssp(i) = min(min(sp(:,:,i)));
end
meta= cim{1};
[h,w,~] = size(cim{1});
img =  uint8(zeros(size(meta,1),size(meta,2),3,numi));
for i=1:numi
    img(:,:,:,i) = cim{i};
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
model2=model;
model2.opts.nms=1; model2.opts.nThreads=4;
model2.opts.multiscale=1; model2.opts.sharpen=2;
sed = single(zeros(h,w,numi));
parfor i=1:numi
    [i1,~,~,~]= edgesDetect(img(:,:,:,i),model);
   % [i2,~,~,~]= edgesDetect(img(:,:,:,i),model2);
    sed(:,:,i) = i1;%+i2;
end
%%

%display(['Spatial edges extraction : ',num2str(tmp)]);
% %%Motion boundary
% %%
% tic
% [motionboundaries,~] = computeflowandmotionb( img,flowpath,flowfile );
% tmp=toc;
% display(['Motion boundaries extraction : ',num2str(tmp)]);
a = load('/home/hle/Project/GOP/flow_data/flow_motion_default/segtrack/flowgirl');
edge = sed + a.motionboundaries+ 1e-20;
%edge = sed + 1e-20;
figure(1);imagesc(edge(:,:,1));
%%aff

affinity_matrix  = compute_affinitymatrix( sp,splist,edge,img);
tmp = toc;
display(['Affinity computation time : ',num2str(tmp)]);
end


