close all;
tic
clear;
addpath(genpath('.'));
addpath(genpath('../outsource/'));
%addpath(genpath('../outsource/spDetect'));

video_name_array = {'birdfall';'cheetah';'monkeydog';'girl';'penguin';'parachute';'bmx';'drift';'hummingbird';'monkey';
    'soldier';'bird_of_paradise';'frog';'worm';};
for i=1:14
    video_name = video_name_array{i};
    spfile = ['../../SP_data/SPofCP/SP/',video_name,'/ers_300'];
    load(spfile,'labels');
    flowpath = '../../flow_motion_default/segtrack';
    flowfile = ['flow',video_name];
    path  = ['../../video/Seg/JPEGImages/' video_name '/'];
    aff = wrapperforCP( labels,flowpath,flowfile,path );
  %  save(['aff_gh_',video_name],'aff');
end
