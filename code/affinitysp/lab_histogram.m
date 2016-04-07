function [ L,A,B ] = lab_histogram( image,sp,seed)
%COLOR_HIST Summary of this function goes here
%   Detailed explanation goes here

l = image(:,:,1);
l = l(sp ==seed);
a = image(:,:,2);
a = a(sp ==seed);
b = image(:,:,3);
b = b(sp ==seed);
%Get histValues for each channel
%  rgbmean = mean([Red,Green,Blue],1)/100;
L=histcounts(l,0:20);

L = L/sum(L);
A=histcounts(a,0:20);
A = A/sum(A);

B= histcounts(b,0:20);
B= B/sum(B);
%  rgbhistogram = [R,G,B];

end

