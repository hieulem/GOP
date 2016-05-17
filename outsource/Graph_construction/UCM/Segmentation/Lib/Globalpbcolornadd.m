function [gPb_orient, gPb_thin, textons] = Globalpbcolornadd(imgFile, colorFile, outFile, rsz, count, saveworkimages, printthetextonscreen)
% syntax:
%   [gPb_orient, gPb_thin, textons] = globalPb(imgFile, outFile, rsz)
%
% description:
%   compute Globalized Probability of Boundary of a color image.
%
% arguments:
%   imgFile : jpg format
%   outFile:  mat format (optional)
%   rsz:      resizing factor in (0,1], to speed-up eigenvector computation
%
% outputs (uint8):
%   gPb_orient: oriented lobalized probability of boundary.
%   gPb_thin:  thinned contour image.
%   textons
%
% Pablo Arbelaez <arbelaez@eecs.berkeley.edu>
% April 2008

%The function is called by Getthesegmentswithcolor.m

if ( (~exist('printthetextonscreen','var')) || (isempty(printthetextonscreen)) )
    printthetextonscreen=false;
end
if ( (~exist('saveworkimages','var')) || (isempty(saveworkimages)) )
    saveworkimages=false;
end
if ( (~exist('rsz','var')) || (isempty(rsz)) )
    rsz=1.0;
end
if ( (~exist('outFile','var')) || (isempty(outFile)) )
    outFile='';
end

if ((rsz<=0) || (rsz>1)),
    error('resizing factor rsz out of range (0,1]');
end

total_time = 0;
tic;

im = double(imread(imgFile)) / 255;
[tx, ty, nchan] = size(im);
orig_sz = [tx, ty];

imcolor = double(imread(colorFile)) / 255;
% [tx, ty, nchan] = size(imcolor);
%Flow coor images have the same size as images and nchan=3 with information from flow in a and b channels

% default feature weights
if nchan == 3,
    weights = [ 0   0    0.0028    0.0041    0.0042    0.0047    0.0033    0.0033    0.0035    0.0025    0.0025    0.0137    0.0139];
else
    weights = [ 0   0    0.0054         0         0         0         0         0         0    0.0048    0.0049    0.0264    0.0090];
end
% [bg1 bg2 bg3 cga1 cga2 cga3 cgb1 cgb2 cgb3 tg1 tg2 tg3 sPb]

%New weights for gradients of the color flow image
% weights = [weights, 0.0025, 0.0025, 0.0028]; %gPb in the experiments
% weights = [weights, 0.001, 0.001, 0.001]; %g1Pb in the experiments
% weights = [weights, 0.0018,    0.0018,    0.0020]; %g7Pb in the experiments
% weights = [weights, 0.0015,    0.0015,    0.0016]; %g6Pb in the experiments
% weights = [weights, 0.0037,    0.0037,    0.0041]; %g5Pb*2 in the experiments
weights = [weights, 0.0019,    0.0019,    0.0021]; %g5Pb in the experiments
% weights = [weights, 0.0018, 0.0018, 0.0019]; %g2Pb and g4Pb in the experiments
% weights = [weights, 0.0035, 0.0035, 0.0038]; % [0.0037    0.0037    0.0041]
% [bg1 bg2 bg3 cga1 cga2 cga3 cgb1 cgb2 cgb3 tg1 tg2 tg3 sPb cga1c cga2c cga3c cgb1c cgb2c cgb3c]

%% mPb with color flow image
[mPb, mPb_rsz, bg1, bg2, bg3, cga1, cga2, cga3, cgb1, cgb2, cgb3, tg1, tg2, tg3, textons, fg1, fg2, fg3] = ...
    Multiscalepbcolornadd(im, imcolor, rsz, printthetextonscreen);
t = toc;
total_time = total_time + t;

%% sPb
tic;
outFile2 = strcat(outFile, '_pbs.mat');

%%%This adds principled video boundaries
usevideocues=false;
if (usevideocues)
    filewithcues='videoboundaries.mat';
    if (exist(filewithcues,'file'))
        load(filewithcues);
        pmean=mean(mPb_rsz(:));
        pvar=var(mPb_rsz(:));
        weightmpb=0.5;
        weightbds=0.5;
        mPb_rsz=( weightmpb*Submeandivbyvar(mPb_rsz)+weightbds*Submeandivbyvar(boundaries(:,:,count)) )*pvar+pmean;
    end
end
%%%%%%

nvec = 17;
[sPb] = spectralPb(mPb_rsz, orig_sz, outFile2, nvec, printthetextonscreen);
delete(outFile2);
t = toc;
if (printthetextonscreen)
    fprintf('Spectral Pb:%g\n', t);
end
total_time = total_time + t;

%% gPb
tic;
gPb_orient = zeros(size(tg1));
for o = 1 : size(gPb_orient, 3),
    l1 = weights(1)*bg1(:, :, o);
    l2 = weights(2)*bg2(:, :, o);
    l3 = weights(3)*bg3(:, :, o);

    a1 = weights(4)*cga1(:, :, o);
    a2 = weights(5)*cga2(:, :, o);
    a3 = weights(6)*cga3(:, :, o);

    b1 = weights(7)*cgb1(:, :, o);
    b2 = weights(8)*cgb2(:, :, o);
    b3 = weights(9)*cgb3(:, :, o);

    t1 = weights(10)*tg1(:, :, o);
    t2 = weights(11)*tg2(:, :, o);
    t3 = weights(12)*tg3(:, :, o);

    sc = weights(13)*sPb(:, :, o);

    f1 = weights(14)*fg1(:, :, o);
    f2 = weights(15)*fg2(:, :, o);
    f3 = weights(16)*fg3(:, :, o);

    gPb_orient(:, :, o) = l1 + a1 + b1 + t1 + l2 + a2 + b2 + t2 + l3 + a3 + b3 + t3 + sc + f1 + f2 + f3;
end

%% outputs
gPb = max(gPb_orient, [], 3);

gPb_thin = gPb .* (mPb>0.05);
gPb_thin = gPb_thin .* bwmorph(gPb_thin, 'skel', inf);

gPb_thin = Normalise_gpb_orient(gPb_thin);
for o = 1 : 8,
    gPb_orient(:, :, o) = Normalise_gpb_orient(gPb_orient(:, :, o));
end

gPb_thin = uint8(255*gPb_thin);
gPb_orient=uint8(255*gPb_orient);
textons=uint8(textons);

if ~strcmp(outFile,''), save(outFile,'gPb_thin', 'gPb_orient','textons'); end

t=toc;
total_time = total_time + t;
fprintf('Total Time for Global Pb:%g s.\n', total_time);



%% print mPb, sPb and gPb
if (saveworkimages)
    [p,n,e]=fileparts(outFile);
    
    mPboutfile=[p,filesep,n,'_mpb','.jpg'];
    mPb_max_alldirs=max(mPb,[],3);
    imwrite(mPb_max_alldirs, mPboutfile);

    sPboutfile=[p,filesep,n,'_spb','.jpg'];
    sPb_max_alldirs=max(sPb,[],3);
    imwrite(sPb_max_alldirs, sPboutfile);
    
    gPboutfile=[p,filesep,n,'_gpb','.jpg'];
    imwrite(gPb, gPboutfile);
end

%% print FG
saveworkflow=false;
if (saveworkflow)
    [p,n,e]=fileparts(outFile);
    
    fg1outfile=[p,filesep,n,'_fg1','.jpg'];
    fg1_max_alldirs=max(fg1,[],3);
    imwrite(fg1_max_alldirs, fg1outfile);
    
    fg2outfile=[p,filesep,n,'_fg2','.jpg'];
    fg2_max_alldirs=max(fg2,[],3);
    imwrite(fg2_max_alldirs, fg2outfile);
    
    fg3outfile=[p,filesep,n,'_fg3','.jpg'];
    fg3_max_alldirs=max(fg3,[],3);
    imwrite(fg3_max_alldirs, fg3outfile);
    
    fgaoutfile=[p,filesep,n,'_fga','.jpg'];
    fga_max_alldirs=sum(cat(3,fg1_max_alldirs,fg2_max_alldirs,fg3_max_alldirs),3);
    imwrite(fga_max_alldirs, fgaoutfile);
end
