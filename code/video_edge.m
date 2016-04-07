profile on;
close all;
tic
clear;
addpath(genpath('../outsource/toolbox-master'));
addpath(genpath('../outsource/spDetect'));


allnum =[]
% video_name = 'v_Basketball_g01_c01.avi';
% input.path = 'v_Basketball_g01_c01.avi/';
% video_name = 'v_IceDancing_g01_c01.avi';
% input.path = 'v_IceDancing_g01_c01.avi/';
video_name_array = {'birdfall';'cheetah';'monkeydog';'girl';'penguin';'parachute';'bmx';'drift';'hummingbird';'monkey';
    'soldier';'bird_of_paradise';'frog';'worm';};
%input.numi=2;

for j=6:6
    
    video_name = video_name_array{j};
    input.path  = ['../video/SEG/JPEGImages/' video_name '/'];
    gtpath = ['../video/SEG/GroundTruth/' video_name '/'];
    
    loadoption;
    model.opts.nTreesEval=4; 
    for ii=1:input.numi
        ii
        %   iii = input.numi+1-ii;
        % if ii==2 iii=5;end;
        filename = [input.path,input.imglist(ii).name];
        % I(:,:,:,ii) = imread(filename);
        I(:,:,:,ii) = imresize(imread(filename),[240,NaN]);
        [E(:,:,ii),~,~,segs]=edgesDetect(I(:,:,:,ii),model);
         [Gx, Gy] = imgradientxy(rgb2gray(I(:,:,:,ii)));
        [E2(:,:,ii), Gdir] = imgradient(Gx, Gy);
    end;
    
end;
M =playMovie(E,5,1,struct('hasChn',false));

