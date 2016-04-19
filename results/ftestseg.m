function []=  ftestset(id)
addpath(genpath('../code/eval_code'));
names ={'bird_of_paradise','birdfall','bmx','cheetah','drift','frog','girl','hummingbird','monkey','monkeydog','parachute','penguin','soldier','worm'};
name = names{id}

%baseline
gt = ['../video/Seg/GroundTruth/', name];
load(['VSS_Segtrack/',name]);
stat1 = eval_multi_level_seg(allthesegmentations(1:end-1),gt)
[l1,m1] = avglensv(allthesegmentations(1:end-1));

%g=10
g=50
load(['VSS_Segtrack_',num2str(g),'_9_13_5_255/',name]);
stat2 = eval_multi_level_seg(allthesegmentations(1:end-1),gt)
[l2,m2]= avglensv(allthesegmentations(1:end-1));

%g=100
g=100
load(['VSS_Segtrack_',num2str(g),'_9_13_5_255/',name]);
stat3 = eval_multi_level_seg(allthesegmentations(1:end-1),gt)
[l3,m3]= avglensv(allthesegmentations(1:end-1));



s= [stat1,stat2,stat3]
l=[l1,l2,l3];
m=[m1,m2,m3];
save(['seg_',name]);
end
