name ='salesman_fa';
addpath(genpath('../code/eval_code'));
gt = ['../video/chen/input/GT/', name,'/gt_index/'];
load(['VSS_chen/',name]);
stat1 = eval_multi_level_chen(allthesegmentations(1:end-1),gt);
[l1,m1] = avglensv(allthesegmentations(1:end-1));



gt = ['../video/chen/input/GT/', name,'/gt_index/'];
load(['VSS_chen_100_9_13_5_255/',name]);
stat2 = eval_multi_level_chen(allthesegmentations(1:end-1),gt);
[l2,m2] = avglensv(allthesegmentations(1:end-1));


s= [stat1,stat2]
l=[l1,l2];
m=[m1,m2];
save(['chen_g100_',name]);