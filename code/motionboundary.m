addpath(genpath('../outsource/MotionBoundariesCode_v1.0'));
addpath(genpath('../outsource/toolbox-master'));
%addpath(genpath('../outsource/spDetect'));
addpath(genpath('../outsource/flow_code_v2'));

video_name_array = {'birdfall';'cheetah';'monkeydog';'girl';'penguin';'parachute';'bmx';'drift';'hummingbird';'monkey';
    'soldier';'bird_of_paradise';'frog';'worm';};
%inp.numi=2;

for j=6:6
    video_name = video_name_array{j};
    inp.path  = ['../video/Seg/JPEGImages/' video_name '/'];
    gtpath = ['../video/Seg/GroundTruth/' video_name '/'];
    inp.imglist = dir(inp.path);inp.imglist(1:2) =[];
    inp.numi = size(inp.imglist,1);
    filename = [inp.path,inp.imglist(1).name];
    t = imresize(imread(filename),[240,NaN]);
    %t= imread(filename);
    h= size(t,1);w= size(t,2);

    flow = zeros(h,w,2,inp.numi);
    boundaries_ColorFlow =zeros(h,w,inp.numi);
    for ii=1:inp.numi
        ii
        filename = [inp.path,inp.imglist(ii).name];
        I(:,:,:,ii) = imresize(imread(filename),[240,NaN]);
    end;
    
    parfor i =1:inp.numi-1
        flow(:,:,:,i)= estimate_flow_interface(I(:,:,:,i), I(:,:,:,i+1), 'classic+nl-fast');
        boundaries_ColorFlow(:,:,i)= detect_motionboundaries(I(:,:,:,i), flow(:,:,:,i),I(:,:,:,i+1));
    end
    
    flow(:,:,:,inp.numi) = estimate_flow_interface(I(:,:,:,inp.numi), I(:,:,:,inp.numi-1), 'classic+nl-fast');
    boundaries_ColorFlow(:,:,inp.numi) = detect_motionboundaries(I(:,:,:,inp.numi),flow(:,:,:,inp.numi));
    
    save(['flow',video_name]);
end;

