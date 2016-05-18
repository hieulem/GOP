function [filenames,filename_sequence_basename_frames_or_video,noFrames,ucm2filename,videocorrectionparameters,options ] = get_filenames(options,id )

switch options.dataset
    case 'vsb_100'
        
        dataset_dir = '../../video/vsb100/Test/';
        dataset_info = dir(dataset_dir); dataset_info(1:2) =[];
        video_name = dataset_info(id).name;
        options.videoname = video_name;
        video_path = fullfile(dataset_dir,video_name);
        filenameheader = 'image';
        
        basedrive=['.',filesep]; %Directory where the VideoProcessingTemp dir is located
        
        [min_id, noFrames] = findBeginningFrameIndex(video_path, 5, '.png');
        basename_variables_directory=[mfullfile(basedrive,'VideoProcessingTemp',options.dataset,video_name),filesep];

        filenames=Getfilenames(basename_variables_directory,[],options);
        filenames.affinity_matrices=[filenames.filename_directory,'affinities.mat'];
        
        ucm2filename.basename=fullfile(basedrive,'VideoProcessingTemp',options.dataset,video_name,'ucm2images','ucm2image');
        ucm2filename.number_format='%03d';
        ucm2filename.closure='_ucm2.bmp';
        ucm2filename.startNumber=0;
        
        filename_sequence_basename_frames_or_video.basename=fullfile(video_path,filenameheader);
        filename_sequence_basename_frames_or_video.number_format='%03d';
        filename_sequence_basename_frames_or_video.closure='.png';
        filename_sequence_basename_frames_or_video.startNumber=min_id;
        filename_sequence_basename_frames_or_video.wrpbasename= [fullfile(basedrive,'VideoProcessingTemp',options.dataset,video_name,'wrpimages',''),filesep];
        filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
        filename_sequence_basename_frames_or_video.wrpclosure='.png';
        filename_sequence_basename_frames_or_video.wrpstartNumber=1;
        % filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'vw_commercial',filesep,'wrpimages',filesep,''];
        %corbasename replaces wrpbasename
        videocorrectionparameters.deinterlace=false;
        videocorrectionparameters.rszratio=0.5; %if 0 image is not resized
        videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
%         filename_sequence_basename_frames_or_video.gtbasename= fullfile(basedrive,'VideoProcessingTemp',video_name,'gtimages',filesep,'gtimages_');
%         filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
%         filename_sequence_basename_frames_or_video.gtclosure='.png';
%         filename_sequence_basename_frames_or_video.gtstartNumber=min_id;
%         filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,video_name);
%         %filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
        %    147,149,152]; %[1x3 colour; otherobjects] _;26;51
        

    otherwise
        display('what dataset ?');
        
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


