function batchSegmentation (ind)

%load('VSSind');
%poolobj = parpool('local',2);

dataset_name = 'SegTrackv2';

dataset_dir = '../../video/Seg/JPEGImages/';
working_dir = '../../.VSSTemp/VSS_Segtrack/';
res_dir = '../../results/VSS_Segtrack/';



% Get a list of all files and folders in this folder.
files = dir(dataset_dir);
files(1:2) = [];
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
% Print folder names to command window.
for k=1:1
	video_name = subFolders(k).name;
	if (strcmp(video_name, '.') == 0 && strcmp(video_name, '..') == 0)
		video_dir = fullfile(dataset_dir, video_name);
		video_working_dir = fullfile(working_dir, video_name);
        if (~exist(video_working_dir,'dir'))
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
		else
			% working with VSB100
			[min_id, no_frames] = findBeginningFrameIndex(video_dir, 5, '.png');
			dataset_setting.filenameheader = 'image';
			dataset_setting.numberformat = '%03d';
			dataset_setting.fileext = '.png';
			dataset_setting.frame_begin_index = min_id;
			dataset_setting.noFrames = no_frames;
		end

		allthesegmentations = VSS_Video(video_dir, video_working_dir, dataset_setting);
		seg_res_path = fullfile(res_dir, [video_name '.mat']);
		parsave(seg_res_path, allthesegmentations);
	end
	fprintf('Finishing %s', subFolders(k).name);
end

%delete(poolobj);

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



