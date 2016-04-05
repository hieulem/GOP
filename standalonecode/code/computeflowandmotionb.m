function [ motionboundaries,flow ] = computeflowandmotionb( img,savepath,filename )
%COMPUTEFLOWANDMOTIONB Summary of this function goes here
%   Detailed explanation goes here
if ~exist(savepath)
    mkdir(savepath)
end;
if exist(fullfile(savepath,filename))
    load(fullfile(savepath,filename));
else
    
    [h,w,~,numi] = size(img);
    img(:,:,:,numi+1) =  img(:,:,:,numi-1);
    flow = zeros(h,w,2,numi);
    motionboundaries =zeros(h,w,numi);
    
    parfor i =1:numi
        i
        flow(:,:,:,i)= estimate_flow_interface(img(:,:,:,i), img(:,:,:,i+1), 'classic+nl-fast');
        motionboundaries(:,:,i)= detect_motionboundaries(img(:,:,:,i),flow(:,:,:,i),img(:,:,:,i+1));
    end 
    save(fullfile(savepath,filename),'flow','motionboundaries');
end



