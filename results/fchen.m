function []=  fchen(id)
addpath(genpath('../code/eval_code'));

gehoptions.dataset = 'Segtrack';
switch gehoptions.dataset
    case 'chen'
        names ={'bus_fa','container_fa','garden_fa','ice_fa','paris_fa','soccer_fa','salesman_fa','stefan_fa'};
        name = names{id}
        gt = ['../video/chen/input/GT/', name,'/gt_index/'];
    case 'Segtrack'
        names ={'bird_of_paradise','birdfall','bmx','cheetah','drift','frog','girl','hummingbird','monkey','monkeydog','parachute','penguin','soldier','worm'};
        name = names{id}
        gt = ['../video/Seg/GroundTruth/', name];
end;

if nargin ==1
    display('default');
    baseline = false;
    gehoptions.phi = 100;
    gehoptions.nGeobins = 9;
    gehoptions.nIntbins = 13;
    gehoptions.maxGeo = 5;
    gehoptions.maxInt = 255;
    gehoptions.usingflow = 0;
    gehoptions.type = '2d';
    gehoptions.useSpatialGrid = 1;
    gehoptions.Grid = [2,2]
    gehoptions.metric = 'chisq2d';
end;

switch baseline
    case false
        flag  = gen_flag_from_option(gehoptions);
        fname =  [flag,'/',name]
        load(fname);
        switch gehoptions.dataset
            case 'chen'
                stat = eval_multi_level_chen(allthesegmentations(1:end-1),gt)
            case 'Segtrack'
                stat = eval_multi_level_seg(allthesegmentations(1:end-1),gt)
        end
        
        [l,m]= avglensv(allthesegmentations(1:end-1));
        if ~exist(['matresult/r',flag],'dir')
            mkdir(['matresult/r',flag])
        end;
        save(['matresult/r',flag,'/',name],'stat','l','m');
    case true
        %baseline
        display('baseline')
        load(['baseline_',gehoptions.dataset,'/',name]);
        switch gehoptions.dataset
            case 'chen'
                stat = eval_multi_level_chen(allthesegmentations(1:end-1),gt)
            case 'Segtrack'
                stat = eval_multi_level_seg(allthesegmentations(1:end-1),gt)
        end
        stat = eval_multi_level_chen(allthesegmentations(1:end-1),gt)
        [l,m] = avglensv(allthesegmentations(1:end-1));
        save(['matresult/baseline_',gehoptions.dataset,'_',name],'stat','l','m');
        
end
end
%s= [stat1,stat2,stat3]
%l=[l1,l2,l3];
%m=[m1,m2,m3];
%save(['rchen_',num2str(p1),'_',num2str(p2),'_',num2str(p3),'_',num2str(p4),'_',num2str(motion),'_',name]end
