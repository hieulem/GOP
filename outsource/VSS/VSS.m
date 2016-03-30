function VSS(theswitch,varargin)
%VSS('Marpleone_20ff');
%VSS('Marpleone_20ff','clustcompnumbers','[10,5,3]');
%VSS('Marpleone_20ff','requestedaffinities','{stm}','clustaddname','AACtry','newsegname','AASegmtry','stpcas','rpcbest','clustcompnumbers','[3,5,10,20]')
%VSS('Marpleone_20ff','requestedaffinities','{stt,ltt,aba,abm,stm,sta}','clustaddname','AACtry','newsegname','AASegmtry','stpcas','paperoptnrm','clustcompnumbers','[1,2,3,4,5,10]')
%VSS('Marpleone_20ff','clustcompnumbers','[1,2,3,5,10,20]','clustaddname','tttttC','newsegname','tttttSegm','faffinityv','50');
%VSS('Marpleone_20ff','clustcompnumbers','[1,2,3,5,10,20]','clustaddname','tttttC','newsegname','tttttSegm','faffinityv','50','mrgmth','prod');

% clear all

if (~isdeployed)
    Setthepath();
end
basedrive=['.',filesep]; %Directory where the VideoProcessingTemp dir is located


options.newucmtwo=true;
options.cleanifexisting=Inf; options.origucm2=false;
options.usebflow=false; options.pre_filter_flow=true; options.filter_flow=true;



%Test options
options.testthesegmentation=false; options.segaddname='MAHIS_benchmark'; %Hierarchical image segmentation benchmark (Boundary PR, SC, PRI, VI)
options.testmanifoldclustering=true; options.clustaddname='VS_perpixelerror_benchmark'; %Per pixel error metric
options.testnewsegmentation=true; options.newsegname='VS_benchmark'; %Hierarchical video segmentation benchmark (Boundary PR, SC, PRI, VI)
options.calibratetheparameters=false; options.calibrateparametersname='RAW_parameter_setup'; %Gather row values and test affinity transformations


%Additional options (here the default values)
% options.requestedaffinities={'stt','ltt','aba','abm','stm','sta'};
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
% options.clustcompnumbers=[2,5,10];



%Analyse the input: this is given priority against the options define earlier in this function
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
    options.stpcas='paperoptnrm';
end
options=Applysetupcase(options);
options %#ok<NOPRT>



switch(theswitch)
    
    
    case 'Marpleone_20ff'
%%%Marpleone_20ff
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marpleone_20ff',filesep];
filenames=Getfilenames(basename_variables_directory,[],options);

ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpleone_20ff',filesep,'ucm2images',filesep,'ucm2image'];
ucm2filename.number_format='%03d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpleone_20ff',filesep,'origimages',filesep,'marple1_'];
filename_sequence_basename_frames_or_video.number_format='%03d';
filename_sequence_basename_frames_or_video.closure='.jpg';
filename_sequence_basename_frames_or_video.startNumber=1;
filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpleone_20ff',filesep,'wrpimages',filesep,'marple1wrp_'];
filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
filename_sequence_basename_frames_or_video.wrpclosure='.png';
filename_sequence_basename_frames_or_video.wrpstartNumber=1;
videocorrectionparameters.deinterlace=false;
videocorrectionparameters.rszratio=0.5; %if 0 image is not resized
videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left
filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpleone_20ff',filesep,'gtimages',filesep,'marple1_'];
filename_sequence_basename_frames_or_video.gtnumber_format='%03d';
filename_sequence_basename_frames_or_video.gtclosure='.pgm';
filename_sequence_basename_frames_or_video.gtstartNumber=1;

noFrames=20;
Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);

    
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

noFrames=100;
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

noFrames=100;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=100;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=43;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=94;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=100;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=100;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=72;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=100;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=100;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=100;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=100;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=75;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=100;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=40;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=30;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=19;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=30;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=19;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=54;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=36;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=30;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=24;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=24;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=60;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


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

noFrames=30;
    Doallprocessing(filenames,filename_sequence_basename_frames_or_video,ucm2filename,noFrames,options,videocorrectionparameters);


    otherwise
        fprintf('Option not recognised\n');
end

