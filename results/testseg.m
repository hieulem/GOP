names ={'frog','worm'};
name = names{1}
g=100;
addpath(genpath('../code/eval_code'));
gt = ['../video/Seg/GroundTruth/', name];
load(['VSS_Segtrack/',name]);
stat1 = eval_multi_level_seg(allthesegmentations(1:end-1),gt);
[l1,m1] = avglensv(allthesegmentations(1:end-1));


load(['VSS_Segtrack_',num2str(g),'_9_13_5_255/',name]);
stat2 = eval_multi_level_seg(allthesegmentations(1:end-1),gt);
[l2,m2]= avglensv(allthesegmentations(1:end-1));
s= [stat1,stat2]
l=[l1,l2];
m=[m1,m2];
save(['seg_',num2str(g),'_',name]);
