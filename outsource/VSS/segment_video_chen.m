function segment_video_chen(idx)

dataseti= 2;
i = myind2sub([8,2,2],idx,3);
id = i(1);
addpath(genpath('../../standalonecode/code/'));
addpath(genpath('../../standalonecode/outsource/'));
%load('video_list_segtrack_aff_g100.mat'); % To get variable video_info_list
metricl ={'emd2d','chisq2d'};
%GeH parameter settings
baseline =false;

intl =[5,13];
flowl = [0,1];
gehoptions.phi = 100;
gehoptions.nGeobins = 9;
gehoptions.nIntbins = intl(i(2));
gehoptions.maxGeo = 5;
gehoptions.maxInt = 255;
gehoptions.usingflow = 0;%flowl(i(4));
gehoptions.type = '2d';
gehoptions.metric = metricl{i(3)}; 
gehoptions.useSpatialGrid = 1;
gehoptions.Grid = [2,2]

if gehoptions.useSpatialGrid == 1
    pre_flag = ['Grid',array2str(gehoptions.Grid),gehoptions.metric,'_'];
else
    pre_flag = [];
end


switch dataseti
    case 1
        %directory settings
        dataset.name = 'Segtrack';
        dataset.dir = '../../video/Seg/JPEGImages';
        dataset.working_dir = '../../.VSSTemp/VSS_Segtrack/';
        dataset.resdir = '../../results/';
    case 2
        %directory settings
        dataset.name = 'chen';
        dataset.dir = '../../video/chen/input/PNG/';
        dataset.working_dir = '../../.VSSTemp/VSS_chen/';
        dataset.resdir = '../../results/';
end;
switch gehoptions.type
    case '2d'
        dataset.res_dir = [dataset.resdir,pre_flag,dataset.name,'_',num2str(gehoptions.phi),'_' ...
            ,num2str(gehoptions.nGeobins),'_',num2str(gehoptions.nIntbins),'_',num2str(gehoptions.maxGeo),'_',num2str(gehoptions.maxInt),'/'];
    case '1d'
        dataset.res_dir = [dataset.resdir,pre_flag,dataset.name,'_',num2str(gehoptions.phi),'_' ...
            ,num2str(gehoptions.nGeobins),'_',num2str(gehoptions.maxGeo),'/'];
end;
if baseline
    dataset.res_dir = [dataset.resdir,dataset.name,'_baseline'];
end


[video_info,dataset_settings] = getvideoinfo( dataset,id );
switch dataseti
    case 1
        gehoptions.flowpath =['../../flow_data/flow_motion_default/segtrack/','flow',video_info.video_name];
    case 2
        gehoptions.flowpath =['../../flow_data/flow_motion_default/chen/',video_info.video_name,'/flow',video_info.video_name];
end;
    

disp(['Running VSS on ',video_info.video_name]);
if ~baseline
    allthesegmentations = VSS_Video_withnewaff(video_info.video_dir, video_info.video_working_dir, dataset_settings,gehoptions);
else
    allthesegmentations = VSS_Video(video_info.video_dir, video_info.video_working_dir, dataset_settings);
end;
seg_res_path = fullfile(video_info.res_dir, [video_info.video_name '.mat']);
save(seg_res_path, 'allthesegmentations');
end



