function []=  ftestchen(id)
addpath(genpath('../code/eval_code'));
names ={'bus_fa','container_fa','garden_fa','ice_fa','paris_fa','soccer_fa','salesman_fa','stefan_fa'};

name = names{id}

%baseline
load(['VSS_chen/',name]);

gt = ['../video/chen/input/GT/', name,'/gt_index/'];
stat1 = eval_multi_level_chen(allthesegmentations(1:end-1),gt)
[l1,m1] = avglensv(allthesegmentations(1:end-1));

%g=10
g=50
load(['VSS_chen_',num2str(g),'_9_13_5_255/',name]);
stat2 = eval_multi_level_chen(allthesegmentations(1:end-1),gt)
[l2,m2]= avglensv(allthesegmentations(1:end-1));

%g=100
g=100
load(['VSS_chen_',num2str(g),'_9_13_5_255/',name]);
stat3 = eval_multi_level_chen(allthesegmentations(1:end-1),gt)
[l3,m3]= avglensv(allthesegmentations(1:end-1));



s= [stat1,stat2,stat3]
l=[l1,l2,l3];
m=[m1,m2,m3];
save(['chen_',name]);
end
