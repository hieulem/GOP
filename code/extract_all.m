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

for j=1:14
    video_name = video_name_array{j};
    input.path  = ['../video/Seg/JPEGImages/' video_name '/'];
    gtpath = ['../video/Seg/GroundTruth/' video_name '/'];
    
    loadoption;
    maxdist =0;
    I = uint8(zeros(h,w,3,input.numi));
    sp=zeros(h,w,input.numi);
    geo_hist=cell(input.numi,1);
    seeds_color=cell(input.numi,1);
    seeds=cell(input.numi,1);
    area=cell(input.numi,1);
    pos_dist =cell(input.numi,1);
    pos =cell(input.numi,1);
    oriedges =cell(input.numi,1);
    graph = cell(input.numi,1);
    L_hist = cell(input.numi,1);
    A_hist= cell(input.numi,1);
    B_hist= cell(input.numi,1);
    H_hist = cell(input.numi,1);
    S_hist = cell(input.numi,1);
    V_hist =cell(input.numi,1);
    seeds_geo =cell(input.numi,1);
    parfor ii=1:input.numi
        ii
        filename = [input.path,input.imglist(ii).name];
        
        I(:,:,:,ii) = imresize(imread(filename),[240,NaN]);
        [E,~,~,segs]=edgesDetect(I(:,:,:,ii),model);
        E(E<0) = 0;
        [sp(:,:,ii),~] = spDetect(I(:,:,:,ii),E,opts);
        
        sp(:,:,ii)=sp(:,:,ii)+1;
        nsp = max(max(sp(:,:,ii)));
        for k =1:nsp
            area{ii}(k) = sum(sum(sp(:,:,ii) == k))/(h*w);
        end
        sp_c = sp_c + nsp;
        splist(ii) = nsp;
        Z = spAffinities_vu(sp(:,:,ii),E);
        Z(Z<0) =0 ;Z = sparse(double(Z));
        %     graph{ii} =Z;
        psp = splist(ii)+1;
        tic;
        seeds{ii}(:) = 1:nsp;
        L_hist{ii} = zeros(nsp,nbins);
        A_hist{ii} = zeros(nsp,nbins);
        B_hist{ii} = zeros(nsp,nbins);
        
        geo_hist{ii} = zeros(nsp,geo_hist_bin);
        tic;
        hsvimage = rgb2hsv(I(:,:,:,ii));
        labimage = rgb2lab(I(:,:,:,ii));
        labimage = (labimage-LABnorm1).*LABnorm2;
        
        
        for i=1:length(seeds{ii})
            seeds_geo{ii}(i,:) = geocompute(Z,seeds{ii}(i));
            seeds_color{ii}(i,:) = rgb_mean(I(:,:,:,ii),sp(:,:,ii),i);
            
            [L_hist{ii}(i,:),A_hist{ii}(i,:),B_hist{ii}(i,:)] = ...
                lab_histogram(labimage,sp(:,:,ii),i);
            [H_hist{ii}(i,:),S_hist{ii}(i,:),V_hist{ii}(i,:)] = ...
                hsv_histogram(hsvimage,sp(:,:,ii),i);
            pos{ii}(i,:) = computesppos(sp(:,:,ii),i);
        end;
        toc;
        maxdist = max(maxdist,max(max(seeds_geo{ii})));
        
    end;
    tic;
    for ii=1:input.numi
        for i =1:length(seeds{ii})
            geo_hist{ii}(i,:)=histwc(seeds_geo{ii}(i,:),area{ii},geo_hist_bin,maxdist);
            %geo_hist2d{ii}(i,:,:)=histwc(seeds_geo{ii}(i,:),seeds_color{ii},area{ii},geo_hist_bin,maxdist);
        end;
        
    end;
    toc;
    save([video_name]);
end;


