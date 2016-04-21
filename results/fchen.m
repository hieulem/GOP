function []=  fchen(id)
addpath(genpath('../code/eval_code'));
names ={'bus_fa','container_fa','garden_fa','ice_fa','paris_fa','soccer_fa','salesman_fa','stefan_fa'};
name = names{id}
gt = ['../video/chen/input/GT/', name,'/gt_index/'];
p1 = 9;
p2 = 13;
p3 = 5;
p4 = 255;
g=100
['VSS_chen_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'/',name]
load(['VSS_chen_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'/',name]);
stat3 = eval_multi_level_chen(allthesegmentations(1:end-1),gt)
[l3,m3]= avglensv(allthesegmentations(1:end-1));

g=50
load(['VSS_chen_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'/',name]);
stat2 = eval_multi_level_chen(allthesegmentations(1:end-1),gt)
[l2,m2]= avglensv(allthesegmentations(1:end-1));

%baseline
load(['VSS_chen/',name]);
stat1 = eval_multi_level_chen(allthesegmentations(1:end-1),gt)
[l1,m1] = avglensv(allthesegmentations(1:end-1));


s= [stat1,stat2,stat3]
l=[l1,l2,l3];
m=[m1,m2,m3];
save(['rchen_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion),'_',name]);
end
