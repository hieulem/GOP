function [ motionboundaries,flow ] = computeflowandmotionb( img,savepath,filename )
%COMPUTEFLOWANDMOTIONB Summary of this function goes here
%   Detailed explanation goes here
if ~exist(savepath)
    mkdir(savepath)
end;
if exist(fullfile(savepath,[filename,'.mat']))
    load(fullfile(savepath,filename));
else
    [h,w,~,numi] = size(img);
    flow = zeros(h,w,2,numi);
    motionboundaries =zeros(h,w,numi);
    parfor i =1:numi-1
        i;
        flow(:,:,:,i)= estimate_flow_interface(img(:,:,:,i), img(:,:,:,i+1), 'classic+nl-fast');
        motionboundaries(:,:,i)= detect_motionboundaries(img(:,:,:,i),flow(:,:,:,i),img(:,:,:,i+1),[],[],1,0,0);
    end
    
    flow(:,:,:,numi) = estimate_flow_interface(img(:,:,:,numi), img(:,:,:,numi-1), 'classic+nl-fast');
    motionboundaries(:,:,numi) = detect_motionboundaries(img(:,:,:,numi),[],[],flow(:,:,:,numi),img(:,:,:,numi-1),1,0,0);
    
    save(fullfile(savepath,filename),'flow','motionboundaries');
end



