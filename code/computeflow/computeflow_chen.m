% clear;
% addpath(genpath('.'));
% addpath(genpath('../outsource/'));
% %addpath(genpath('../outsource/spDetect'));
% dataset_path = '../../video/chen/input/PNG/';
% all_path= dir(dataset_path);all_path(1:2) = [];
% for i=1:length(all_path)
%     video_info{i}.path = [dataset_path,all_path(i).name];
%     video_info{i}.name = all_path(i).name;
% end
% save('video_info_chen','video_info');
function [] = computeflow_chen(i)
load('video_info_chen');
addpath(genpath('../../outsource/flow_code_v2'));
addpath(genpath('../../outsource/toolbox-master'));
addpath(genpath('../../outsource/MotionBoundariesCode_v1.0'));
%i=1;
video_name = video_info{i}.name
flowpath = ['../../flow_data/flow_motion_default/chen/'];
flowfile = ['flow',video_name];
video_path = video_info{i}.path;
a=pwd;cd(video_path);imlist = dir('*.png');
tmp = imread(imlist(1).name);
img = zeros(size(tmp,1),size(tmp,2),3,length(imlist));
for j=1:length(imlist)
    img(:,:,:,j) = imread(imlist(j).name);
end
cd(a);
[motionboundaries,~] = computeflowandmotionb( img,flowpath,flowfile );

end
