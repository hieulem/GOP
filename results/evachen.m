function [s]=  evachen(g,p1,p2,p3,p4,motion)
addpath(genpath('../code/eval_code'));
names ={'bus_fa','container_fa','garden_fa','ice_fa','paris_fa','soccer_fa','salesman_fa','stefan_fa'};
%p1 = 9;
%p2 = 13;
%p3 = 5;
%p4 = 255;
%g=100
s =zeros(36,4);
for i=1:8
    
name = names{i};
if g>0
load(['rchen_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion),'_',name],'stat','l','m');
s = s+ stat;
else
%baseline
load(['rchen_baseline_',name],'stat','l','m');
s = s+stat;
end
end
s = s/8;
%s= [stat1,stat2,stat3]
%l=[l1,l2,l3];
%m=[m1,m2,m3];
%save(['rchen_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion),'_',name]);
end
