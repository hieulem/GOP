profile on;
filename='hummingbird.png';video_name ='test';nseeds =10;
addpath(genpath('.'));

addpath(genpath('../outsource'));

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

I=imread(filename);
I = imresize(I,[240,NaN]);

[E,~,~,segs]=edgesDetect(I,model);
[sp,V] = spDetect(I,E,opts);
E = E+1e-20;
sp=sp+1;
Z = spAffinities_vu(sp,E);
Z = sparse(double(Z));
Z(Z<0) =0 ;
se = extract_seeds(nseeds,Z);
B = visgeodistance(sp,Z,se);
A = E*0;
for i=1:nseeds
    A(sp == se(i)) = 1;
end;
A = uint8(repmat(A,[1,1,3]));
II = I;
II(A==1) = 255;

figure(6);imagesc(II);
%testmm
%popreg(I,se,Z,sp);
%saveas(gcf,['out_' filename],'bmp');


