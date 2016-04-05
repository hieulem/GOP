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
    load(fullfile('flow_motion',['flow',video_name]));
    model.opts.nTreesEval=4; 
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



 M =playMovie([motionboundaries,E3,motionboundaries+E3,],1,-3,struct('hasChn',false));
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
