function [mPb_nmax, mPb_nmax_rsz, bg1, bg2, bg3, cga1, cga2, cga3, cgb1, cgb2, cgb3, tg1, tg2, tg3, textons,...
    cga1c, cga2c, cga3c, cgb1c, cgb2c, cgb3c] = Multiscalepbcolor(im, imcolor, rsz, printthetextonscreen)
%
% description:
% compute local contour cues of an image.
%
% gradients by Michael Maire <mmaire@eecs.berkeley.edu>
%
% Pablo Arbelaez <arbelaez@eecs.berkeley.edu>
% April 2008

if ( (~exist('printthetextonscreen','var')) || (isempty(printthetextonscreen)) )
    printthetextonscreen=false;
end
if ( (~exist('rsz','var')) || (isempty(rsz)) )
    rsz=0.5;
end

% default feature weights
if size(im,3) == 3,
    weights = [0.0123    0.0110    0.0117    0.0169    0.0176    0.0198    0.0138    0.0138    0.0145    0.0104    0.0105    0.0115];
else
    im(:,:,2)=im(:,:,1);im(:,:,3)=im(:,:,1);
    weights = [0.0245    0.0220    0.0233         0         0         0         0         0         0    0.0208    0.0210    0.0229];
end
% [bg1 bg2 bg3 cga1 cga2 cga3 cgb1 cgb2 cgb3 tg1 tg2 tg3]

%New weights for gradients of the color flow image
% weights = [weights, 0.0105, 0.0105, 0.011, 0.0105, 0.0105, 0.011]; %mPb in the experiments
% weights = [weights, 0.0050, 0.0050, 0.0055, 0.0050, 0.0050, 0.0055]; %m3Pb in the experiments
% weights = [weights, 0.0040, 0.0040, 0.004, 0.0040, 0.0040, 0.0040]; %m2Pb in the experiments
% weights = [weights, 0.0045, 0.0045, 0.005, 0.0045, 0.0045, 0.005]; %m1Pb in the experiments
weights = [weights, 0.0145, 0.0145, 0.015, 0.0145, 0.0145, 0.015];
% [bg1 bg2 bg3 cga1 cga2 cga3 cgb1 cgb2 cgb3 tg1 tg2 tg3 cga1c cga2c cga3c cgb1c cgb2c cgb3c]

% get gradients
tic;
[bg1, bg2, bg3, cga1, cga2, cga3, cgb1, cgb2, cgb3, tg1, tg2, tg3, textons] = det_mPb(im);
if (printthetextonscreen)
    fprintf('Local cues:%g\n', toc);
end

%Gradients from the color flow
[bg1c, bg2c, bg3c, cga1c, cga2c, cga3c, cgb1c, cgb2c, cgb3c, tg1c, tg2c, tg3c, textonsc] = det_mPb(imcolor);
if (printthetextonscreen)
    fprintf('Local cues from color flow:%g\n', toc);
end

% smooth cues
tic;
gtheta = [1.5708    1.1781    0.7854    0.3927   0    2.7489    2.3562    1.9635];
for o = 1 : size(tg1, 3),
    bg1(:,:,o) = fitparab(bg1(:,:,o),3,3/4,gtheta(o));
    bg2(:,:,o) = fitparab(bg2(:,:,o),5,5/4,gtheta(o));
    bg3(:,:,o) = fitparab(bg3(:,:,o),10,10/4,gtheta(o));

    cga1(:,:,o) = fitparab(cga1(:,:,o),5,5/4,gtheta(o));
    cga2(:,:,o) = fitparab(cga2(:,:,o),10,10/4,gtheta(o));
    cga3(:,:,o) = fitparab(cga3(:,:,o),20,20/4,gtheta(o));

    cgb1(:,:,o) = fitparab(cgb1(:,:,o),5,5/4,gtheta(o));
    cgb2(:,:,o) = fitparab(cgb2(:,:,o),10,10/4,gtheta(o));
    cgb3(:,:,o) = fitparab(cgb3(:,:,o),20,20/4,gtheta(o));

    tg1(:,:,o) = fitparab(tg1(:,:,o),5,5/4,gtheta(o));
    tg2(:,:,o) = fitparab(tg2(:,:,o),10,10/4,gtheta(o));
    tg3(:,:,o) = fitparab(tg3(:,:,o),20,20/4,gtheta(o));

end
%Color flow image
for o = 1 : size(tg1, 3),
    cga1c(:,:,o) = fitparab(cga1c(:,:,o),5,5/4,gtheta(o));
    cga2c(:,:,o) = fitparab(cga2c(:,:,o),10,10/4,gtheta(o));
    cga3c(:,:,o) = fitparab(cga3c(:,:,o),20,20/4,gtheta(o));

    cgb1c(:,:,o) = fitparab(cgb1c(:,:,o),5,5/4,gtheta(o));
    cgb2c(:,:,o) = fitparab(cgb2c(:,:,o),10,10/4,gtheta(o));
    cgb3c(:,:,o) = fitparab(cgb3c(:,:,o),20,20/4,gtheta(o));
end

if (printthetextonscreen)
    fprintf('Cues smoothing:%g\n', toc);
end


% compute mPb at full scale
mPb_all = zeros(size(tg1));
for o = 1 : size(mPb_all, 3),
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

    a1c = weights(13)*cga1c(:, :, o);
    a2c = weights(14)*cga2c(:, :, o);
    a3c = weights(15)*cga3c(:, :, o);

    b1c = weights(16)*cgb1c(:, :, o);
    b2c = weights(17)*cgb2c(:, :, o);
    b3c = weights(18)*cgb3c(:, :, o);

    mPb_all(:, :, o) = l1 + a1 + b1 + t1 + l2 + a2 + b2 + t2 + l3 + a3 + b3 + t3 +...
        a1c + b1c + a2c + b2c + a3c + b3c;

end

% non-maximum suppression
mPb_nmax = nonmax_channels(mPb_all);
mPb_nmax = max(0, min(1, 1.2*mPb_nmax));


% compute mPb_nmax resized if necessary
if rsz < 1,
    mPb_all = imresize(tg1, rsz);
    mPb_all(:) = 0;

    for o = 1 : size(mPb_all, 3),
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

        a1c = weights(13)*cga1c(:, :, o);
        a2c = weights(14)*cga2c(:, :, o);
        a3c = weights(15)*cga3c(:, :, o);

        b1c = weights(16)*cgb1c(:, :, o);
        b2c = weights(17)*cgb2c(:, :, o);
        b3c = weights(18)*cgb3c(:, :, o);

        mPb_all(:, :, o) = imresize(l1 + a1 + b1 + t1 + l2 + a2 + b2 + t2 + l3 + a3 + b3 + t3 + a1c + b1c + a2c + b2c + a3c + b3c, rsz);

    end

    mPb_nmax_rsz = nonmax_channels(mPb_all);
    mPb_nmax_rsz = max(0, min(1, 1.2*mPb_nmax_rsz));
else
    mPb_nmax_rsz = mPb_nmax;
end

