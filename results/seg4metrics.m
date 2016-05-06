function [s]=  seg4metrics(g,p1,p2,p3,p4,motion)
addpath(genpath('../code/eval_code'));
names ={'bird_of_paradise','birdfall','bmx','cheetah','drift','frog','girl','hummingbird','monkey','monkeydog','parachute','penguin','soldier','worm'};
%p1 = 9;
%p2 = 13;
%p3 = 5;
%p4 = 255;
%motion = 1;
%g=100
s= zeros(36,4);
sm = zeros(36,1);
sl = zeros(36,1);
e = zeros(36,1);
c = 0;
prefix1 = 'matresult/chisq_rseg_';
prefix2 = 'combined_res_';
switch nargin
case 6 %2d histogram
    for i=1:14
        name = names{i};
        load([prefix1,num2str(g),'_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion),'_',name],'stat','l','m');
%        load(['matresult/evseg_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion),'_',name],'ev');
        stat;
        while ~isempty(stat)
           c=c+1;
           s = s+ stat(1:36,:);
           stat(1:36,:) = [];
        end
 %       e = e+ev;
        sl = sl+l;
    end;
    s=s/c;s
%    e = e/14;
    sl=sl/14;
    s=[s,sl];
    save([prefix2,num2str(g),'_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion)],'s');
case 0
    for i=1:14
        name = names{i}
        load([prefix1,'baseline_',name],'stat','m','l');
%        load(['matresult/evseg_baseline_',name],'ev');
        stat;
        while ~isempty(stat)
            c=c+1;
            s = s+ stat(1:36,:);
            stat(1:36,:) = [];
        end;
%        e = e+ev;
        sl = sl+l;
    end;
    s = s/c;s
    %e = e/14;
    sl=sl/14;
    s = [s,sl];
    save([prefix2,'_baseline'],'s');
case 3
    display('1d');
    for i=1:14
        name = names{i}
        load([prefix1,'1d_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',name]);
       
%        load(['matresult/evseg_1d_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',name]);
         while ~isempty(stat)
            c=c+1;
            s = s+ stat(1:36,:);
            stat(1:36,:) = [];
        end;
%        e= e+ev;
        sl = sl+l;
    end;
    s = s/c;s
    sl = sl/14;
%    e= e/14;
    s =[s,sl];
    save([prefix2,'1d_',num2str(g),'_',num2str(p1),'_',num2str(p2)],'s');
end

%g=50
%load(['VSS_Segtrack_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion),'/',name]);
%stat2 = eval_multi_level_seg(allthesegmentations(1:end-1),gt)
%[l2,m2]= avglensv(allthesegmentations(1:end-1))

%baseline
%load(['VSS_Segtrack/',name]);
%stat1 = eval_multi_level_seg(allthesegmentations(1:end-1),gt)
%[l1,m1] = avglensv(allthesegmentations(1:end-1));


%s= [stat1,stat2,stat3]
%l=[l1,l2,l3];
%m=[m1,m2,m3];
%save(['rseg_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion),'_',name]);
end
