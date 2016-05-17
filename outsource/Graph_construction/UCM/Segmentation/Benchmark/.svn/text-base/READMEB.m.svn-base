% Benchmark code
% Maintained by Fabio Galasso <research@fabiogalasso.org>
% February 2014
%
% If using this code, please cite the following:
% A Unified Video Segmentation Benchmark: Annotation, Metrics and Analysis
% F. Galasso, N. Shankar Nagaraja, T. Jimenez Cardenas, T. Brox, B. Schiele
% In ICCV, 2013
%
% By using this code you abide to the license agreement enclosed in the
% file License.txt
%
% Version 1.2



%Include the benchmark code into the Matlab path
path(path,'Benchmark');
path(path,['Benchmark',filesep,'Auxbenchmark']);



%Use the command Computerpimvid computes the Precision-Recall curves

benchmarkpath = './Evaluation/'; %The directory where all results directory are contained
benchmarkdir= 'Algorithm_ochsbrox'; %One the computed results set up for benchmark, here the output of the algorithm of Ochs and Brox (Ucm2 folder) set up for the general benchmark (Images and Groundtruth folders)
requestdelconf=true; %boolean which allows overwriting without prompting a message. By default the user is input for deletion of previous calculations
nthresh=51; %Number of hierarchical levels to include when benchmarking image segmentation
superposegraph=false; %When false a new graph is initialized, otherwise the new curves are added to the graph
testtemporalconsistency=true; %this option is set to false for testing image segmentation algorithms
bmetrics={'bdry','regpr','sc','pri','vi','lengthsncl','all'}; %which benchmark metrics to compute:
                                            %'bdry' BPR, 'regpr' VPR, 'sc' SC, 'pri' PRI, 'vi' VI, 'all' computes all available

output=Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'r',superposegraph,testtemporalconsistency,'all');
%The otuput contains the PR values in corresponding fields
%Outputs are written into a Output folder inside the benchmarkdir folder



%The following plots PR curves and aggregate performance measures for the considered VS algorithms

%Parameter setup
benchmarkpath = './Evaluation/'; %The directory where all results directory are contained
requestdelconf=true; %boolean which allows overwriting without prompting a message. By default the user is input for deletion of previous calculations
nthresh=51; %Number of hierarchical levels to include when benchmarking image segmentation

%General benchmark
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'k',false,[],'all',[],'Output_general_human');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'r',true,[],'all',[],'Output_general_corsoetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'b',true,[],'all',[],'Output_general_galassoetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'g',true,[],'all',[],'Output_general_grundmannetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'r',true,[],'all',[],'Output_general_ochsbrox');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'g--',true,[],'all',[],'Output_general_xuetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'m',true,[],'all',[],'Output_general_arbelaezetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'c',true,[],'all',[],'Output_general_baseline');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'m--',true,[],'all',[],'Output_general_oracle');

%Motion segmentation benchmark
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'k',false,[],[],[],'Output_motionsegm_human');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'r',true,[],[],[],'Output_motionsegm_corsoetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'b',true,[],[],[],'Output_motionsegm_galassoetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'g',true,[],[],[],'Output_motionsegm_grundmannetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'r',true,[],[],[],'Output_motionsegm_ochsbrox');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'g--',true,[],[],[],'Output_motionsegm_xuetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'m',true,[],[],[],'Output_motionsegm_arbelaezetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'c',true,[],[],[],'Output_motionsegm_baseline');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'m--',true,[],[],[],'Output_motionsegm_oracle');

%Non-rigid motion segmentation benchmark
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'k',false,[],[],[],'Output_nonrigidmotion_human');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'r',true,[],[],[],'Output_nonrigidmotion_corsoetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'b',true,[],[],[],'Output_nonrigidmotion_galassoetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'g',true,[],[],[],'Output_nonrigidmotion_grundmannetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'r',true,[],[],[],'Output_nonrigidmotion_ochsbrox');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'g--',true,[],[],[],'Output_nonrigidmotion_xuetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'m',true,[],[],[],'Output_nonrigidmotion_arbelaezetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'c',true,[],[],[],'Output_nonrigidmotion_baseline');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'m--',true,[],[],[],'Output_nonrigidmotion_oracle');

%Camera motion segmentation benchmark
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'k',false,[],[],[],'Output_cameramotion_human');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'r',true,[],[],[],'Output_cameramotion_corsoetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'b',true,[],[],[],'Output_cameramotion_galassoetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'g',true,[],[],[],'Output_cameramotion_grundmannetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'r',true,[],[],[],'Output_cameramotion_ochsbrox');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'g--',true,[],[],[],'Output_cameramotion_xuetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'m',true,[],[],[],'Output_cameramotion_arbelaezetal');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'c',true,[],[],[],'Output_cameramotion_baseline');
benchmarkdir='Precomputedresults'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'m--',true,[],[],[],'Output_cameramotion_oracle');




%Instructions to benchmark your own algorithm
% 1. Download the video sequences and run your algorithm
% 2. Set up an evaluation folder, as in the example Algorithm_ochsbrox:
% 2.1 Download the benchmark subtask you want to test from the project
%     webpage. This will provide the folders Images and Groundtruth that
%     you will include into the evaluation folder
% 2.2 Translate the output of your algorithm into the benchmark format
%     (more details on this below)
% 3. Run the benchmark code, as in the example case of Algorithm_ochsbrox



%Details about the required video segmentation format:
% The benchmark code requires that the output video segmentation frames
% corresponding to the groundtruthed frames be saved in the following
% format:
% <videoname><frame number>.mat
% Files should contain a cell array variable named "segs" containing the
% hierarchical video segmentation for the frame:
% segs{ hierarchical level } = [ dimI x dimJ in format uintX ]
% Each frame at each level represents labels, thus integer values from 1 to max
% number of segmented visual objects

% Note: values of 0 and the max allowed integer values for the adopted
% uintX (e.g. 255 for uint8) format are reserved for use of subtasks.
% The code includes a function "Uintconv" which converts labels in double
% (integer values > 0) to the appropriate uintX format.

% The necessary coding should be (for the first frame of video "airplane")
segs{level}= Uintconv(airplane_output_at_level_frame_1);
save('./Evaluation/Algorithm_ochsbrox/Ucm2/airplane1.mat','segs');



% The benchmark additionally includes code to estimate length and number of
% cluster statistics.
% In order to compute those, the Ucm2 folder must contain output for ALL
% frames in the video sequence, in the format above discussed.
% Note: to evaluate the boundary and volume precision-recall measures, ONLY
% the frames for which ground truth is available are strictly necessary



% It is recommended to load example segmentations from the enclosed
% Algorithm_ochsbrox folder:
load ./Evaluation/Algorithm_ochsbrox/Ucm2/airplane/image063.mat
level=1; %(in this case only 1 hierarchical level is available)
airplane_output_at_level_frame_1= Doublebackconv(segs{level});
Init_figure_no(10), imagesc(airplane_output_at_level_frame_1);

disp(min(airplane_output_at_level_frame_1(:))) %label of object 1 (level 1)
disp(max(airplane_output_at_level_frame_1(:))) %label of object N (level 1)

%In order to show the resulting video
for i=63:183
    load(sprintf('%s%03d.mat','./Evaluation/Algorithm_ochsbrox/Ucm2/airplane/image',i));
    level=1; %(in this case only 1 hierarchical level is available)
    airplane_output_at_level_frame_1= Doublebackconv(segs{level});
    Init_figure_no(10), imagesc(airplane_output_at_level_frame_1);
    title(sprintf('Frame %03d',i));
    pause(0.1);
end

% The function Doublebackconv performs the back conversion of uintX into
% double, normally used in Matlab




