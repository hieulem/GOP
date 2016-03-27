% load pre-trained edge detection model and set opts (see edgesDemo.m)

model=load('models/forest/modelBsds'); 
model=model.model;
model.opts.nms=0; model.opts.nThreads=4;
model.opts.multiscale=1; model.opts.sharpen=0;
model.opts.shrink = 1;
[Gmag,Gdir] = imgradient(rgb2gray(I(:,:,:,ii)));

[ed,~,~,segs]=edgesDetect(I(:,:,:,ii),model);
Gmag = Gmag/max(max(Gmag));
figure(3);imagesc([ed,ed2])