function [ video_info,dataset_setting ] = getvideoinfo( dataset,id )
%GETVIDEOINFO Summary of this function goes here
%   Detailed explanation goes here


video_info_list = createVideoInfoList(dataset);
video_info = video_info_list(id);
dataset_name = video_info.dataset_name;
video_dir = video_info.video_dir;
video_name = video_info.video_name;
host_working_dir = video_info.host_working_dir;
res_dir = video_info.res_dir;
if ~exist(res_dir)
    mkdir(res_dir);
end;
video_working_dir = fullfile(host_working_dir, video_name);
if (~exist(video_working_dir))
    mkdir(video_working_dir);
    disp('fuck Vu');
end
disp(video_working_dir);
dataset_setting = [];
if (strcmp(dataset_name,'Segtrack'))

    % Working with segtrack v2
    [min_id, no_frames] = findBeginningFrameIndex(video_dir, 0, '.png');
    %  no_frames =4;
    dataset_setting.filenameheader = '';
    dataset_setting.numberformat = '%05d';
    dataset_setting.fileext = '.png';
    dataset_setting.frame_begin_index = min_id;
    dataset_setting.noFrames = no_frames;
    dataset_setting.rszratio = 0;
    if id==6 || id ==14
        disp('Resizing frog/worm');
        dataset_setting.rszratio = 0.5;
    end;
    dataset_setting.flowpath = video_info.flow_dir;
end;
if (strcmp(dataset_name,'vsb100'))
    % working with VSB100
    [min_id, no_frames] = findBeginningFrameIndex(video_dir, 5, '.png');
    dataset_setting.filenameheader = 'image';
    dataset_setting.numberformat = '%03d';
    dataset_setting.fileext = '.png';
    dataset_setting.frame_begin_index = min_id;
    dataset_setting.noFrames = no_frames;
    dataset_setting.rszratio = 0.5;
end

if (strcmp(dataset_name,'chen'))
    [min_id, no_frames] = findBeginningFrameIndex(video_dir, 0, '.png');
    dataset_setting.filenameheader = '';
    dataset_setting.numberformat = '%05d';
    dataset_setting.fileext = '.png';
    dataset_setting.frame_begin_index = min_id;
    dataset_setting.noFrames = no_frames;
    dataset_setting.rszratio = 0;
    dataset_setting.flowpath = video_info.flow_dir;
end

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


