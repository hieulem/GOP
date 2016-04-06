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
<<<<<<< HEAD
    flowpath = '../../flow_data/flow_motion_default/Segtrack';
=======
    flowpath = '../../flow_motion_default/segtrack';
>>>>>>> 12268fb619a62d8886986a33411d4335f77c758c
    flowfile = ['flow',video_name];
    path  = ['../../video/Seg/JPEGImages/' video_name '/'];
    aff = wrapperforCP( labels,flowpath,flowfile,path );
  %  save(['aff_gh_',video_name],'aff');
end
