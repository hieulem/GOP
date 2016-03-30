profile on;
close all;
tic
clear;
addpath(genpath('.'));
addpath(genpath('../outsource/toolbox-master'));
addpath(genpath('../outsource/gop_1.3'));
addpath(genpath('../outsource/spDetect'));


allnum =[]
% video_name = 'v_Basketball_g01_c01.avi';
% inp.path = 'v_Basketball_g01_c01.avi/';
% video_name = 'v_IceDancing_g01_c01.avi';
% inp.path = 'v_IceDancing_g01_c01.avi/';
video_name_array = {'birdfall';'cheetah';'monkeydog';'girl';'penguin';'parachute';'bmx';'drift';'hummingbird';'monkey';
    'soldier';'bird_of_paradise';'frog';'worm';};
%inp.numi=2;

for j=1:1
    video_name = video_name_array{j};
    load(['flow', video_name]);
    inp.path  = ['../video/Seg/JPEGImages/' video_name '/'];
    gtpath = ['../video/Seg/GroundTruth/' video_name '/'];
    
    loadoption;
    maxdist =0;
    sp=zeros(h,w,inp.numi);
    geo_hist=cell(inp.numi,1);
    seeds_color=cell(inp.numi,1);
    seeds=cell(inp.numi,1);
    area=cell(inp.numi,1);
    pos_dist =cell(inp.numi,1);
    pos =cell(inp.numi,1);
    oriedges =cell(inp.numi,1);
    graph = cell(inp.numi,1);
    L_hist = cell(inp.numi,1);
    A_hist= cell(inp.numi,1);
    B_hist= cell(inp.numi,1);
    H_hist = cell(inp.numi,1);
    S_hist = cell(inp.numi,1);
    V_hist =cell(inp.numi,1);
    seeds_geo =cell(inp.numi,1);
    I = uint8(zeros(h,w,3,inp.numi));
    edge = single(zeros(h,w,inp.numi));
    geo_hist2d = cell(inp.numi,1);
    for ii=1:inp.numi
        ii
        filename = [inp.path,inp.imglist(ii).name];
        
        I(:,:,:,ii) = imresize(imread(filename),[240,NaN]);
    %    os = OverSegmentation( I(:,:,:,ii) );
   %     ed2 = os.boundaryMap;
        [ed,~,~,segs]=edgesDetect(I(:,:,:,ii),model);
        if ii>1
            model.opts.seed = uint32(sp(:,:,ii-1));
        end
        [sp(:,:,ii),~] = spDetect(I(:,:,:,ii),ed,opts);
      %  ed= ed/(max(max(ed)));
        boundaries_ColorFlow(:,:,ii) = boundaries_ColorFlow(:,:,ii) /max(max(boundaries_ColorFlow(:,:,ii)));
        ed = ed +  boundaries_ColorFlow(:,:,ii);
        
        % ed= ed/(max(max(ed)));
 
        [sp(:,:,ii),~] = spDetect(I(:,:,:,ii),ed,opts);
        ed=boundaries_ColorFlow(:,:,ii);
        
        sp(:,:,ii)=sp(:,:,ii)+1;
        
       
        model.opts.nms=0;model.opts.sharpen=0;model.opts.multiscale=0;
        [ed2,~,~,segs]=edgesDetect(I(:,:,:,ii),model);
        model.opts.nms=1;model.opts.sharpen=2;model.opts.multiscale=1;
        ed = ed + ed2 + 1e-20;
        
        edge(:,:,ii)=ed;
        Z = spAffinities_vu(sp(:,:,ii),ed);
        Z(Z<0) =0 ;Z = sparse(double(Z));
        %     graph{ii} =Z;
        
        nsp = max(max(sp(:,:,ii)));
        for k =1:nsp
            area{ii}(k) = sum(sum(sp(:,:,ii) == k))/(h*w);
        end
        sp_c = sp_c + nsp;
        splist(ii) = nsp;
        
        psp = splist(ii)+1;
        tic;
        seeds{ii}(:) = 1:nsp;
        L_hist{ii} = zeros(nsp,nbins);
        A_hist{ii} = zeros(nsp,nbins);
        B_hist{ii} = zeros(nsp,nbins);
        
        geo_hist{ii} = zeros(nsp,geo_hist_bin);
        itsimage =rgb2gray(I(:,:,:,ii));
        hsvimage = rgb2hsv(I(:,:,:,ii));
        labimage = rgb2lab(I(:,:,:,ii));
        labimage = (labimage-LABnorm1).*LABnorm2;
        
        
        for i=1:length(seeds{ii})
            seeds_geo{ii}(i,:) = geocompute(Z,seeds{ii}(i));
            seeds_color{ii}(i,:) = rgb_mean(itsimage,sp(:,:,ii),i);
            [L_hist{ii}(i,:),A_hist{ii}(i,:),B_hist{ii}(i,:)] = lab_histogram(labimage,sp(:,:,ii),i);
            [H_hist{ii}(i,:),S_hist{ii}(i,:),V_hist{ii}(i,:)] = hsv_histogram(hsvimage,sp(:,:,ii),i);
            pos{ii}(i,:) = computesppos(sp(:,:,ii),i);
        end;
        tic;
         gaussiandis = pdist2(pos{ii},pos{ii},'euclidean');  gaussiandis = exp(-0.002*gaussiandis);
        for i=1:length(seeds{ii})
           
            geo_hist{ii}(i,:)=histwc(seeds_geo{ii}(i,:),area{ii}.*gaussiandis(i,:),geo_hist_bin,max(max(seeds_geo{ii})));
            geo_hist2d{ii}(i,:,:)=histwc2D(seeds_geo{ii}(i,:),seeds_color{ii},area{ii}.*gaussiandis(i,:),9,13,5,255);
        end
        
        toc;
        maxdist = max(maxdist,max(max(seeds_geo{ii})));
        
    end;
    tic;
    %     for ii=1:inp.numi
    %         for i =1:length(seeds{ii})
    %             geo_hist{ii}(i,:)=histwc(seeds_geo{ii}(i,:),area{ii},geo_hist_bin,maxdist);
    %             %geo_hist2d{ii}(i,:,:)=histwc(seeds_geo{ii}(i,:),seeds_color{ii},area{ii},geo_hist_bin,maxdist);
    %         end;
    %
    %     end;
    toc;
    save([video_name]);
end;
%onefr
%CRFonefr


