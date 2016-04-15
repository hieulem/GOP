function createVideoInfoList()

% % Video info list file location
% vid_info_path = './video_list_vsb100.mat';
% 
% % Params to write to the file
% dataset_name = 'vsb100';
% dataset_dir = './../../video/vsb100/Test';
% working_dir = './../../.VSSTemp/VSS_vsb100/';
% res_dir = './../../results/VSS_vsb100/';

vid_info_path = './video_list_segtrack_aff_g10.mat';

% Params to write to the file
dataset_name = 'SegTrackv2';
dataset_dir = '../../video/Seg/JPEGImages';
working_dir = '../../.VSSTemp/VSS_Segtrack/';
res_dir = '../../results/VSS_newaff_g10_Segtrack/';
flow_dir ='../../flow_data/flow_motion_default/segtrack/';

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
        video_info_list(iVid).flow_dir = fullfile(flow_dir,['flow',video_name]);
        iVid = iVid + 1;
    end
end

save(vid_info_path, 'video_info_list');

end






