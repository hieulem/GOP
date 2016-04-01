% load pre-trained edge detection model and set opts (see edgesDemo.m)

model=load('models/forest/modelBsds'); 
model=model.model;
model.opts.nms=1; model.opts.nThreads=4;
model.opts.multiscale=1; model.opts.sharpen=0;
%model.opts.shrink = 2;



      

% set up opts for spDetect (see spDetect.m)
opts = spDetect;
opts.nThreads = 4;  % number of computation threads
opts.k = 512;       % controls scale of superpixels (big k -> big sp)
opts.alpha = 0.2;    % relative importance of regularity versus data terms
opts.beta = .9;     % relative importance of edge versus color terms
opts.merge = 0;     % set to small value to merge nearby superpixels at end
opts.bounds = 0;


sp_c = 0;
psp = 1;
w={};
nseeds =100;


inp.imglist = dir(inp.path);inp.imglist(1:2) =[];
inp.numi = size(inp.imglist,1);

filename = [inp.path,inp.imglist(1).name];
t = imresize(imread(filename),[240,NaN]);
%t= imread(filename);
h= size(t,1);w= size(t,2);
labt = rgb2lab(t);
clinf.maxL = max(max(labt(:,:,1)));
clinf.minL = min(min(labt(:,:,1)));
clinf.maxA = max(max(labt(:,:,2)));
clinf.minA = min(min(labt(:,:,2)));
clinf.maxB = max(max(labt(:,:,3)));
clinf.minB = min(min(labt(:,:,3)));
LABnorm1 = zeros(h,w,3);


nbins=20;
LABnorm1(:,:,1) = ones(h,w) * clinf.minL;
LABnorm1(:,:,2) = ones(h,w) * clinf.minA;
LABnorm1(:,:,3) = ones(h,w) * clinf.minB;
LABnorm2 = ones(h,w,3);
LABnorm2(:,:,2) = ones(h,w) / (clinf.maxL-clinf.minL) *256;
LABnorm2(:,:,2) = ones(h,w) / (clinf.maxA-clinf.minA) *nbins;
LABnorm2(:,:,3) = ones(h,w) / (clinf.maxB-clinf.minB) *nbins;
maxdist = 0;



geo_hist_bin = 20;
L_hist={inp.numi};A_hist={inp.numi};
B_hist={inp.numi};geo_hist={inp.numi};


