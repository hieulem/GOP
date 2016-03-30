function [ rgbhistogram ] = rgb_histogram( image,sp,seed )
%COLOR_HIST Summary of this function goes here
%   Detailed explanation goes here

%Split into RGB Channels

    Red = image(:,:,1);
    Red = Red(sp ==seed);
    Green = image(:,:,2);
    Green = Green(sp ==seed);
    Blue = image(:,:,3);
    Blue = Blue(sp ==seed);
    %Get histValues for each channel
  %  rgbmean = mean([Red,Green,Blue],1)/100;
    R=histcounts(Red,0:10:255);
    G=histcounts(Green,0:10:255);
    B=histcounts(Blue,0:10:255);
    rgbhistogram = [R,G,B];
end

