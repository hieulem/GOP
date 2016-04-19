function segment_video_segtrack(id)
addpath(genpath('../../standalonecode/code/'));
addpath(genpath('../../standalonecode/outsource/'));
%load('video_list_segtrack_aff_g100.mat'); % To get variable video_info_list

%GeH parameter settings

gehoptions.phi = 100;
gehoptions.nGeobins = 9;
gehoptions.nIntbins = 13;
gehoptions.maxGeo = 5;
gehoptions.maxInt = 255;
gehoptions.usingflow = 1;

baseline =false;

%directory settings
dataset.name = 'Segtrack';
dataset.dir = '../../video/Seg/JPEGImages';
dataset.working_dir = '../../.VSSTemp/VSS_Segtrack/';
dataset.res_dir = ['../../results/VSS_',dataset.name,'_',num2str(gehoptions.phi),'_' ...
    ,num2str(gehoptions.nGeobins),'_',num2str(gehoptions.nIntbins),'_',num2str(gehoptions.maxGeo),'_',num2str(gehoptions.maxInt),'/'];
if baseline
    dataset.res_dir = ['../../results/VSS_',dataset.name];
end
dataset.flow_dir ='../../flow_data/flow_motion_default/segtrack/';

[video_info,dataset_settings] = getvideoinfo( dataset,id );


disp(['Running VSS on ',video_info.video_name]);
if ~baseline
   allthesegmentations = VSS_Video_withnewaff(video_info.video_dir, video_info.video_working_dir, dataset_settings,gehoptions);
else
   allthesegmentations = VSS_Video(video_info.video_dir, video_info.video_working_dir, dataset_settings);
end;
seg_res_path = fullfile(video_info.res_dir, [video_info.video_name '.mat']);
save(seg_res_path, 'allthesegmentations');
end



