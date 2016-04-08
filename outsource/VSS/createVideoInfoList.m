function createVideoInfoList()

% Video info list file location
vid_info_path = './video_list.mat';

% Params to write to the file
dataset_name = 'SegTrackv2';

dataset_dir = '../../video/Seg/JPEGImages/';
working_dir = '../../.VSSTemp/VSS_Segtrack/';
res_dir = '../../results/VSS_Segtrack/';

% dataset_dir = '/Users/vunh/Documents/SBU/CourseWork/CSE512 - Machine Learning/Project/code/dataset/SegTrackv2/PNG_Std';
% working_dir = '/Users/vunh/Documents/SBU/CourseWork/CSE512 - Machine Learning/Project/code/dataset/temp_working_dir';
% res_dir = '/Users/vunh/Documents/SBU/CourseWork/CSE512 - Machine Learning/Project/code/output';


video_info_list = [];


% Get a list of all files and folders in this folder.
files = dir(dataset_dir)
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir]
% Extract only those that are directories.
subFolders = files(dirFlags)
% Print folder names to command window.
iVid = 1;
for k = 1 : length(subFolders)
	video_name = subFolders(k).name;
	if (strcmp(video_name, '.') == 0 && strcmp(video_name, '..') == 0)
		video_dir = fullfile(dataset_dir, video_name);
        
        video_info_list(iVid).dataset_name = dataset_name;
        video_info_list(iVid).video_dir = video_dir;
        video_info_list(iVid).video_name = video_name;
        video_info_list(iVid).host_working_dir = working_dir;
        video_info_list(iVid).res_dir = res_dir;
        iVid = iVid + 1;
    end
end

save(vid_info_path, 'video_info_list');

end






