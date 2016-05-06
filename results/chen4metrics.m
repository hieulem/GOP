function [s]=  evachen(g,p1,p2,p3,p4,motion)
addpath(genpath('../code/eval_code'));
names ={'bus_fa','container_fa','garden_fa','ice_fa','paris_fa','soccer_fa','salesman_fa','stefan_fa'};
%p1 = 9;
%p2 = 13;
%p3 = 5;
%p4 = 255;
%g=100
s =zeros(36,4);
sm = zeros(36,1);
sl = zeros(36,1);
c=0;
prefix1 = 'matresult/chisq_rchen_';
prefix2 = 'combined_res_';

switch nargin
case 6
    for i=1:8
        name = names{i};
        load([prefix1,num2str(g),'_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion),'_',name],'stat','l','m');
        s = s+ stat;
        sl = sl + l;
        sm = sm +m;
    end;
    s=s/8;sl = sl/8;
    sm = sm/8;
    s=[s,sl] ;       
    save([prefix2,num2str(g),'_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion)],'s','sm','sl');

case 0

%baseline
    for i=1:8
        name = names{i};
        load([prefix1,'baseline_',name],'stat','l','m');
        s = s+stat;
        sm = sm + m;
        sl = sl+l;
    end
    s = s/8;
    sm = sm/8;
    sl = sl/8;
    s =[s,sl];
    save([prefix2,'baseline'],'s','sm','sl');
case 3
   for i=1:8
        name = names{i};
        load([prefix1,'1d_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',name],'stat','l','m');
        s = s+ stat;
        sl = sl + l;
        sm = sm +m;
    end;
    s=s/8;sl = sl/8;
    sm = sm/8;
    s =[s,sl];      
    save([prefix2,'chen_1d_',num2str(g),'_',num2str(p1),'_',num2str(p2)],'s','sm','sl');
end
%s= [stat1,stat2,stat3]
%l=[l1,l2,l3];
%m=[m1,m2,m3];
%save(['rchen_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion),'_',name]);
end
