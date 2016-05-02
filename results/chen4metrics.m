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
switch nargin
case 6
    for i=1:8
        name = names{i};
        load(['matresult/rchen_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion),'_',name],'stat','l','m');
        s = s+ stat;
        sl = sl + l;
        sm = sm +m;
    end;
    s=s/8;sl = sl/8;
    sm = sm/8;
    s;       
    save(['rallchen_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion)],'s','sm','sl');
case 0

%baseline
    for i=1:8
        name = names{i};
        load(['matresult/rchen_baseline_',name],'stat','l','m');
        s = s+stat;
        sm = sm + m;
        sl = sl+l;
    end
    s = s/8;
    sm = sm/8;
    sl = sl/8;
    save('rallchen_baseline','s','sm','sl');
case 3
   for i=1:8
        name = names{i};
        load(['matresult/rchen_1d_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',name],'stat','l','m');
        s = s+ stat;
        sl = sl + l;
        sm = sm +m;
    end;
    s=s/8;sl = sl/8;
    sm = sm/8;
    s ;      
    save(['rallchen_1d_',num2str(g),'_',num2str(p1),'_',num2str(p2)],'s','sm','sl');
end
%s= [stat1,stat2,stat3]
%l=[l1,l2,l3];
%m=[m1,m2,m3];
%save(['rchen_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion),'_',name]);
s = [s,sm,sl];
end
