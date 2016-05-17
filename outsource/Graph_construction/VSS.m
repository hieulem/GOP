function VSS(theswitch,varargin)
% VSS('vw_commercial_21f','ucm2level','30','uselevelfrw', '1', 'ucm2levelfrw', '1', 'newmethodfrw', '1', 'stpcas', 'paperoptnrm');

%when running the algorithm for other sequences one must pass to
%Getfilenames the directory name (in the files where the Getfilenames is used, indicated in Getfilenames)
%Below the basename for the segmentation files  and the noFrames must also
%be changed

%This computes all the variable for the sequence and save them in the
%files defined in filenames

%Reduce size of video frames
%Set up for galassoandfriends
%cleanifexisting Inf, used to rerun failed cases
%compiled with recursion 100
% clear all

addpath(genpath('./sup_code'));
addpath(genpath('./Learn_affinities'));

if (~isdeployed)
    Setthepath();
end

basedrive=['.',filesep]; %Directory where the VideoProcessingTemp dir is located


options.newucmtwo=true;
options.trajectories=false; options.recallprecision=false; options.useallobjects=1; %1 all (for recallprecision), 2 allin (for statistics and bmetric)
options.cleanifexisting=Inf; options.quickshift=false; options.origucm2=false;
options.usebflow=false; options.pre_filter_flow=true; options.filter_flow=true;



%Test options
options.testthesegmentation=false; options.segaddname='Ucm'; %Berkeley benchmark and ours to test image segmentation parameters
options.testmanifoldclustering=true; options.clustaddname='Cfstltifeff'; %Our metric to plot global and average recall and precision
options.testbmetric=false; options.broxmetricsname='Bmcfstltifeff'; options.broxmetriccases=[1,2,3,4,5,6,7,8,9,10,20]; %Use the Brox benchmark on one video segmentation (default nclusters=10,20)
options.testnewsegmentation=true; options.newsegname='Segmcfstltifefff'; %Use the Berkeley benchmark for the superposed video segmentations
options.calibratetheparameters=false; options.calibrateparametersname='Paramcfstltifefff'; %Gather row values and test affinity transformations
options.evalhigherorder=false; options.higherorderdir='Hocfstltifeff'; %Higher order segmentation of superpixel trajectories
options.mergehigherorder=false; options.mergehigherdir='Mhocfstltifeff'; %Merge higher order trajectories and large superpixels into the affinity matrix
options.proplabels=false; options.proplabelsdir='Pcfstltifeff'; %Propagate labels in video sequences
options.savefortraining=false; options.trainingdir='Traincfstltifefffssvlt'; %Gather raw values and ground truth
options.userf=false; options.rfaffinity='Trainedcfstltifefffssvlt.mat'; %Rf trained trees for affinity computation
options.saveaff=false; options.affaddname='Afffstltifeff'; %Computed affinity is saved, both 2-affinity and higher order



%Additional options (here the default values)
% options.stpcas='paperoptnrm'; %rpcbest,bkbbest,paper,paperopt,paperoptnrm,optvlt
% options.requestedaffinities={'stt','ltt','aba','abm','stm','sta','vltti'};
% options.lttuexp=false; options.lttlambd=1; options.lttsqv=false;
% options.abauexp=false; options.abalambd=13; options.abasqv=false; options.abathmax=true;
% options.sttuexp=false; options.sttlambd=1; options.sttsqv=false;
% options.stasqv=true; options.starefv=0.005; options.staavf=true; options.stalmbd=true;
% options.abmrefv=1.0; options.abmpfour=false; options.abmlmbd=true;
% options.stmrefv=1.0; options.stmavf=true; options.stmlmbd=true;
% options.faffinityv=[]; options.ucm2level=[];
% options.mrgmth='prod'; options.mrgwgt=ones(1,6);
% options.complrqst=false;
% options.normalize=false; options.normalisezeroone=false;
% options.uselevelfrw=false; options.ucm2levelfrw=1; options.newmethodfrw=true; %newmethodfrw: true our method for re-weighting, false method of Hein
% options.vsmethod='affinities'; %'affinities'(default), 'hgb'(Grundmann), 'hgbs'(hgb streaming), 'gb'(Feltenszwalb), 'swa'(Corso), 'spo'(Ochs ho), 'sponz'(Ochs ho), 'dobho'(Ochs ho), 'spb'(Brox), 'spbnz'(Brox), 'dob'(Ochs), 'GTCase', 'bln' baseline, 'onelabelvideo'
% options.GTNum=1; options.neglectgt=[]; %GT annotations to consider in GTCase and to neglect
% options.blnnlev=51; options.blnstflow=0; options.blnthr=0.1; options.blnraf=false; %baseline setup options: blnnlev sets how many sampling from ucm2, blnstflow is 0 by default, blnthr is threshold to re-init clusters
% options.clustcompnumbers=[2,5,10]; options.manifoldclustermethod='km3'; %'km','km3','litekm','km3new','yaelkm','dbscan','optics', used in combination with 'manifoldcl'
% options.htwind=5; options.hallowdist=6; options.husesparse=true; options.hnlayers=2; options.holambda=0.1;
% options.mhspx=true; options.mhtracks=true; options.mhlarge=true;
% options.mhmthd=1; %mhmthd: 1 cl exp, 2 point exp, 3 clique expansion complete, 4 cl exp comp norm, 5 cl exp comp norm and renorm, 6 feat exp, 7 cl exp comp star exp, 8 cl exp comp star exp weight, 9 cl exp more weight, 10 cl exp comp weight, 11 cl exp even more weight, 12 cl exp sum, 13 cl exp comp no averaging (function with averaging coincides with method 3)
% options.whlrgsgm=[20]; options.mcmbmth=1; options.hmrgwgt=[1,1,1]; %mcmbmth: 1 prod, 2 wsum, 3 wsumz; hmrgwgt = [spx, spx track, large spx] affinities
% options.mhspx2highr=[0.6,0.6]; options.skipmergeframes=[]; %mhspx2highr=[region tracks, large spx], skipmergeframes=[3:2:100]
% options.mhkeepkneigh=[]; options.mhkeepkglob=[]; options.mhkeepkglobrnd=[]; %mhkeepkglob=[track glob k, large spx glob k (these may be various)]
% options.plwhmaxframe=[]; options.pltwwidth=[]; options.ploverlap=[]; options.plusehorder=true; %The merged or simplesolution is propagated to (plwhmaxframe-faffinityv) frames, up to frame plwhmaxframe; pltwwidth expresses the window size
% options.plincrement=options.pltwwidth-options.ploverlap; %plincrement is the number of frames to consider from the new ones included
% options.plalpha=0.95; options.pliterations=100; options.plremove=0; %plalpha states the weight of novelty (1 means 0 weight on init values); plremove remove from provided solution
% options.plmethod=1; options.plmergelabequiv=true; %1 label propagation from Zhou et al., 2 graph reduction, 3 method of Zhou et al. with equivalence
% options.plncincrease=[]; options.pluseoverhp=false; %plncincrease pos increases n clusters at each iteration (int or float for factor), [] already existing nclusters, neg fixed nclusters; pluseoverhp for using over complete hps
% options.plinitframesall=0; %plinitframesall number of initial frames are superpixels
% options.plrwusenewmethod=false; %method to use for graph reduction, true implies new method (density normalized)
% options.plmultiplicity=false; options.plseed=false; %plmultiplicity indicates whether the label count should be used, plseed allows initialization with previous clusters



%Options related to learning
options.d_for_likelihood=false;
options.cluster=false; options.statistics=false; options.bmetric=false; options.bmergeb=true; options.bvote=false;
options.regiongrow=false;
options.rffilename='newtrainedrandomforest5to19_300mns0d0006p_bmgroups12percentagege20.mat';
options.minLength=5; options.trackLength=19;
options.idxpicsandvideocode='bm0d0006p';
% options.idxpicsandvideocode='bm36';
% options.rffilename='newtrainedrandomforest5to33_300mns0d0008p_raz678sotosotobis10shi1234percentagege20.mat';
% options.minLength=5; options.trackLength=33;
% options.idxpicsandvideocode='0d0008p';
% options.rffilename='trainedrandomforest_300mns36and10_raz678sotosotobis10shi1234_5to33_percentagege20.mat';
% options.minLength=5; options.trackLength=17;
% options.idxpicsandvideocode='tsxten';
% options.rffilename='newtrainedrandomforest5to17_300mns0d0003_raz678sotosotobis10shi1234percentagege20.mat';



if ( (exist('varargin','var')) && (~isempty(varargin)) ) %varargin should contain pairs (opfieldname,opfieldcontent)
    numvarargin=numel(varargin);                         %opfieldname is a string
    if ((mod(numvarargin,2))==0)                         %opfieldname is a string containing numbers or array ('1' or '[1,2,3]')
        for i=1:floor(numvarargin/2)
            options.(varargin{(i-1)*2+1})=str2num(varargin{(i-1)*2+2}); %#ok<ST2NM>
            if (isempty(options.(varargin{(i-1)*2+1})))
                options.(varargin{(i-1)*2+1})=varargin{(i-1)*2+2}; %opfieldname may contain strings ('{stt,ltt,aba,abm,stm,sta}')
                options=Adjustcellarrays(options,(varargin{(i-1)*2+1})); %Parse strings to transform into cell arrays
            end
        end
    else
        fprintf('Additional otpions not recognized\n');
    end
end



%Apply options specified in options.stpcas (this does not overwrite the single options)
if ( (~isfield(options,'stpcas')) || (isempty(options.stpcas)) ) %This sets the default parameters
    options.stpcas='paperoptnrm'; %rpcbest,bkbbest,paper,paperopt,paperoptnrm,optvlt
end

%Apply options for must-links
if ( (~isfield(options,'within')) || (isempty(options.within)) ) %This sets the default parameters
    options.within=1;
end
if ( (~isfield(options,'across1')) || (isempty(options.across1)) ) %This sets the default parameters
    options.across1=1;
end
if ( (~isfield(options,'across2')) || (isempty(options.across2)) ) %This sets the default parameters
    options.across2=1;
end
if ( (~isfield(options,'across_2')) || (isempty(options.across_2)) ) %This sets the default parameters
    options.across_2=1;
end
if ( (~isfield(options,'wthreshold')) || (isempty(options.wthreshold)) ) %This sets the default parameters
    options.wthreshold=.91;
end
if ( (~isfield(options,'a1threshold')) || (isempty(options.a1threshold)) ) %This sets the default parameters
    options.a1threshold=.97;
end
if ( (~isfield(options,'a2threshold')) || (isempty(options.a2threshold)) ) %This sets the default parameters
    options.a2threshold=.97;
end
if ( (~isfield(options,'a_2threshold')) || (isempty(options.a_2threshold)) ) %This sets the default parameters
    options.a_2threshold=.97;
end
if ( (~isfield(options,'scmethod')) || (isempty(options.scmethod)) ) %This sets the default parameters
    options.scmethod='adhoc';
end

options=Applysetupcase(options);
options %#ok<NOPRT>



switch(theswitch)

     case 'vw_commercial_21f'
%%%vw_commercial
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'vw_commercial',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'vw_commercial',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'vw_commercial',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=79;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'vw_commercial',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'vw_commercial',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'vw_commercial',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=79;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'vw_commercial');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=21;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Tud_cross_seq'
%%%Tud_cross_seq
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Tud_cross_seq',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Tud_cross_seq',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Tud_cross_seq',filesep,'origimages',filesep,'DaSide0811-seq7-'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Tud_cross_seq',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Tud_cross_seq',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Tud_cross_seq',filesep,'gtimages',filesep,'image_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%03d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Tud_cross_seq');
filename_sequence_basename_frames_or_video.bgcode=[0,0,0]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255]; %[1x3 colour; otherobjects] _;26;51

noFrames=201;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'alec_baldwin'
%%%alec_baldwin
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'alec_baldwin',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'alec_baldwin',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'alec_baldwin',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=120;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'alec_baldwin',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'alec_baldwin',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'alec_baldwin',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=120;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'alec_baldwin');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=101;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
      case 'alec_baldwin_toy'
%%%alec_baldwin
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'alec_baldwin',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'alec_baldwin',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'alec_baldwin',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=160;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'alec_baldwin',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'alec_baldwin',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'alec_baldwin',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=160;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'alec_baldwin');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=6;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
      
    
    case 'anteater'
%%%anteater
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'anteater',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'anteater',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'anteater',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'anteater',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'anteater',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'anteater',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'anteater');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'avalanche'
%%%avalanche
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'avalanche',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'avalanche',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'avalanche',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=120;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'avalanche',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'avalanche',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'avalanche',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=120;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'avalanche');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'big_wheel'
%%%big_wheel
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'big_wheel',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'big_wheel',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'big_wheel',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=48;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'big_wheel',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'big_wheel',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'big_wheel',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=48;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'big_wheel');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=97;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'bowling'
%%%bowling
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'bowling',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'bowling',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'bowling',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'bowling',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'bowling',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'bowling',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'bowling');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'campanile'
%%%campanile
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'campanile',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'campanile',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'campanile',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'campanile',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'campanile',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'campanile',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'campanile');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'car_jump'
%%%car_jump
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'car_jump',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'car_jump',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'car_jump',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=12;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'car_jump',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'car_jump',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'car_jump',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=12;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'car_jump');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'chrome'
%%%chrome
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'chrome',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'chrome',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'chrome',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=12;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'chrome',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'chrome',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'chrome',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=12;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'chrome');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'deoksugung'
%%%deoksugung
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'deoksugung',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'deoksugung',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'deoksugung',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'deoksugung',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'deoksugung',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'deoksugung',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'deoksugung');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'dominoes'
%%%dominoes
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'dominoes',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'dominoes',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'dominoes',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'dominoes',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'dominoes',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'dominoes',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'dominoes');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'drone'
%%%drone
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'drone',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'drone',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'drone',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'drone',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'drone',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'drone',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'drone');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'excavator'
%%%excavator
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'excavator',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'excavator',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'excavator',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'excavator',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'excavator',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'excavator',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'excavator');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'floorhockey'
%%%floorhockey
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'floorhockey',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'floorhockey',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'floorhockey',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=15;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'floorhockey',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'floorhockey',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'floorhockey',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=15;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'floorhockey');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'galapagos'
%%%galapagos
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'galapagos',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'galapagos',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'galapagos',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=81;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'galapagos',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'galapagos',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'galapagos',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=81;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'galapagos');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=64;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'gray_squirrel'
%%%gray_squirrel
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'gray_squirrel',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'gray_squirrel',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'gray_squirrel',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=5;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'gray_squirrel',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'gray_squirrel',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'gray_squirrel',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=5;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'gray_squirrel');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'guitar'
%%%guitar
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'guitar',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'guitar',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'guitar',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=120;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'guitar',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'guitar',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'guitar',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=120;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'guitar');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'hippo_fight'
%%%hippo_fight
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'hippo_fight',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'hippo_fight',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'hippo_fight',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=15;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'hippo_fight',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'hippo_fight',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'hippo_fight',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=15;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'hippo_fight');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'horse_riding'
%%%horse_riding
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'horse_riding',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'horse_riding',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'horse_riding',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=15;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'horse_riding',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'horse_riding',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'horse_riding',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=15;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'horse_riding');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'juggling'
%%%juggling
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'juggling',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'juggling',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'juggling',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=110;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'juggling',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'juggling',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'juggling',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=110;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'juggling');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'kia_commercial'
%%%kia_commercial
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'kia_commercial',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'kia_commercial',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'kia_commercial',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=50;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'kia_commercial',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'kia_commercial',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'kia_commercial',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=50;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'kia_commercial');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=52;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'knot'
%%%knot
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'knot',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'knot',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'knot',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=120;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'knot',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'knot',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'knot',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=120;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'knot');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'lion'
%%%lion
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'lion',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'lion',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'lion',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=28;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'lion',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'lion',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'lion',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=28;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'lion');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'liontwo'
%%%liontwo
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'liontwo',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'liontwo',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'liontwo',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'liontwo',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'liontwo',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'liontwo',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'liontwo');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
      case 'liontwo2'
%%%liontwo
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'liontwo2',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'liontwo2',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'liontwo2',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'liontwo2',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'liontwo',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'liontwo2',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'liontwo');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'lukla_airport'
%%%lukla_airport
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'lukla_airport',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'lukla_airport',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'lukla_airport',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'lukla_airport',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'lukla_airport',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'lukla_airport',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'lukla_airport');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'pouring_tea'
%%%pouring_tea
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'pouring_tea',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'pouring_tea',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'pouring_tea',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'pouring_tea',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'pouring_tea',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'pouring_tea',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'pouring_tea');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'rock_climbing_tr'
%%%rock_climbing_tr
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'rock_climbing_tr',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbing_tr',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbing_tr',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=48;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbing_tr',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbing_tr',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbing_tr',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=48;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'rock_climbing_tr');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=61;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'roller_coaster'
%%%roller_coaster
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'roller_coaster',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'roller_coaster',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'roller_coaster',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'roller_coaster',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'roller_coaster',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'roller_coaster',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'roller_coaster');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=105;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'rolling_pin'
%%%rolling_pin
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'rolling_pin',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'rolling_pin',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'rolling_pin',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'rolling_pin',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'rolling_pin',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'rolling_pin',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'rolling_pin');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'sailing'
%%%sailing
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'sailing',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'sailing',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'sailing',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=9;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'sailing',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'sailing',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'sailing',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=9;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'sailing');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=117;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'sea_snake'
%%%sea_snake
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'sea_snake',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'sea_snake',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'sea_snake',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=15;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'sea_snake',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'sea_snake',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'sea_snake',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=15;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'sea_snake');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'sea_turtle'
%%%sea_turtle
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'sea_turtle',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'sea_turtle',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'sea_turtle',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'sea_turtle',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'sea_turtle',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'sea_turtle',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'sea_turtle');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'sitting_dog'
%%%sitting_dog
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'sitting_dog',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'sitting_dog',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'sitting_dog',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=43;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'sitting_dog',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'sitting_dog',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'sitting_dog',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=43;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'sitting_dog');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=80;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'snow_shoes'
%%%snow_shoes
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'snow_shoes',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'snow_shoes',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'snow_shoes',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=5;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'snow_shoes',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'snow_shoes',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'snow_shoes',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=5;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'snow_shoes');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'soccer'
%%%soccer
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'soccer',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'soccer',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'soccer',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'soccer',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'soccer',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'soccer',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'soccer');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'space_shuttle'
%%%space_shuttle
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'space_shuttle',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'space_shuttle',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'space_shuttle',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'space_shuttle',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'space_shuttle',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'space_shuttle',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'space_shuttle');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'swing'
%%%swing
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'swing',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'swing',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'swing',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'swing',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'swing',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'swing',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'swing');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'tarantula'
%%%tarantula
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'tarantula',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'tarantula',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'tarantula',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=60;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'tarantula',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'tarantula',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'tarantula',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=60;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'tarantula');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'tennis_tr'
%%%tennis_tr
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'tennis_tr',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'tennis_tr',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'tennis_tr',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=15;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'tennis_tr',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'tennis_tr',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'tennis_tr',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=15;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'tennis_tr');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'trampoline'
%%%trampoline
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'trampoline',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'trampoline',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'trampoline',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'trampoline',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'trampoline',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'trampoline',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'trampoline');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'zoo'
%%%zoo
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'zoo',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'zoo',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'zoo',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=66;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'zoo',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'zoo',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'zoo',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=66;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'zoo');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=90;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'airplane'
%%%airplane
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'airplane',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'airplane',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'airplane',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=63;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'airplane',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'airplane',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'airplane',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=63;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'airplane');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'angkor_wat'
%%%angkor_wat
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'angkor_wat',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'angkor_wat',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'angkor_wat',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=66;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'angkor_wat',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'angkor_wat',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'angkor_wat',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=66;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'angkor_wat');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'animal_chase'
%%%animal_chase
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'animal_chase',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'animal_chase',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'animal_chase',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=103;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'animal_chase',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'animal_chase',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'animal_chase',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=103;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'animal_chase');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'arctic_kayak'
%%%arctic_kayak
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'arctic_kayak',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'arctic_kayak',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'arctic_kayak',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=82;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'arctic_kayak',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'arctic_kayak',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'arctic_kayak',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=82;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'arctic_kayak');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=50;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'ballet'
%%%ballet
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'ballet',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'ballet',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'ballet',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=45;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'ballet',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'ballet',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'ballet',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=45;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'ballet');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=87;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'baseball'
%%%baseball
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'baseball',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'baseball',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'baseball',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=110;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'baseball',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'baseball',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'baseball',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=110;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'baseball');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'beach_volleyball'
%%%beach_volleyball
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'beach_volleyball',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'beach_volleyball',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'beach_volleyball',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=101;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'beach_volleyball',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'beach_volleyball',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'beach_volleyball',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=101;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'beach_volleyball');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'belly_dancing'
%%%belly_dancing
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'belly_dancing',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'belly_dancing',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'belly_dancing',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=54;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'belly_dancing',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'belly_dancing',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'belly_dancing',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=54;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'belly_dancing');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'beyonce'
%%%beyonce
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'beyonce',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'beyonce',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'beyonce',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=60;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'beyonce',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'beyonce',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'beyonce',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=60;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'beyonce');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'bicycle_race'
%%%bicycle_race
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'bicycle_race',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'bicycle_race',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'bicycle_race',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=68;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'bicycle_race',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'bicycle_race',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'bicycle_race',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=68;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'bicycle_race');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'birds_of_paradise'
%%%birds_of_paradise
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'birds_of_paradise',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'birds_of_paradise',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'birds_of_paradise',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=102;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'birds_of_paradise',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'birds_of_paradise',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'birds_of_paradise',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=102;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'birds_of_paradise');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=79;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'buck'
%%%buck
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'buck',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'buck',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'buck',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=68;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'buck',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'buck',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'buck',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=68;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'buck');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'buffalos'
%%%buffalos
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'buffalos',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'buffalos',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'buffalos',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=101;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'buffalos',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'buffalos',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'buffalos',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=101;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'buffalos');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'capoeira'
%%%capoeira
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'capoeira',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'capoeira',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'capoeira',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=108;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'capoeira',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'capoeira',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'capoeira',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=108;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'capoeira');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'chameleons'
%%%chameleons
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'chameleons',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'chameleons',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'chameleons',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=76;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'chameleons',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'chameleons',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'chameleons',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=76;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'chameleons');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'fish_underwater'
%%%fish_underwater
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'fish_underwater',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'fish_underwater',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'fish_underwater',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=60;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'fish_underwater',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'fish_underwater',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'fish_underwater',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=60;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'fish_underwater');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=91;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'fisheye'
%%%fisheye
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'fisheye',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'fisheye',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'fisheye',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=36;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'fisheye',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'fisheye',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'fisheye',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=36;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'fisheye');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'freight_train'
%%%freight_train
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'freight_train',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'freight_train',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'freight_train',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=8;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'freight_train',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'freight_train',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'freight_train',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=8;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'freight_train');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=113;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'frozen_lake'
%%%frozen_lake
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'frozen_lake',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'frozen_lake',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'frozen_lake',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=30;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'frozen_lake',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'frozen_lake',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'frozen_lake',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=30;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'frozen_lake');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'gokart'
%%%gokart
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'gokart',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'gokart',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'gokart',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=45;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'gokart',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'gokart',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'gokart',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=45;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'gokart');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'harley_davidson'
%%%harley_davidson
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'harley_davidson',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'harley_davidson',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'harley_davidson',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'harley_davidson',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'harley_davidson',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'harley_davidson',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'harley_davidson');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=69;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'hockey'
%%%hockey
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'hockey',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'hockey',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'hockey',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=60;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'hockey',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'hockey',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'hockey',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=60;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'hockey');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'hockey_goals'
%%%hockey_goals
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'hockey_goals',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'hockey_goals',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'hockey_goals',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=82;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'hockey_goals',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'hockey_goals',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'hockey_goals',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=82;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'hockey_goals');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=99;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'horse_gate'
%%%horse_gate
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'horse_gate',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'horse_gate',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'horse_gate',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=133;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'horse_gate',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'horse_gate',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'horse_gate',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=133;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'horse_gate');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=103;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'hummingbird'
%%%hummingbird
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'hummingbird',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'hummingbird',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'hummingbird',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=58;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'hummingbird',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'hummingbird',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'hummingbird',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=58;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'hummingbird');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'humpback'
%%%humpback
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'humpback',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'humpback',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'humpback',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=43;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'humpback',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'humpback',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'humpback',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=43;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'humpback');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'jungle_cat'
%%%jungle_cat
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'jungle_cat',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'jungle_cat',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'jungle_cat',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=71;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'jungle_cat',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'jungle_cat',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'jungle_cat',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=71;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'jungle_cat');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=87;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'kangaroo_fighting'
%%%kangaroo_fighting
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'kangaroo_fighting',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'kangaroo_fighting',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'kangaroo_fighting',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=77;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'kangaroo_fighting',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'kangaroo_fighting',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'kangaroo_fighting',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=77;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'kangaroo_fighting');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'kim_yu_na'
%%%kim_yu_na
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'kim_yu_na',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'kim_yu_na',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'kim_yu_na',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=64;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'kim_yu_na',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'kim_yu_na',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'kim_yu_na',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=64;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'kim_yu_na');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=117;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'koala'
%%%koala
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'koala',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'koala',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'koala',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=63;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'koala',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'koala',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'koala',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=63;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'koala');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=116;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'monkeys_behind_fence'
%%%monkeys_behind_fence
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'monkeys_behind_fence',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'monkeys_behind_fence',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'monkeys_behind_fence',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'monkeys_behind_fence',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'monkeys_behind_fence',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'monkeys_behind_fence',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'monkeys_behind_fence');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=114;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'nba_commercial'
%%%nba_commercial
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'nba_commercial',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'nba_commercial',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'nba_commercial',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=43;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'nba_commercial',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'nba_commercial',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'nba_commercial',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=43;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'nba_commercial');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'new_york'
%%%new_york
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'new_york',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'new_york',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'new_york',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=44;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'new_york',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'new_york',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'new_york',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=44;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'new_york');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'nordic_skiing'
%%%nordic_skiing
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'nordic_skiing',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'nordic_skiing',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'nordic_skiing',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=87;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'nordic_skiing',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'nordic_skiing',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'nordic_skiing',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=87;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'nordic_skiing');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'octopus'
%%%octopus
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'octopus',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'octopus',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'octopus',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=101;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'octopus',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'octopus',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'octopus',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=101;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'octopus');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'palm_tree'
%%%palm_tree
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'palm_tree',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'palm_tree',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'palm_tree',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=80;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'palm_tree',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'palm_tree',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'palm_tree',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=80;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'palm_tree');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'panda'
%%%panda
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'panda',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'panda',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'panda',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=61;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'panda',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'panda',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'panda',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=61;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'panda');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'panda_cub'
%%%panda_cub
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'panda_cub',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'panda_cub',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'panda_cub',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=51;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'panda_cub',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'panda_cub',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'panda_cub',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=51;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'panda_cub');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'penguins'
%%%penguins
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'penguins',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'penguins',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'penguins',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'penguins',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'penguins',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'penguins',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'penguins');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=94;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'pepsis_wasps'
%%%pepsis_wasps
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'pepsis_wasps',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'pepsis_wasps',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'pepsis_wasps',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=60;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'pepsis_wasps',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'pepsis_wasps',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'pepsis_wasps',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=60;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'pepsis_wasps');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'planet_earth_one'
%%%planet_earth_one
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'planet_earth_one',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'planet_earth_one',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'planet_earth_one',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=60;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'planet_earth_one',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'planet_earth_one',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'planet_earth_one',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=60;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'planet_earth_one');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=68;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'planet_earth_two'
%%%planet_earth_two
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'planet_earth_two',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'planet_earth_two',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'planet_earth_two',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=91;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'planet_earth_two',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'planet_earth_two',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'planet_earth_two',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=91;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'planet_earth_two');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=90;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'riverboat'
%%%riverboat
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'riverboat',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'riverboat',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'riverboat',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=41;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'riverboat',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'riverboat',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'riverboat',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=41;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'riverboat');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=104;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'rock_climbing'
%%%rock_climbing
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'rock_climbing',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbing',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbing',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=100;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbing',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbing',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbing',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=100;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'rock_climbing');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=31;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'rock_climbingtwo'
%%%rock_climbingtwo
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'rock_climbingtwo',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbingtwo',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbingtwo',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=103;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbingtwo',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbingtwo',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'rock_climbingtwo',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=103;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'rock_climbingtwo');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=90;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'salsa'
%%%salsa
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'salsa',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'salsa',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'salsa',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=40;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'salsa',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'salsa',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'salsa',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=40;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'salsa');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'samba_kids'
%%%samba_kids
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'samba_kids',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'samba_kids',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'samba_kids',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=78;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'samba_kids',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'samba_kids',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'samba_kids',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=78;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'samba_kids');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'shark_attack'
%%%shark_attack
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'shark_attack',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'shark_attack',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'shark_attack',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=15;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'shark_attack',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'shark_attack',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'shark_attack',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=15;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'shark_attack');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'sled_dog_race'
%%%sled_dog_race
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'sled_dog_race',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'sled_dog_race',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'sled_dog_race',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=86;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'sled_dog_race',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'sled_dog_race',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'sled_dog_race',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=86;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'sled_dog_race');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'slow_polo'
%%%slow_polo
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'slow_polo',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'slow_polo',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'slow_polo',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=64;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'slow_polo',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'slow_polo',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'slow_polo',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=64;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'slow_polo');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'snow_leopards'
%%%snow_leopards
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'snow_leopards',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'snow_leopards',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'snow_leopards',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=76;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'snow_leopards',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'snow_leopards',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'snow_leopards',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=76;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'snow_leopards');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'snowboarding'
%%%snowboarding
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'snowboarding',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'snowboarding',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'snowboarding',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=60;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'snowboarding',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'snowboarding',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'snowboarding',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=60;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'snowboarding');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'snowboarding_crashes'
%%%snowboarding_crashes
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'snowboarding_crashes',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'snowboarding_crashes',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'snowboarding_crashes',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=84;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'snowboarding_crashes',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'snowboarding_crashes',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'snowboarding_crashes',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=84;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'snowboarding_crashes');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=109;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'street_food'
%%%street_food
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'street_food',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'street_food',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'street_food',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=18;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'street_food',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'street_food',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'street_food',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=18;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'street_food');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=106;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'swimming'
%%%swimming
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'swimming',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'swimming',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'swimming',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=60;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'swimming',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'swimming',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'swimming',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=60;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'swimming');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'up_dug'
%%%up_dug
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'up_dug',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'up_dug',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'up_dug',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=97;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'up_dug',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'up_dug',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'up_dug',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=97;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'up_dug');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=97;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'up_trailer'
%%%up_trailer
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'up_trailer',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'up_trailer',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'up_trailer',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=61;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'up_trailer',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'up_trailer',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'up_trailer',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=61;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'up_trailer');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=94;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'vw_commercial'
%%%vw_commercial
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'vw_commercial',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'vw_commercial',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'vw_commercial',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=79;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'vw_commercial',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'vw_commercial',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'vw_commercial',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=79;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'vw_commercial');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=46;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'white_tiger'
%%%white_tiger
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'white_tiger',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'white_tiger',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'white_tiger',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=80;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'white_tiger',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'white_tiger',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'white_tiger',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=80;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'white_tiger');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'yosemite'
%%%yosemite
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'yosemite',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'yosemite',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'yosemite',filesep,'origimages',filesep,'image'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=92;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'yosemite',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'yosemite',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'yosemite',filesep,'gtimages',filesep,'gtimages_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.png';
filename_sequence_basename_frames_or_video.gtstartNumber=92;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'yosemite');
%filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
%    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=121;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm1'
%%%Newnorm1
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm1',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm1',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm1',filesep,'origimages',filesep,'friends_season1_disc1_1-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00007703;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm1',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm1',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm1',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm1');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=59; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm2'
%%%Newnorm2
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm2',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm2',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm2',filesep,'origimages',filesep,'friends_season1_disc1_1-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00008276;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm2',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm2',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm2',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm2');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm3'
%%%Newnorm3
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm3',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm3',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm3',filesep,'origimages',filesep,'friends_season1_disc1_1-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00009958;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm3',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm3',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm3',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm3');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm4'
%%%Newnorm4
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm4',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm4',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm4',filesep,'origimages',filesep,'friends_season1_disc1_1-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00028477;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm4',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm4',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm4',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm4');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm5'
%%%Newnorm5
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm5',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm5',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm5',filesep,'origimages',filesep,'friends_season1_disc1_1-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00028537;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm5',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm5',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm5',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm5');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm6'
%%%Newnorm6
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm6',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm6',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm6',filesep,'origimages',filesep,'friends_season1_disc1_1-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00028597;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm6',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm6',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm6',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm6');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm7'
%%%Newnorm7
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm7',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm7',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm7',filesep,'origimages',filesep,'friends_season1_disc1_1-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00028657;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm7',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm7',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm7',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm7');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=19; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm8'
%%%Newnorm8
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm8',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm8',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm8',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00017981;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm8',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm8',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm8',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm8');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm9'
%%%Newnorm9
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm9',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm9',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm9',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00018041;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm9',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm9',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm9',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm9');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm10'
%%%Newnorm10
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm10',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm10',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm10',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00017981;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm10',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm10',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm10',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm10');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm11'
%%%Newnorm11
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm11',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm11',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm11',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00018041;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm11',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm11',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm11',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm11');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm12'
%%%Newnorm12
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm12',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm12',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm12',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00018336;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm12',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm12',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm12',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm12');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm13'
%%%Newnorm13
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm13',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm13',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm13',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00018396;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm13',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm13',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm13',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm13');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm14'
%%%Newnorm14
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm14',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm14',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm14',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00018456;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm14',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm14',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm14',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm14');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm15'
%%%Newnorm15
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm15',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm15',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm15',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00018516;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm15',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm15',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm15',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm15');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm16'
%%%Newnorm16
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm16',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm16',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm16',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00018576;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm16',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm16',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm16',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm16');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm17'
%%%Newnorm17
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm17',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm17',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm17',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00018636;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm17',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm17',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm17',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm17');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm18'
%%%Newnorm18
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm18',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm18',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm18',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00018696;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm18',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm18',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm18',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm18');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm19'
%%%Newnorm19
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm19',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm19',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm19',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00018756;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm19',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm19',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm19',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm19');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm20'
%%%Newnorm20
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm20',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm20',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm20',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00018816;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm20',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm20',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm20',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm20');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm21'
%%%Newnorm21
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm21',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm21',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm21',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00018876;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm21',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm21',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm21',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm21');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm22'
%%%Newnorm22
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm22',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm22',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm22',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00018936;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm22',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm22',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm22',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm22');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=30; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm23'
%%%Newnorm23
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm23',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm23',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm23',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00021224;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm23',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm23',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm23',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm23');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm24'
%%%Newnorm24
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm24',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm24',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm24',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00021284;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm24',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm24',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm24',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm24');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm25'
%%%Newnorm25
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm25',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm25',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm25',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00021344;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm25',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm25',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm25',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm25');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm26'
%%%Newnorm26
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm26',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm26',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm26',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00021404;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm26',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm26',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm26',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm26');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm27'
%%%Newnorm27
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm27',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm27',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm27',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00021464;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm27',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm27',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm27',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm27');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm28'
%%%Newnorm28
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm28',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm28',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm28',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00029362;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm28',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm28',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm28',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm28');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm29'
%%%Newnorm29
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm29',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm29',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm29',filesep,'origimages',filesep,'friends_season1_disc1_3-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00029422;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm29',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm29',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm29',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm29');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm30'
%%%Newnorm30
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm30',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm30',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm30',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00000939;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm30',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm30',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm30',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm30');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm31'
%%%Newnorm31
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm31',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm31',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm31',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00000999;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm31',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm31',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm31',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm31');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm32'
%%%Newnorm32
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm32',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm32',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm32',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00003550;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm32',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm32',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm32',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm32');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm33'
%%%Newnorm33
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm33',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm33',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm33',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00004107;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm33',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm33',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm33',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm33');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm34'
%%%Newnorm34
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm34',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm34',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm34',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00004167;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm34',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm34',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm34',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm34');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm35'
%%%Newnorm35
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm35',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm35',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm35',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00004227;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm35',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm35',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm35',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm35');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm36'
%%%Newnorm36
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm36',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm36',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm36',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00013257;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm36',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm36',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm36',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm36');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=54; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm37'
%%%Newnorm37
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm37',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm37',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm37',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00029560;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm37',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm37',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm37',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm37');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm38'
%%%Newnorm38
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm38',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm38',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm38',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00029620;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm38',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm38',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm38',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm38');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=30; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm39'
%%%Newnorm39
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm39',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm39',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm39',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00033988;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm39',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm39',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm39',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm39');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm40'
%%%Newnorm40
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm40',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm40',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm40',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00034048;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm40',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm40',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm40',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm40');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm41'
%%%Newnorm41
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm41',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm41',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm41',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00034108;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm41',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm41',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm41',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm41');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=30; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm42'
%%%Newnorm42
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm42',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm42',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm42',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00036636;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm42',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm42',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm42',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm42');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm43'
%%%Newnorm43
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm43',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm43',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm43',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00036696;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm43',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm43',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm43',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm43');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Newnorm44'
%%%Newnorm44
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Newnorm44',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm44',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm44',filesep,'origimages',filesep,'friends_season1_disc1_4-'];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.png';
filename_sequence_basename_frames_or_video.startNumber=00036756;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm44',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm44',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Newnorm44',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Newnorm44');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
    
    
    case 'Shotfull1'
%%%Shotfull1
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull1',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull1',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull1',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull1',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull1',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull1',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull1');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotfull2'
%%%Shotfull2
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull2',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull2',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull2',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull2',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull2',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull2',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull2');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %66;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotfull3'
%%%Shotfull3
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull3',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull3',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull3',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull3',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull3',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull3',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull3');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %62;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotfull4'
%%%Shotfull4
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull4',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull4',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull4',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull4',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull4',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull4',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull4');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %130; %200
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotfull5'
%%%Shotfull5
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull5',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull5',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull5',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull5',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull5',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull5',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull5');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %123;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotfull6'
%%%Shotfull6
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull6',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull6',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull6',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull6',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull6',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull6',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull6');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %130; %632
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotfull7'
%%%Shotfull7
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull7',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull7',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull7',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull7',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull7',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull7',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull7');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %130; %303
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotfull8'
%%%Shotfull8
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull8',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull8',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull8',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull8',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull8',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull8',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull8');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %128;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotfull9'
%%%Shotfull9
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull9',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull9',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull9',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull9',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull9',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull9',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull9');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %130;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotfull10'
%%%Shotfull10
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull10',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull10',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull10',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull10',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull10',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull10',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull10');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %76;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotfull11'
%%%Shotfull11
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull11',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull11',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull11',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull11',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull11',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull11',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull11');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %130; %188
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotfull12'
%%%Shotfull12
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull12',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull12',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull12',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull12',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull12',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull12',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull12');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=55; %55;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotfull13'
%%%Shotfull13
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull13',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull13',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull13',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull13',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull13',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull13',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull13');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %102;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotfull14'
%%%Shotfull14
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull14',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull14',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull14',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull14',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull14',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull14',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull14');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %130; %162
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotfull15'
%%%Shotfull15
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotfull15',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull15',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull15',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull15',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull15',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotfull15',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotfull15');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %130; %184
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm1'
%%%Shotnorm1
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm1',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm1',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm1',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm1',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm1',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm1',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm1');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm2'
%%%Shotnorm2
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm2',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm2',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm2',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm2',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm2',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm2',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm2');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %66;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm3'
%%%Shotnorm3
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm3',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm3',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm3',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm3',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm3',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm3',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm3');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %62;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm4'
%%%Shotnorm4
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm4',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm4',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm4',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm4',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm4',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm4',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm4');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %130; %200
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm5'
%%%Shotnorm5
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm5',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm5',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm5',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm5',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm5',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm5',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm5');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %123;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm6'
%%%Shotnorm6
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm6',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm6',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm6',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm6',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm6',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm6',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm6');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %130; %632
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm7'
%%%Shotnorm7
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm7',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm7',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm7',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm7',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm7',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm7',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm7');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %130; %303
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm8'
%%%Shotnorm8
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm8',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm8',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm8',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm8',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm8',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm8',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm8');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %128;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm9'
%%%Shotnorm9
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm9',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm9',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm9',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm9',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm9',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm9',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm9');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %130;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm10'
%%%Shotnorm10
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm10',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm10',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm10',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm10',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm10',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm10',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm10');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %76;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm11'
%%%Shotnorm11
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm11',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm11',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm11',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm11',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm11',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm11',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm11');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %130; %188
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm12'
%%%Shotnorm12
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm12',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm12',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm12',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm12',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm12',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm12',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm12');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=55; %55;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm13'
%%%Shotnorm13
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm13',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm13',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm13',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm13',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm13',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm13',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm13');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %102;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm14'
%%%Shotnorm14
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm14',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm14',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm14',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm14',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm14',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm14',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm14');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %130; %162
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Shotnorm15'
%%%Shotnorm15
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm15',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm15',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm15',filesep,'origimages',filesep,''];
filename_sequence_basename_frames_or_video.number_format='%08d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm15',filesep,'wrpimages',filesep,''];
filename_sequence_basename_frames_or_video.wrpnumber_format='%08d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
% filename_sequence_basename_frames_or_video.corbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm15',filesep,'wrpimages',filesep,''];
    %corbasename replaces wrpbasename
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Shotnorm15',filesep,'gtimages',filesep,''];
filename_sequence_basename_frames_or_video.gtnumber_format='%08d';
filename_sequence_basename_frames_or_video.gtclosure='.bmp';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'Shotnorm15');
filename_sequence_basename_frames_or_video.bgcode=[35,31,32]; filename_sequence_basename_frames_or_video.mbcode=[255,255,255;...
    147,149,152]; %[1x3 colour; otherobjects] _;26;51

noFrames=60; %130; %184
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    case 'Marpletwo'
%%%Marpletwo
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marpletwo',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpletwo',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpletwo',filesep,'origimages',filesep,'marple2_'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpletwo',filesep,'wrpimages',filesep,'marple2wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpletwo',filesep,'gtimages',filesep,'marple2_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%03d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'marple2');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeall=[255;26;51]; %?[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeallin=[255;51]; %?[1x3 colour; otherobjects]
%noGroups=40; maintaintleveloneconnections=true; upwhichlevel=[]; _c_21_20 _ten
%noGroups=5; maintaintleveloneconnections=true; upwhichlevel=[]; _c_5_4 _tsx _chosen
%noGroups=5; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_5_4 _tsxten

noFrames=117;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9713    0.8457    0.9713    0.8457
%wmergeDfd3    0.9673    0.8352    0.9673    0.8352    5402    7.16    8.98
%wmergeDfd3al  0.9837    0.7787    0.9860    0.6981    5402    7.16    8.98


    case 'Marplefive'
%%%Marplefive
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marplefive',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marplefive',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marplefive',filesep,'origimages',filesep,'marple5_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marplefive',filesep,'wrpimages',filesep,'marple5wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marplefive',filesep,'gtimages',filesep,'marple5_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'marple5');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeall=[255;26]; %?[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeallin=[255;26]; %?[1x3 colour; otherobjects]
%noGroups=270; maintaintleveloneconnections=true; upwhichlevel=[]; _c_18_17 _ten
%noGroups=50; maintaintleveloneconnections=true; upwhichlevel=[]; _c_37_28 _tsx _chosen
%noGroups=70; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_29_38 _tsxten

noFrames=94;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9273    0.7809    0.9273    0.7809
%wmergeDfd3    0.9162    0.7801    0.9162    0.7801    3187    8.36    11.58
%wmergeDfd3al  0.9170    0.7606    0.7998    0.4132    3187    8.36    11.58


    case 'Marplethirteen'
%%%Marplethirteen
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marplethirteen',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marplethirteen',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marplethirteen',filesep,'origimages',filesep,'marple13_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marplethirteen',filesep,'wrpimages',filesep,'marple13wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marplethirteen',filesep,'gtimages',filesep,'marple13_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'marple13');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeall=[255;128;204]; %?[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeallin=[255;128;204]; %?[1x3 colour; otherobjects]
%noGroups=50; maintaintleveloneconnections=true; upwhichlevel=[]; _c_12_11 _ten
%noGroups=45; maintaintleveloneconnections=true; upwhichlevel=[]; _c_33_28 _tsx _chosen
%noGroups=35; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_17_21 _tsxten

noFrames=75;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9426    0.8514    0.9426    0.8514
%wmergeDfd3    0.9440    0.7911    0.9440    0.7911    3917    6.21    5.39
%wmergeDfd3al  0.9703    0.7613    0.9096    0.6264    3917    6.21    5.39


    case 'Carsfour'
%%%Carsfour
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Carsfour',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Carsfour',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Carsfour',filesep,'origimages',filesep,'cars4_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Carsfour',filesep,'wrpimages',filesep,'cars4wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Carsfour',filesep,'gtimages',filesep,'cars4_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'cars4');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=[128;255]; %[1x3 colour; otherobjects]
%noGroups=150; maintaintleveloneconnections=true; upwhichlevel=[]; _c12_11 _ten
%noGroups=30; maintaintleveloneconnections=true; upwhichlevel=[]; _c_59_44 _tsx _chosen

noFrames=54;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9016    0.6647    0.9085    0.7717 _also considers 255
% %wmergeDfd3128 0.9229    0.7739    0.9229    0.7739    6496    6.11    5.29 _only considers 128
%wmergeDfd3    0.9338    0.6728    0.9287    0.7206    6496    6.11    5.29 _also considers 255
%wmergeDfd3al  0.9338    0.6728    0.9287    0.7206    6496    6.11    5.29 _also considers 255


    case 'Marpleone'
%%%Marpleone
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marpleone',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpleone',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpleone',filesep,'origimages',filesep,'marple1_'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpleone',filesep,'wrpimages',filesep,'marple1wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpleone',filesep,'gtimages',filesep,'marple1_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%03d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'marple1');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]
%noGroups=8; maintaintleveloneconnections=true; upwhichlevel=[]; _c_5_4
%noGroups=16; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_25_18 _tsxten

noFrames=100;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9957    0.7284    0.9957    0.7284
%wmergeDfd3    0.9960    0.6138    0.9960    0.6138    5644    5.61    4.60
%wmergeDfd3al  0.9960    0.6138    0.9960    0.6138    5644    5.61    4.60


    case 'Marplethree'
%%%Marplethree
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marplethree',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marplethree',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marplethree',filesep,'origimages',filesep,'marple3_'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marplethree',filesep,'wrpimages',filesep,'marple3wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marplethree',filesep,'gtimages',filesep,'marple3_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%03d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'marple3');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]
%noGroups=6; maintaintleveloneconnections=true; upwhichlevel=[]; keephighestlevels=true; n_size=8; _c_7_6
%noGroups=7; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_13_8 _tsxten

noFrames=100;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9899    0.5001    0.9899    0.5001
%wmergeDfd3    0.9900    0.6907    0.9900    0.6907    5552    5.31    4.20
%wmergeDfd3al  0.9900    0.6907    0.9900    0.6907    5552    5.31    4.20


    case 'Marplefour'
%%%Marplefour
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marplefour',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marplefour',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marplefour',filesep,'origimages',filesep,'marple4_'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=324;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marplefour',filesep,'wrpimages',filesep,'marple4wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=324;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marplefour',filesep,'gtimages',filesep,'marple4_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%03d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=324;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'marple4');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]
%noGroups=10; maintaintleveloneconnections=true; upwhichlevel=[]; _c_11_10
%noGroups=14; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_25_16 _tsx

noFrames=43;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9710    0.6480    0.9710    0.6480
%wmergeDfd3    0.9678    0.8314    0.9678    0.8314    2026    6.94    5.88
%wmergeDfd3al  0.9678    0.8314    0.9678    0.8314    2026    6.94    5.88


    case 'Marplesix'
%%%Marplesix
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marplesix',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marplesix',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marplesix',filesep,'origimages',filesep,'marple6_'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marplesix',filesep,'wrpimages',filesep,'marple6wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marplesix',filesep,'gtimages',filesep,'marple6_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%03d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'marple6');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeall=[255;229]; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeallin=255; %[1x3 colour; otherobjects]
%noGroups=6; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_5_4 _tsxten

noFrames=100;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9872    0.7409    0.9872    0.7409
%wmergeDfd3    0.9819    0.8783    0.9819    0.8783    4529    8.26    11.27
%wmergeDfd3al  0.9799    0.8781    0.9227    0.8738    4529    8.26    11.27


    case 'Marpleseven'
%%%Marpleseven
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marpleseven',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpleseven',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpleseven',filesep,'origimages',filesep,'marple7_'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpleseven',filesep,'wrpimages',filesep,'marple7wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpleseven',filesep,'gtimages',filesep,'marple7_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%03d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'marple7');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeall=[255;204]; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeallin=255; %[1x3 colour; otherobjects]
%noGroups=20; maintaintleveloneconnections=true; upwhichlevel=[]; _c_11_10 _tsx
%noGroups=16; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_21_18 _tsxten

noFrames=100;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9807    0.6548    0.9807    0.6548
%wmergeDfd3    0.9786    0.7690    0.9786    0.7690    8647    5.95    5.38
%wmergeDfd3al  0.9773    0.7322    0.9024    0.4512    8647    5.95    5.38


    case 'Marpleeight'
%%%Marpleeight
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marpleeight',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpleeight',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpleeight',filesep,'origimages',filesep,'marple8_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpleeight',filesep,'wrpimages',filesep,'marple8wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpleeight',filesep,'gtimages',filesep,'marple8_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'marple8');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=128; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeall=[128;255]; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeallin=[128;255]; %[1x3 colour; otherobjects]
%noGroups=xx; maintaintleveloneconnections=true; upwhichlevel=[]; _cxx/xx
%noGroups=50; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_25_24 _tsxten

noFrames=72;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9001    0.6795    0.9001    0.6795
%wmergeDfd3    0.8918    0.7905    0.8918    0.7905    6806    6.74    6.29
%wmergeDfd3al  0.9692    0.6617    0.9692    0.6789    6806    6.74    6.29


    case 'Marplenine'
%%%Marplenine
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marplenine',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marplenine',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marplenine',filesep,'origimages',filesep,'marple9_'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marplenine',filesep,'wrpimages',filesep,'marple9wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marplenine',filesep,'gtimages',filesep,'marple9_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%03d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'marple9');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=[255;128]; %[1x3 colour; otherobjects]
%noGroups=12; maintaintleveloneconnections=true; upwhichlevel=[]; _c_7_6
%noGroups=10; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_7_6 _tsxten

noFrames=100;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9949    0.7364    0.9946    0.7249
%wmergeDfd3    0.9920    0.8482    0.9918    0.8416    8985    7.48    9.26
%wmergeDfd3al  0.9920    0.8482    0.9918    0.8416    8985    7.48    9.26


    case 'Marpleten'
%%%Marpleten
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marpleten',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpleten',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpleten',filesep,'origimages',filesep,'marple10_'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpleten',filesep,'wrpimages',filesep,'marple10wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpleten',filesep,'gtimages',filesep,'marple10_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%03d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'marple10');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeall=[255;204]; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeallin=[255;204]; %[1x3 colour; otherobjects]
%noGroups=4; maintaintleveloneconnections=true; upwhichlevel=[]; _c_5_4
%noGroups=5; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_5_3 _tsxten

noFrames=100;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.8816    0.5598    0.8816    0.5598
%wmergeDfd3    0.8379    0.5804    0.8379    0.5804    9689    6.94    7.43
%wmergeDfd3al  0.9793    0.8032    0.9133    0.7007    9689    6.94    7.43


    case 'Marpleeleven'
%%%Marpleeleven
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marpleeleven',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpleeleven',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpleeleven',filesep,'origimages',filesep,'marple11_'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpleeleven',filesep,'wrpimages',filesep,'marple11wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpleeleven',filesep,'gtimages',filesep,'marple11_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%03d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'marple11');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]
%noGroups=60; maintaintleveloneconnections=true; upwhichlevel=[]; _c_51_50
%noGroups=18; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_33_20 _tsxten

noFrames=100;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9583    0.8326    0.9583    0.8326
%wmergeDfd3    0.9421    0.8878    0.9421    0.8878    6884    7.23    9.25
%wmergeDfd3al  0.9421    0.8878    0.9421    0.8878    6884    7.23    9.25


    case 'Marpletwelve'
%%%Marpletwelve
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marpletwelve',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpletwelve',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpletwelve',filesep,'origimages',filesep,'marple12_'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpletwelve',filesep,'wrpimages',filesep,'marple12wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpletwelve',filesep,'gtimages',filesep,'marple12_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%03d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'marple12');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeall=[255;179;77]; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeallin=[255;179;77]; %[1x3 colour; otherobjects]
%noGroups=40; maintaintleveloneconnections=true; upwhichlevel=[]; _c_23_22
%noGroups=8; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_14_10 _tsxten

noFrames=100;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9478    0.7543    0.9478    0.7543
%wmergeDfd3    0.9162    0.8196    0.9162    0.8196    6235    7.52    9.71
%wmergeDfd3al  0.9444    0.7884    0.9008    0.7043    6235    7.52    9.71


    case 'Tennis'
%%%Tennis
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Tennis',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Tennis',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Tennis',filesep,'origimages',filesep,'tennis'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=454;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Tennis',filesep,'wrpimages',filesep,'tenniswrp'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=454;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Tennis',filesep,'gtimages',filesep,'tennis'];
filename_sequence_basename_frames_or_video.gtnumber_format='%03d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=454;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'tennis');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeall=[255;179;26]; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeallin=[255;179]; %[1x3 colour; otherobjects]
%noGroups=3; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_3_3 same colour _tsxten
%noGroups=3; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_2.66_3 _tsxten

noFrames=100;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9457    0.6903    0.9457    0.6903
%wmergeDfd3    0.9609    0.7065    0.9609    0.7065    6381    6.39    6.16
%wmergeDfd3al  0.9553    0.6723    0.6103    0.3768    6381    6.39    6.16


    case 'Peopleone'
%%%Peopleone
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Peopleone',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Peopleone',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Peopleone',filesep,'origimages',filesep,'people1_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Peopleone',filesep,'wrpimages',filesep,'people1wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Peopleone',filesep,'gtimages',filesep,'people1_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'people1');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]
%noGroups=xx; maintaintleveloneconnections=true; upwhichlevel=[]; _c_xx_xx
%noGroups=5; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_5_3 _tsx

noFrames=40;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9707    0.6600    0.9707    0.6600
%wmergeDfd3    0.9450    0.6349    0.9450    0.6349    6869    6.06    5.51
%wmergeDfd3al  0.9450    0.6349    0.9450    0.6349    6869    6.06    5.51


    case 'Peopletwo'
%%%Peopletwo
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Peopletwo',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Peopletwo',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Peopletwo',filesep,'origimages',filesep,'people2_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Peopletwo',filesep,'wrpimages',filesep,'people2wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Peopletwo',filesep,'gtimages',filesep,'people2_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'people2');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=[255;128]; %[1x3 colour; otherobjects]
%noGroups=xx; maintaintleveloneconnections=true; upwhichlevel=[]; _c_xx_xx
%noGroups=40; maintaintleveloneconnections=true; upwhichlevel=[]; n_size=8;
    %keephighestlevels=true; manifoldmethod='isoii'; clusteringmethod='km'; noreplicates=600; _c_493_24 _tsx

noFrames=30;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.9921    0.7923    0.9866    0.6762
%wmergeDfd3    0.9841    0.7178    0.9818    0.5900    5020    6.10    4.87
%wmergeDfd3al  0.9841    0.7178    0.9818    0.5900    5020    6.10    4.87


    case 'Carsone'
%%%Carsone
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Carsone',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Carsone',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Carsone',filesep,'origimages',filesep,'cars1_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Carsone',filesep,'wrpimages',filesep,'cars1wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Carsone',filesep,'gtimages',filesep,'cars1_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'cars1');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=[255;128]; %[1x3 colour; otherobjects]

noFrames=19;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.    0.    0.    0.    xxx    x    x
%wmergeDfd3    0.9860    0.7078    0.9494    0.5899    2740    5.50    3.49
%wmergeDfd3al  0.9860    0.7078    0.9494    0.5899    2740    5.50    3.49


    case 'Carstwo'
%%%Carstwo
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Carstwo',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Carstwo',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Carstwo',filesep,'origimages',filesep,'cars2_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Carstwo',filesep,'wrpimages',filesep,'cars2wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Carstwo',filesep,'gtimages',filesep,'cars2_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'cars2');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=[255;153;51;102;204]; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeall=[255;153;51;102;204]; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeallin=[255;51;102]; %[1x3 colour; otherobjects]

noFrames=30;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.    0.    0.    0.    xxx    x    x
%wmergeDfd3    0.9015    0.6243    0.5201    0.4319    4491    6.12    4.81
%wmergeDfd3al  0.9015    0.6243    0.5201    0.4319    4491    6.12    4.81


    case 'Carsthree'
%%%Carsthree
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Carsthree',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Carsthree',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Carsthree',filesep,'origimages',filesep,'cars3_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Carsthree',filesep,'wrpimages',filesep,'cars3wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Carsthree',filesep,'gtimages',filesep,'cars3_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'cars3');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=[255;128]; %[1x3 colour; otherobjects]

noFrames=19;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.    0.    0.    0.    xxx    x    x
%wmergeDfd3    0.9850    0.7262    0.9832    0.7022    2590    5.54    3.55
%wmergeDfd3al  0.9850    0.7262    0.9832    0.7022    2590    5.54    3.55


    case 'Carsfive'
%%%Carsfive
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Carsfive',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Carsfive',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Carsfive',filesep,'origimages',filesep,'cars5_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Carsfive',filesep,'wrpimages',filesep,'cars5wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Carsfive',filesep,'gtimages',filesep,'cars5_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'cars5');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=[153;204;255]; %[1x3 colour; otherobjects]

noFrames=36;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.    0.    0.    0.    xxx    x    x
%wmergeDfd3    0.9499    0.6971    0.8365    0.5402    5123    6.10    5.11
%wmergeDfd3al  0.9499    0.6971    0.8365    0.5402    5123    6.10    5.11


    case 'Carssix'
%%%Carssix
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Carssix',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Carssix',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Carssix',filesep,'origimages',filesep,'cars6_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Carssix',filesep,'wrpimages',filesep,'cars6wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Carssix',filesep,'gtimages',filesep,'cars6_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'cars6');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]

noFrames=30;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.    0.    0.    0.    xxx    x    x
%wmergeDfd3    0.9710    0.6982    0.9710    0.6982    3643    6.41    5.36
%wmergeDfd3al  0.9710    0.6982    0.9710    0.6982    3643    6.41    5.36


    case 'Carsseven'
%%%Carsseven
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Carsseven',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Carsseven',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Carsseven',filesep,'origimages',filesep,'cars7_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Carsseven',filesep,'wrpimages',filesep,'cars7wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Carsseven',filesep,'gtimages',filesep,'cars7_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'cars7');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=255; %[1x3 colour; otherobjects]

noFrames=24;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.    0.    0.    0.    xxx    x    x
%wmergeDfd3    0.9760    0.7101    0.9760    0.7101    3902    5.93    4.34
%wmergeDfd3al  0.9760    0.7101    0.9760    0.7101    3902    5.93    4.34


    case 'Carseight'
%%%Carseight
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Carseight',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Carseight',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Carseight',filesep,'origimages',filesep,'cars8_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Carseight',filesep,'wrpimages',filesep,'cars8wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Carseight',filesep,'gtimages',filesep,'cars8_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'cars8');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=[255;128]; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeall=[255;128]; %[1x3 colour; otherobjects]
filename_sequence_basename_frames_or_video.mbcodeallin=255; %[1x3 colour; otherobjects]

noFrames=24;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.    0.    0.    0.    xxx    x    x
%wmergeDfd3    0.9824    0.6469    0.9752    0.4705    2204    5.53    3.67
%wmergeDfd3al  0.9824    0.6469    0.9752    0.4705    2204    5.53    3.67


    case 'Carsnine'
%%%Carsnine
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Carsnine',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Carsnine',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Carsnine',filesep,'origimages',filesep,'cars9_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Carsnine',filesep,'wrpimages',filesep,'cars9wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Carsnine',filesep,'gtimages',filesep,'cars9_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'cars9');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=[204;255;51;153]; %[1x3 colour; otherobjects]

noFrames=60;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.    0.    0.    0.    xxx    x    x
%wmergeDfd3     0.9796    0.7469    0.9067    0.6521    6899    6.19    6.12
%wmergeDfd3al   0.9796    0.7469    0.9067    0.6521    6899    6.19    6.12


    case 'Carsten'
%%%Carsten
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Carsten',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Carsten',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Carsten',filesep,'origimages',filesep,'cars10_'];
filename_sequence_basename_frames_or_video.number_format='%02d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Carsten',filesep,'wrpimages',filesep,'cars10wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%02d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0; %if 0 image is not resized 
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Carsten',filesep,'gtimages',filesep,'cars10_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%02d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;
% filename_sequence_basename_frames_or_video=Addbnames(filename_sequence_basename_frames_or_video,basedrive,filenames,'cars10');
filename_sequence_basename_frames_or_video.bgcode=0; filename_sequence_basename_frames_or_video.mbcode=[255;128;51]; %[1x3 colour; otherobjects]

noFrames=30;
% [cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories]=... 
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);
%w             0.    0.    0.    0.    xxx    x    x
%wmergeDfd3     0.9714    0.5842    0.9589    0.5682    4630    5.66    3.97
%wmergeDfd3al   0.9714    0.5842    0.9589    0.5682    4630    5.66    3.97









    case 'commands'




%%%cim, ucm2
load(filenames.filename_colour_images)
[ucm2,valid]=Readpictureseries(ucm2filename.basename,...
    ucm2filename.number_format,ucm2filename.closure,...
    ucm2filename.startNumber,noFrames,printonscreen);

Getmainmenu(filenames,cim,ucm2);



%%%Initialization
clear flows;
flows.whichDone=zeros(1,noFrames);
clear allregionsframes;
allregionsframes=cell(1,noFrames);
clear similarities;
similarities=0;
clear trajectories;
trajectories=0;
clear mapPathToTrajectory;
mapPathToTrajectory=[];
clear correspondentPath;
correspondentPath=0;
clear allregionpaths;
allregionpaths=0;
clear totPaths;
totPaths=[];



%%%cim, ucm2, flows
load(filenames.filename_colour_images)
[ucm2,valid]=Readpictureseries(ucm2filename.basename,...
    ucm2filename.number_format,ucm2filename.closure,...
    ucm2filename.startNumber,noFrames,printonscreen);
load(filenames.filename_flows);

Getmainmenu(filenames,cim,ucm2,flows);



%%%cim, ucm2, flows, allregionsframes

load(filenames.filename_flows);
load(filenames.filename_allregionsframes);

[flows,allregionsframes]=Getmainmenu(filenames,cim,ucm2,flows,allregionsframes);


%the following is using precomputed flows, allregionsframes and similarities
load(filenames.filename_flows)
load(filenames.filename_allregionsframes_all)
[flows,allregionsframes]=Getmainmenu(filenames,cim,ucm2,flows,allregionsframes);


%the following is using precomputed flows, allregionsframes and similarities
%precomputed allregionpaths and correspondentPath are also loaded
load(filenames.filename_allregionsframes_all)
load(filenames.filename_similarities_all)
load(filenames.filename_flows)
load(filenames.filename_forward_backward_with_scrambled_map) %forward/backward dynamic programming mapped with scrambled map
load(filenames.filename_trajectories_all)
frame=1;
level=35;

[flows,allregionsframes]=Getmainmenu(filenames,cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath);

[frame,level,flows,similarities,allregionpaths,correspondentPath,totPaths,trajectories,mapPathToTrajectory]=...
    Getmenuforregionpath(filenames,frame,level,cim,ucm2,flows,allregionsframes,similarities,allregionpaths,...
    correspondentPath,totPaths,trajectories,mapPathToTrajectory);
[frame,level,flows,similarities,allregionpaths,correspondentPath,totPaths,trajectories,mapPathToTrajectory]=Getmenuforregionpath(filenames,frame,level,cim,ucm2,flows,allregionsframes,similarities,allregionpaths,correspondentPath,totPaths,trajectories,mapPathToTrajectory);

% [frame,level]=Getclusteringmenu(filenames,frame,level,cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories);
[frame,level]=Getclusteringmenujrf(filenames,frame,level,cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories);

[frame,level]=Getclusteringmenujrf(filenames,frame,level,cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,...
    trajectories,mapPathToTrajectory,thetrajectorytree,selectedtreetrajectories,options,filename_sequence_basename_frames_or_video,videocorrectionparameters);
%options,filename_sequence_basename_frames_or_video,videocorrectionparameters required for options.statistics in Gettheclustering

load(filenames.filename_normalisedsimilarities_all)

usetotpaths=0;
load(filenames.filename_forward_backward_with_length_map) %forward/backward dynamic programming mapped with frame persistence
[flows,allregionsframes]=Getmainmenu(filenames,cim,ucm2,flows,allregionsframes,allregionpaths,correspondentPath,usetotpaths);





    otherwise
        fprintf('Option not recognised\n');
end

