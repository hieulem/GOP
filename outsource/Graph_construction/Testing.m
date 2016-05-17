
all_the_common_options;

%%HIEU: OUR SETTINGS GO HERE:
options.dataset = 'vsb_100';
options.videoname = 'test';
options.savepath =  fullfile('../../results_GR2015',options.dataset,'baseline');
if ~exist(options.savepath,'dir');
    mkdir(options.savepath);
end;
options.savepath = mfullfile(options.savepath,options.videoname);
id=1;
[ filenames,filename_sequence_basename_frames_or_video,noFrames,ucm2filename,videocorrectionparameters ] ...
                = get_filenames(options,id);

% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    