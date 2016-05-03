function [ output_args ] = runSeg( id )
%directory settings

addpath('./ers_matlab_wrapper_v0.2.1');

%% input options, for more detailed parameter info please check the paper.
option.spType = 'ers'; %the superpixel algorithm. can be either 'ers' or 'other',
%ers is the method we used, or you can use other
%method, and implement line 158-161 in pgpMain2.m
option.numSP = 200; %number of superpixels to extract per frame
option.sampleRate = 0.5; %For additional run-time speed up. can be betwee
%0.001 ~ 1 (percentage), the smaller number the
%faster, but may be less accurate. our experiment
%on segTrack v2 showed that accuracy did not vary
%when set at 0.01, with 2x additional speed-up.
option.subVolume = 4; %how many sub-volumes to split the video for processing.
%can be any positive integether, 1 means no splitting
%into sub-volumes. recommanded is to use 4 or 8 for a
%85-frame video, 4 for shorter videos (< 50 frames)
%and 8 for longer.
option.useMotion = 0; %1 or 0 for using motion feature or not. if set to 1,
%make sure the pre-extracted motion optic flow .mat
%follows the same format as the provided bmx.mat file.
%we used [22] as our optic flow feature, code can be
%found here: http://cs.brown.edu/people/dqsun/research/software.html
%under 'matlab code for method in our cvpr 2010'.
%without motion is preferrable, as optic flow is
%expensive to compute, and our result did not show an
%advantage when optic-flow feature was used.
option.fitMethod = 2; %1 = MLE, 2 = nonlinear least square (NLS). MLE tend
%to produce less spatio-temporal segments, while NLS
%produces more detailed segmentation.
option.toShow = 0; %1 or 0, set to 1 will display lots of intermediate model
%fitting results, mostly for debugging.
option.useGeo= 0;
option.dataset = 1;  %1:segtrack,%2:chen

switch option.dataset
    case 1
        
        names ={'bird_of_paradise','birdfall','bmx','cheetah','drift','frog','girl','hummingbird','monkey','monkeydog','parachute','penguin','soldier','worm'};
        name = names{id}
        
        dataset.dir = '../../../video/Seg/JPEGImages/';
        
        option.inputDIR = [dataset.dir,name,'/']; %the directory that contains the input rgb frames.
        option.motionMat = ['./data/SegTrackv2/motions/',name]; %the optic-flow file, set as [] if not using motion.
        option.outputDIR = ['./output/Segtrack/',name]; %output directory that saves the segmented frames in labels.
        %if you don't want to automatically save
        %the output segmentation frames, set this
        savepath = ['../../../ICCV2015res/Segtrack/'];
        if ~exist(savepath)
            mkdir(savepath)
        end;
        outputs = pgpMain2(option);
        thesegmentation = outputs{1};
        savename= ['BL_', num2str(option.numSP),'_',name];
        save([savepath,savename], 'thesegmentation');
            
    case 2
        names ={'bus_fa','container_fa','garden_fa','ice_fa','paris_fa','soccer_fa','salesman_fa','stefan_fa'};
        name = names{id}
        
        dataset.dir = '../../../video/chen/input/PNG/';
        
        option.inputDIR = [dataset.dir,name,'/']; %the directory that contains the input rgb frames.
        option.motionMat = ['./data/Chen_Xiph.org/motions/',name]; %the optic-flow file, set as [] if not using motion.
        option.outputDIR = ['./output/chen/',name]; %output directory that saves the segmented frames in labels.
        %if you don't want to automatically save
        %the output segmentation frames, set this
        savepath = ['../../../ICCV2015res/chen/'];
        if ~exist(savepath)
            mkdir(savepath)
        end;
        savename= ['BL_', num2str(option.numSP),'_',name];
        outputs = pgpMain2(option);
        thesegmentation = outputs{1};
        save([savepath,savename], 'thesegmentation');
end;   
end

