function [ ] = runallchen( idx )
%directory settings

option.dataset = 2;  %1:segtrack,%2:chen


addpath('./ers_matlab_wrapper_v0.2.1');
addpath(genpath('../../../standalonecode/code/'));
addpath(genpath('../../../standalonecode/outsource/'));

option.spType = 'ers'; %the superpixel algorithm. can be either 'ers' or 'other',

option.sampleRate = 0.5; %For additional run-time speed up. can be betwee
option.subVolume = 4; %how many sub-volumes to split the video for processing.
option.useMotion = 0; 
option.fitMethod = 2; 
option.toShow = 0; 
option.usePCA = 0;

splist = [100,200,300,400];
metricl = {'emd2d'};

i = myind2sub([8,2,4,1,2],idx,5);


%ii=[6,14];
%unpack the idx
id =i(1);
option.useGeo= 1;% geol(i(2));
option.numSP = splist(i(3)) %number of superpixels to extract per frame

gehoptions.metric = 'emd2d' ; %
phil =[50,100];
intl =[5,13];
flowl = [1];
gehoptions.phi = phil(i(5));
gehoptions.nGeobins = 9;
gehoptions.nIntbins = intl(i(2));
gehoptions.maxGeo = 5;
gehoptions.maxInt = 255;
gehoptions.usingflow = flowl(i(4));
gehoptions.type = '2d';
gehoptions.useSpatialGrid = 1;
gehoptions.Grid = [3,3]

if gehoptions.useSpatialGrid == 1
    save_flag = ['Grid',array2str(gehoptions.Grid)];
else 
    save_flag = [];
end



switch option.dataset
    case 1
        names ={'bird_of_paradise','birdfall','bmx','cheetah','drift','frog','girl','hummingbird','monkey','monkeydog','parachute','penguin','soldier','worm'};
        name = names{id};
        disp(['Video name: ',name]);
        gehoptions.flowpath  =['../../../flow_data/flow_motion_default/segtrack/','flow',name];        
        gt = ['../../../video/Seg/GroundTruth/', name];
        dataset.dir = '../../../video/Seg/JPEGImages/';
        
        option.inputDIR = [dataset.dir,name,'/']; 
        option.tmpdir = ['./data/SegTrackv2/tmp/',name];
        if ~exist(option.tmpdir) 
            mkdir(option.tmpdir) 
        end;
        option.tmpfile = [option.tmpdir,'/ers_',num2str(option.numSP),'.mat'];
        option.motionMat = ['./data/SegTrackv2/motions/',name]; 
        option.outputDIR = ['./output/Segtrack/',name,'/',num2str(option.useGeo),'_',num2str(option.numSP),'/']; 
        
        savepath = ['../../../ICCV2015res/Segtrack_test/'];
        if ~exist(savepath)
            mkdir(savepath)
        end;
        outputs = pgpMain2(option,gehoptions);
        thesegmentation = outputs{1};
        s = eval_one_level_seg(thesegmentation,gt)
        nvx= numel(unique(thesegmentation))
        avglen = avglen_one_lv(thesegmentation)
        if option.useGeo ==0
            savename= ['bl_', num2str(option.numSP),'_',name];
            save([savepath,savename], 'thesegmentation','s','nvx');
        else
            switch gehoptions.type
                case '1d'
                    savename= [save_flag,gehoptions.metric,'_', num2str(option.numSP),'_',num2str(gehoptions.phi),'_',...
                        num2str(gehoptions.nGeobins),'_', num2str(gehoptions.maxGeo),'_', num2str(gehoptions.usingflow),'_',name];
                    save([savepath,savename], 'thesegmentation','s','nvx','avglen');
                case '2d'
                    savename= [save_flag,gehoptions.metric,'_',num2str(option.numSP),'_',num2str(gehoptions.phi),'_',num2str(gehoptions.nGeobins),'_',...
                        num2str(gehoptions.nIntbins),'_', num2str(gehoptions.maxGeo),'_',num2str(gehoptions.maxInt),'_', num2str(gehoptions.usingflow),'_',name];
                    save([savepath,savename], 'thesegmentation','s','nvx','avglen');
            end
        end
            
    case 2
        names ={'bus_fa','container_fa','garden_fa','ice_fa','paris_fa','soccer_fa','salesman_fa','stefan_fa'};
        name = names{id};
        disp(['Video name: ',name]);
        gehoptions.flowpath =['../../../flow_data/flow_motion_default/chen/','flow',name];        
        gt = ['../../../video/chen/input/GT/', name,'/gt_index/'];
        dataset.dir = '../../../video/chen/input/PNG/';
        option.tmpdir = ['./data/Chen_Xiph.org/tmp/',name];
        if ~exist(option.tmpdir) 
            mkdir(option.tmpdir) 
        end;
        option.tmpfile = [option.tmpdir,'/ers_',num2str(option.numSP),'.mat'];
        option.inputDIR = [dataset.dir,name,'/']; 
        option.motionMat = ['./data/Chen_Xiph.org/motions/',name]; 
        option.outputDIR = ['./output/chen/',name,'/',num2str(option.useGeo),'_',num2str(option.numSP),'/']; 

        savepath = ['../../../ICCV2015res/Chen/'];
        if ~exist(savepath)
            mkdir(savepath)
        end;

        outputs = pgpMain2(option,gehoptions);
        thesegmentation = outputs{1};
        s = eval_one_level_chen(thesegmentation,gt)
        nvx= numel(unique(thesegmentation))
        avglen = avglen_one_lv(thesegmentation)
        
        
        if option.useGeo ==0
            savename= ['bl_', num2str(option.numSP),'_',name];
            save([savepath,savename], 'thesegmentation','s','nvx','avglen');
        else
            switch gehoptions.type
                case '1d'
                    savename= [save_flag,gehoptions.metric,'_', num2str(option.numSP),'_',num2str(gehoptions.phi),'_',...
                        num2str(gehoptions.nGeobins),'_', num2str(gehoptions.maxGeo),'_', num2str(gehoptions.usingflow),'_',name];
                    save([savepath,savename], 'thesegmentation','s','nvx','avglen');
                case '2d'
                    savename= [save_flag,gehoptions.metric,'_',num2str(option.numSP),'_',num2str(gehoptions.phi),'_',num2str(gehoptions.nGeobins),'_'...
                    num2str(gehoptions.nIntbins),'_', num2str(gehoptions.maxGeo),'_',num2str(gehoptions.maxInt),'_', num2str(gehoptions.usingflow),'_',name];
                    save([savepath,savename], 'thesegmentation','s','nvx','avglen');
                    
            end
        end
end;   





end

