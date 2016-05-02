function []=  fseg(id,g,p1,p2,p3,p4,motion)
addpath(genpath('../code/eval_code'));
names ={'bird_of_paradise','birdfall','bmx','cheetah','drift','frog','girl','hummingbird','monkey','monkeydog','parachute','penguin','soldier','worm'};
name = names{id};
gt = ['../video/Seg/GroundTruth/', name];
if nargin ==1
    display('default');
    type = 1; %1: 1d,2: 2d
    baseline = false;
    g=100;
    p1 = 9;
    p2 = 5;
%    p3 = 5;
%    p4 = 255;
%    motion = 0;
%    g=100
end;
switch type
case 2
    display('eval 2d histogram')
    if ~baseline
        fname  = ['VSS_Segtrack_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion),'/',name]
        load(fname);
        stat = eval_multi_level_seg(allthesegmentations(1:end-1),gt)
        [l,m]= avglensv(allthesegmentations(1:end-1));
        save(['matresult/rseg_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion),'_',name],'stat','l','m');
    else
        load(['VSS_Segtrack/',name]);
        stat = eval_multi_level_seg(allthesegmentations(1:end-1),gt)
        [l,m] = avglensv(allthesegmentations(1:end-1));
        save(['matresult/rseg_baseline_',name],'stat','m','l');
    end
case 1
    display('eval 1d histogram')
    if ~baseline
        fname  = ['VSS_1d_Segtrack_',num2str(g),'_',num2str(p1),'_',num2str(p2),'/',name]
        load(fname);
        stat = eval_multi_level_seg(allthesegmentations(1:end-1),gt)
        [l,m]= avglensv(allthesegmentations(1:end-1));
        save(['matresult/rseg_1d_',num2str(g),'_',num2str(p1),'_',num2str(p2),'_',name],'stat','l','m');
    else
        display('nothing to do here');
    end
end;
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
