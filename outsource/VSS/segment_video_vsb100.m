function segment_video_vsb100 (id)

load('video_list_vsb100.mat'); % To get variable video_info_list

video_info = video_info_list(id);
dataset_name = video_info.dataset_name;
video_dir = video_info.video_dir;
video_name = video_info.video_name;
host_working_dir = video_info.host_working_dir;
res_dir = video_info.res_dir;

%video_dir = fullfile(dataset_dir, video_name);
video_working_dir = fullfile(host_working_dir, video_name);
if (exist(video_working_dir) ~= 7)
    mkdir(video_working_dir);
end

dataset_setting = [];
if (strcmp(dataset_name,'SegTrackv2'))
    % Working with segtrack v2
    [min_id, no_frames] = findBeginningFrameIndex(video_dir, 0, '.png');
    dataset_setting.filenameheader = '';
    dataset_setting.numberformat = '%05d';
    dataset_setting.fileext = '.png';
    dataset_setting.frame_begin_index = min_id;
    dataset_setting.noFrames = no_frames;
    dataset_setting.rszratio = 0;
else
    % working with VSB100
    [min_id, no_frames] = findBeginningFrameIndex(video_dir, 5, '.png');
    dataset_setting.filenameheader = 'image';
    dataset_setting.numberformat = '%03d';
    dataset_setting.fileext = '.png';
    dataset_setting.frame_begin_index = min_id;
    dataset_setting.noFrames = no_frames;
    dataset_setting.rszratio = 0.5;
end

allthesegmentations = VSS_Video(video_dir, video_working_dir, dataset_setting);
seg_res_path = fullfile(res_dir, [video_name '.mat']);
parsave(seg_res_path, allthesegmentations);


fprintf('Finishing %s', video_name);



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



