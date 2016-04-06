profile on;
close all;
tic
clear
addpath(genpath('../outsource/toolbox-master'));
addpath(genpath('../outsource/spDetect'));


allnum =[]
% video_name = 'v_Basketball_g01_c01.avi';
% input.path = 'v_Basketball_g01_c01.avi/';
% video_name = 'v_IceDancing_g01_c01.avi';
% input.path = 'v_IceDancing_g01_c01.avi/';
%                                           1               2                 3                4
%                                           
video_name_array = {'birdfall';'cheetah';'monkeydog';'girl';'penguin';'parachute';'bmx';'drift';'hummingbird';'monkey';
    'soldier';'bird_of_paradise';'frog';'worm';};
%input.numi=2;

for j=1:1
    
    video_name = video_name_array{j};
    inp.path  = ['../video/Seg/JPEGImages/' video_name '/'];
    gtpath = ['../video/Seg/GroundTruth/' video_name '/'];
    loadoption;
    model=load('models/forest/modelBsds'); 
    model=model.model;
    model.opts.nms=0; model.opts.nThreads=4;
    model.opts.multiscale=1; model.opts.sharpen=0;
    load(fullfile('..','flow_data','flow_motion_1_0_0','segtrack',['flow',video_name]));
   % model.opts.nTreesEval=4; 
    parfor ii=1:inp.numi
        ii
        %   iii = input.numi+1-ii;
        % if ii==2 iii=5;end;
        filename = [inp.path,inp.imglist(ii).name];
        I(:,:,:,ii) = imread(filename);
      %  I(:,:,:,ii) = imresize(imread(filename),[240,NaN]);
        [E,~,~,segs]=edgesDetect(I(:,:,:,ii),model);
        E(E<0) = 0;
        E= E/(max(max(E)));
        E=E+1e-20;
        E3(:,:,ii) = E;
 %       E2(:,:,ii) = E + motionboundaries(:,:,ii);
    end;
    
end;

for i=1:inp.numi-1
    E2(:,:,i+1) = imwarp(E3(:,:,i),flow(:,:,1,i),flow(:,:,2,i));
end

E2(:,:,1) = E2(:,:,2);


M =playMovie([E2,E3,E3+E2,],1,-3,struct('hasChn',false));
% M =playMovie([boundaries_ColorFlow],1,-3,struct('hasChn',false));
% [optimizer,metric] = imregconfig('Multimodal');
% close all
% fixed = boundaries_ColorFlow(:,:,5);
% moving = boundaries_ColorFlow(:,:,6);
% figure;imshowpair(fixed,moving);
% regist = imregister(moving,fixed,'rigid',optimizer,metric);
% %figure; imshowpair(regist,moving);
% figure;imshowpair(regist,fixed);
% 
