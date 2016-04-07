clear;

nseeds =15;
video_name_array = {'birdfall';'cheetah';'monkeydog';'girl';'penguin';'parachute';'bmx';'drift';'hummingbird';'monkey';
    'soldier';'bird_of_paradise';'frog';'worm';
};
numsp = 400;
for j = 1:1
video_name = video_name_array{j};
%load(['./CPres/', int2str(numsp), '/',video_name, '.mat']);

input.path  = ['../video/SEG/JPEGImages/' video_name '/'];
video_name = 'v_IceDancing_g01_c01.avi';
input.path = 'v_IceDancing_g01_c01.avi/';
input.imglist = dir(input.path);input.imglist(1:2) =[];
input.numi = size(input.imglist,1);
for ii =1:input.numi
    filename = [input.path,input.imglist(ii).name];
    figure(3); image(imread(filename));
    Image2seeds;
   % pause();
end;
end