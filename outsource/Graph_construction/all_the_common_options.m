addpath(genpath('./sup_code'));
addpath(genpath('./Learn_affinities'));
addpath(genpath('../../mUtilities'));


if (~isdeployed)
    Setthepath();
end

%%END

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
