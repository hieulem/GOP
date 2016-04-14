function segment_video_segtrack_withnewaff (id)

if id==6 || id ==14
    disp('Nope');
    return;
end;

addpath(genpath('../../standalonecode/code/'));
addpath(genpath('../../standalonecode/outsource/'));
load('video_list_segtrack_aff.mat'); % To get variable video_info_list

video_info = video_info_list(id);
dataset_name = video_info.dataset_name;
video_dir = video_info.video_dir;
video_name = video_info.video_name;
host_working_dir = video_info.host_working_dir;
res_dir = video_info.res_dir;
if ~exist(res_dir)
    mkdir(res_dir);
end;

%video_dir = fullfile(dataset_dir, video_name);
video_working_dir = fullfile(host_working_dir, video_name);
if (~exist(video_working_dir))
    mkdir(video_working_dir);
    disp('fuck Vu');
end

disp(video_working_dir);

dataset_setting = [];
if (strcmp(dataset_name,'SegTrackv2'))
    % Working with segtrack v2
    [min_id, no_frames] = findBeginningFrameIndex(video_dir, 0, '.png');
    %  no_frames =4;
    dataset_setting.filenameheader = '';
    dataset_setting.numberformat = '%05d';
    dataset_setting.fileext = '.png';
    dataset_setting.frame_begin_index = min_id;
    dataset_setting.noFrames = no_frames;
    dataset_setting.rszratio = 0;
    dataset_setting.flowpath = video_info.flow_dir;
else
    % working with VSB100
    [min_id, no_frames] = findBeginningFrameIndex(video_dir, 5, '.png');
    dataset_setting.filenameheader = 'image';
    dataset_setting.numberformat = '%03d';
    dataset_setting.fileext = '.png';
    dataset_setting.frame_begin_index = 'min_id';
    dataset_setting.noFrames = no_frames;
    dataset_setting.rszratio = 0.5;
end

allthesegmentations = VSS_Video_withnewaff(video_dir, video_working_dir, dataset_setting);
seg_res_path = fullfile(res_dir, [video_name '.mat']);
parsave(seg_res_path, allthesegmentations);

%
% fprintf('Finishing %s \n', video_name);
% name ='girl';
% load(['/home/hle/Project/GOP/.VSSTemp/VSS_Segtrack/',name,'/working_directory/Shared/Benchmark/VS_benchmark/Ucm2/allsegsdata']);
% gen_cl_from_spmap(allthesegmentations{1},['newSTAdot',name]);
% load(['./baseline/',name]);
% gen_cl_from_spmap(allthesegmentations{20},['ori1',name]);
end

function parsave(filepath, allthesegmentations)
save(filepath, 'allthesegmentations');
end

function [min_id, no_frames] = findBeginningFrameIndex(video_dir, char_length, ext)
files = dir( fullfile(video_dir, ['*' ext]));
files = {files.name}';
min_id = Inf;
for i = 1:length(files)
    num = str2num(files{i}(char_length + 1:end-length(ext)));
    if (num < min_id)
        min_id = num;
    end
end

no_frames = length(files);
end



