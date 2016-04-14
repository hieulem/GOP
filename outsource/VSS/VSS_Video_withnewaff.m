function [allthesegmentations] = VSS_Video_withnewaff(video_path, base_working_dir, dataset_setting)

dataset_setting.filenameheader;
dataset_setting.numberformat;
dataset_setting.fileext;
dataset_setting.frame_begin_index;
dataset_setting.noFrames;


% Parameters
datadir = '';

if (~isdeployed)
    Setthepath();
end

if (base_working_dir(end) == '/')
	base_working_dir(end) = [];
end
% [upperPath, deepestFolder, ~] = fileparts(base_working_dir)
% video_base_working_dir = fullfile(base_working_dir, deepestFolder);	% Working directory for this particular video
% mkdir(video_base_working_dir);

basedrive = [base_working_dir '/']; %Directory where the VideoProcessingTemp dir is located


options.newucmtwo=true;
options.cleanifexisting=Inf; options.origucm2=false;
options.usebflow=false; options.pre_filter_flow=true; options.filter_flow=true;



% Output params
options.testthesegmentation=false; options.segaddname='MAHIS_benchmark'; %Hierarchical image segmentation benchmark (Boundary PR, SC, PRI, VI)
options.testmanifoldclustering=true; options.clustaddname='VS_perpixelerror_benchmark'; %Per pixel error metric
options.testnewsegmentation=true; options.newsegname='VS_benchmark'; %Hierarchical video segmentation benchmark (Boundary PR, SC, PRI, VI)
options.calibratetheparameters=false; options.calibrateparametersname='RAW_parameter_setup'; %Gather row values and test affinity transformations


%Analyse the input: this is given priority against the options define earlier in this function
% if ( (exist('varargin','var')) && (~isempty(varargin)) ) %varargin should contain pairs (opfieldname,opfieldcontent)
%     numvarargin=numel(varargin);                         %opfieldname is a string
%     if ((mod(numvarargin,2))==0)                         %opfieldname is a string containing numbers or array ('1' or '[1,2,3]')
%         for i=1:floor(numvarargin/2)
%             options.(varargin{(i-1)*2+1})=str2num(varargin{(i-1)*2+2}); %#ok<ST2NM>
%             if (isempty(options.(varargin{(i-1)*2+1})))
%                 options.(varargin{(i-1)*2+1})=varargin{(i-1)*2+2}; %opfieldname may contain strings ('{stt,ltt,aba,abm,stm,sta}')
%                 options=Adjustcellarrays(options,(varargin{(i-1)*2+1})); %Parse strings to transform into cell arrays
%             end
%         end
%     else
%         fprintf('Additional otpions not recognized\n');
%     end
% end


%Apply options specified in options.stpcas (this does not overwrite the single options)
if ( (~isfield(options,'stpcas')) || (isempty(options.stpcas)) ) %This sets the default parameters
    options.stpcas='paperoptnrm';
end
options=Applysetupcase(options);
options %#ok<NOPRT>

%@Hieu
options.usingGeH =1;

% Location of the video working directory
basename_variables_directory=[basedrive,'working_directory',filesep,'data',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);
filenames.flowpath = dataset_setting.flowpath;


% Location and file pattern of the original video frames
filename_sequence_basename_frames_or_video.basename=[video_path '/' dataset_setting.filenameheader];
filename_sequence_basename_frames_or_video.number_format=dataset_setting.numberformat;
filename_sequence_basename_frames_or_video.closure=dataset_setting.fileext;
filename_sequence_basename_frames_or_video.startNumber=dataset_setting.frame_begin_index;

% Location and file pattern of temporary working video frames
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'working_directory',filesep,'data',filesep,'wrpimages',filesep,dataset_setting.filenameheader];
filename_sequence_basename_frames_or_video.wrpnumber_format=dataset_setting.numberformat;
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=dataset_setting.frame_begin_index;

% Video correction parameters, specifying whether the frames are to be
% de-interlaced, be processed at full resolution or resized, and whether
% the frames should be cropped
videocorrectionparameters.deinterlace=false;



% set the resize ratio
videocorrectionparameters.rszratio=dataset_setting.rszratio; %if 0 image is not resized
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left

% Location and file pattern of the groundtruth annotations for the video
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'working_directory',filesep,'data',filesep,'gtimages',filesep,dataset_setting.filenameheader];
filename_sequence_basename_frames_or_video.gtnumber_format=dataset_setting.numberformat;
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=dataset_setting.frame_begin_index;

% Output: Location and file pattern of the image segmentation output
ucm2filename.basename=[basedrive,'working_directory',filesep,'data',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%05d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=dataset_setting.frame_begin_index;

noFrames=dataset_setting.noFrames;
[cim,ucm2,flows,allthesegmentations] = Doallprocessing_withnewaff(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);

    

end


