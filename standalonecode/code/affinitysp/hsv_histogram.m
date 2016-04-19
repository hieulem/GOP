function [ H,S,V ] = hsv_histogram( image,sp,seed)
%COLOR_HIST Summary of this function goes here
%   Detailed explanation goes here

h = image(:,:,1);
h = h(sp ==seed);
s = image(:,:,2);
s = s(sp ==seed);
v = image(:,:,3);
v = v(sp ==seed);
%Get histValues for each channel
%  rgbmean = mean([Red,Green,Blue],1)/100;
tmp = 1/180;
H=histcounts(h,0:tmp:1);
H = H/sum(H);
tmp = 1/20;
S=histcounts(s,0:tmp:1);
S = S/sum(S);

V= histcounts(v,0:tmp:1);
V= V/sum(V);
%  rgbhistogram = [R,G,B];

end

