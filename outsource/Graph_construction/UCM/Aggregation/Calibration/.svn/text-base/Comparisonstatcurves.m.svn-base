% matlab -nodisplay

%Setup parameters
cd Desktop/Code/TCHS/
if (~isdeployed)
    Setthepath();
end
if (ispc)
    basedrive=['D:',filesep];
else
    if (exist([filesep,'BS',filesep,'galasso_proj_spx',filesep,'work',filesep],'dir'))
        basedrive=[filesep,'BS',filesep,'galasso_proj_spx',filesep,'work',filesep];
    else
        basedrive=[filesep,'media',filesep,'Data',filesep];
    end
end
% basedrive=['E:\Officecompletebackup\Ddir',filesep];
basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Syntheticai',filesep];
filenames=Getfilenames(basename_variables_directory,[]);

recomputevalues=true; %#ok<NASGU>
paramcalibname='Paramcstltifefffn'; %#ok<NASGU>





paramcalibname='Paramcstltifefffn';
clear options; options.stpcas='paper'; %rpcbest,bkbbest,paper,paperopt
options.requestedaffinities={'stt','ltt','aba','abm','stm','sta'}; %#ok<STRNU>
recomputevalues=false;
requestdelconf=false;



%All
additionalname='Cfallp50rpcbws'; Computecm(filenames,additionalname,requestdelconf,'r');
additionalname='Cfallp50rpcbpr'; Computecm(filenames,additionalname,requestdelconf,'b',true);
additionalname='Cfallp50papews'; Computecm(filenames,additionalname,requestdelconf,'c',true);
additionalname='Cfallp50papepr'; Computecm(filenames,additionalname,requestdelconf,'g',true);

clear options; options.stpcas='rpcbest'; options.mrgmth='wsum';
Getaffstatistics(filenames, options, paramcalibname, [], 'r', false, 'allrpcbestwsum', recomputevalues);
clear options; options.stpcas='rpcbest'; options.mrgmth='prod';
Getaffstatistics(filenames, options, paramcalibname, [], 'b',true, 'allrpcbestprod', recomputevalues);
clear options; options.stpcas='paper'; options.mrgmth='wsum';
Getaffstatistics(filenames, options, paramcalibname, [], 'c',true, 'allpaperwsum', recomputevalues);
clear options; options.stpcas='paper'; options.mrgmth='prod';
Getaffstatistics(filenames, options, paramcalibname, [], 'g',true, 'allpaperprod', recomputevalues);



%Motion affinities
additionalname='Cfmotaffp50rpcbws'; Computecm(filenames,additionalname,requestdelconf,'r');
additionalname='Cfmotaffp50rpcbpr'; Computecm(filenames,additionalname,requestdelconf,'b',true);
additionalname='Cfmotaffp50papews'; Computecm(filenames,additionalname,requestdelconf,'c',true);
additionalname='Cfmotaffp50papepr'; Computecm(filenames,additionalname,requestdelconf,'k',true);

clear options; options.stpcas='rpcbest'; options.mrgmth='wsum'; options.requestedaffinities={'stt','ltt','stm'};
Getaffstatistics(filenames, options, paramcalibname, [], 'r', false, 'motaffrpcbestwsum', recomputevalues);
clear options; options.stpcas='rpcbest'; options.mrgmth='prod'; options.requestedaffinities={'stt','ltt','stm'};
Getaffstatistics(filenames, options, paramcalibname, [], 'b',true, 'motaffrpcbestprod', recomputevalues);
clear options; options.stpcas='paper'; options.mrgmth='wsum'; options.requestedaffinities={'stt','ltt','stm'};
Getaffstatistics(filenames, options, paramcalibname, [], 'c',true, 'motaffpaperwsum', recomputevalues);
clear options; options.stpcas='paper'; options.mrgmth='prod'; options.requestedaffinities={'stt','ltt','stm'};
Getaffstatistics(filenames, options, paramcalibname, [], 'k',true, 'motaffpaperprod', recomputevalues);



%Base cases optimized independently compaerd to paper values
additionalname='Cfallp50papepr5d0'; Computecm(filenames,additionalname,requestdelconf,'k'); %All paper + STM paperopt
additionalname='Cfallp50papepr'; Computecm(filenames,additionalname,requestdelconf,'g',true); %All paper
additionalname='Cfallp50papepr17d5'; Computecm(filenames,additionalname,requestdelconf,'m',true); %All paper + STM rpcbest
clear options; options.stpcas='paper'; options.stmlmbd=true; options.stmrefv=5.0; options.stmavf=true; %all + STM paperopt
Getaffstatistics(filenames, options, paramcalibname, [], 'k',false, 'allpaperprodffopt', recomputevalues);
clear options; options.stpcas='paper'; %all paper STM is 2.77 but pow 4
Getaffstatistics(filenames, options, paramcalibname, [], 'g',true, 'allpaperprod', recomputevalues);
clear options; options.stpcas='paper'; options.stmlmbd=true; options.stmrefv=17.5; options.stmavf=true; %all + STM rpcbest
Getaffstatistics(filenames, options, paramcalibname, [], 'm',true, 'allpaperprodffrpcbest', recomputevalues);

additionalname='Cfffp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'r',true); %STM paperopt
additionalname='Cfffp50ref5av0'; Computecm(filenames,additionalname,requestdelconf,'b',true); %STM paper
additionalname='Cfffp50ref2'; Computecm(filenames,additionalname,requestdelconf,'y',true); %STM rpcbest
clear options; options.stpcas='paperopt'; options.requestedaffinities={'stm'}; %STM paperopt
Getaffstatistics(filenames, options, paramcalibname, [], 'r', true, 'ffpaperopt', recomputevalues);
clear options; options.stpcas='paper'; options.requestedaffinities={'stm'}; %STM paper
Getaffstatistics(filenames, options, paramcalibname, [], 'b',true, 'ffpaper', recomputevalues);
clear options; options.stpcas='paper'; options.requestedaffinities={'stm'}; options.stmlmbd=true; options.stmrefv=17.5; options.stmavf=true; %STM rpcbest
Getaffstatistics(filenames, options, paramcalibname, [], 'y',true, 'ffpaperffrpcbest', recomputevalues);
% clear options; options.stpcas='rpcbest'; options.requestedaffinities={'stm'}; %STM rpcbest
% Getaffstatistics(filenames, options, paramcalibname, [], 'y',true, 'ffrpcbest', recomputevalues);

additionalname='Cfltefp50rpcbws'; Computecm(filenames,additionalname,requestdelconf,'k'); %LTT+ABM rpcbest
additionalname='Cfltefp50papews'; Computecm(filenames,additionalname,requestdelconf,'y',true); %LTT+ABM paper
clear options; options.stpcas='rpcbest'; options.requestedaffinities={'ltt','abm'};
Getaffstatistics(filenames, options, paramcalibname, [], 'k', false, 'ltefrpcbest', recomputevalues);
clear options; options.stpcas='paper'; options.requestedaffinities={'ltt','abm'};
Getaffstatistics(filenames, options, paramcalibname, [], 'y', true, 'ltefpaper', recomputevalues);

additionalname='Cfallefp50papepr0d75'; Computecm(filenames,additionalname,requestdelconf,'r'); %All ABM ~rpcbest
additionalname='Cfallefp50papepr5d0'; Computecm(filenames,additionalname,requestdelconf,'b',true); %All ABM paperopt
additionalname='Cfallefp50papepr2d5'; Computecm(filenames,additionalname,requestdelconf,'m',true); %All ABM paper
clear options; options.stpcas='paper'; options.abmlmbd=true; options.abmrefv=0.75; %All ABM ~rpcbest
Getaffstatistics(filenames, options, paramcalibname, [], 'r', false, 'allpaperefrpcbest', recomputevalues);
clear options; options.stpcas='paper'; options.abmlmbd=true; options.abmrefv=5.0; %All ABM paperopt
Getaffstatistics(filenames, options, paramcalibname, [], 'b', true, 'allpaperefpaperopt', recomputevalues);
clear options; options.stpcas='paper'; options.abmlmbd=true; options.abmrefv=2.5; %All ABM paper
Getaffstatistics(filenames, options, paramcalibname, [], 'm', true, 'allpaperefpaper', recomputevalues);

additionalname='Cfstefp50rpcbws'; Computecm(filenames,additionalname,requestdelconf,'k'); %STT+ABM rpcbest
additionalname='Cfstefp50papews'; Computecm(filenames,additionalname,requestdelconf,'y',true); %STT+ABM paper
clear options; options.stpcas='rpcbest'; options.requestedaffinities={'stt','abm'};
Getaffstatistics(filenames, options, paramcalibname, [], 'k', false, 'stefrpcbest', recomputevalues);
clear options; options.stpcas='paper'; options.requestedaffinities={'stt','abm'};
Getaffstatistics(filenames, options, paramcalibname, [], 'y', true, 'stefpaper', recomputevalues);

additionalname='Cfaap50rpcbws'; Computecm(filenames,additionalname,requestdelconf,'k'); %STA rpcbest
additionalname='Cfaap50papews'; Computecm(filenames,additionalname,requestdelconf,'y',true); %STA paper
additionalname='Cfaap50papepapeopt'; Computecm(filenames,additionalname,requestdelconf,'b',true); %STA paperopt
clear options; options.stpcas='rpcbest'; options.requestedaffinities={'sta'}; %STA rpcbest
Getaffstatistics(filenames, options, paramcalibname, [], 'k', false, 'aarpcbest', recomputevalues);
clear options; options.stpcas='paper'; options.requestedaffinities={'sta'}; %STA paper
Getaffstatistics(filenames, options, paramcalibname, [], 'y', true, 'aapaper', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'sta'}; options.stalmbd=true; options.stasqv=true; options.starefv=0.005; %STA paperopt
Getaffstatistics(filenames, options, paramcalibname, [], 'b', true, 'aapaperoptsq1', recomputevalues);
% clear options; options.stpcas='paperopt'; options.requestedaffinities={'sta'}; options.stalmbd=true; options.stasqv=false; options.starefv=0.05; %STA paperoptbis (same as paper)
% Getaffstatistics(filenames, options, paramcalibname, [], 'g', true, 'aapaperoptsq0', recomputevalues);

additionalname='Cfallaap50papepr0d005'; Computecm(filenames,additionalname,requestdelconf,'r',true); %All paper opt + STA paperopt
additionalname='Cfallaap50papeprsq00d05'; Computecm(filenames,additionalname,requestdelconf,'g',true); %All paper opt + STA paper (paperoptbis)
additionalname='Cfallaap50papepr1d0'; Computecm(filenames,additionalname,requestdelconf,'m',true); %All paper opt + ~STA rpcbest
clear options; options.stpcas='paperopt'; options.stalmbd=true; options.stasqv=true; options.starefv=0.005; %All paper opt + STA paperopt
Getaffstatistics(filenames, options, paramcalibname, [], 'r', true, 'allaapaperoptsq1', recomputevalues);
clear options; options.stpcas='paperopt'; options.stalmbd=true; options.stasqv=false; options.starefv=0.05; %All paper opt + STA paper (paperoptbis)
Getaffstatistics(filenames, options, paramcalibname, [], 'g', true, 'allaapaperoptsq0', recomputevalues);
clear options; options.stpcas='paperopt'; options.stalmbd=true; options.stasqv=true; options.starefv=1.0; %All paper opt + ~STA rpcbest
Getaffstatistics(filenames, options, paramcalibname, [], 'm', true, 'allpaperoptaasq1rpcbest', recomputevalues);

%Base cases optimized independently
additionalname='Cfaap50rpcbws'; Computecm(filenames,additionalname,requestdelconf,'k'); %STA rpcbest
additionalname='Cfffp50rpcbws'; Computecm(filenames,additionalname,requestdelconf,'y',true); %STM rpcbest
additionalname='Cfltefp50rpcbws'; Computecm(filenames,additionalname,requestdelconf,'m',true); %LTT+ABM rpcbest
additionalname='Cfstifp50rpcbws'; Computecm(filenames,additionalname,requestdelconf,'c',true); %STT+ABA rpcbest
additionalname='Cfltifp50rpcbws'; Computecm(filenames,additionalname,requestdelconf,'g',true); %LTT+ABA rpcbest
additionalname='Cfstefp50rpcbws'; Computecm(filenames,additionalname,requestdelconf,'r',true); %STT+ABM rpcbest

clear options; options.stpcas='rpcbest'; options.requestedaffinities={'sta'};
Getaffstatistics(filenames, options, paramcalibname, [], 'k', false, 'aarpcbest', recomputevalues);
clear options; options.stpcas='rpcbest'; options.requestedaffinities={'stm'};
Getaffstatistics(filenames, options, paramcalibname, [], 'y', true, 'ffrpcbest', recomputevalues);
clear options; options.stpcas='rpcbest'; options.requestedaffinities={'abm','ltt'};
Getaffstatistics(filenames, options, paramcalibname, [], 'm', true, 'ltefrpcbest', recomputevalues);
clear options; options.stpcas='rpcbest'; options.requestedaffinities={'stt','aba'};
Getaffstatistics(filenames, options, paramcalibname, [], 'c', true, 'stifrpcbest', recomputevalues);
clear options; options.stpcas='rpcbest'; options.requestedaffinities={'ltt','aba'};
Getaffstatistics(filenames, options, paramcalibname, [], 'g', true, 'ltifrpcbest', recomputevalues);
clear options; options.stpcas='rpcbest'; options.requestedaffinities={'stt','abm'};
Getaffstatistics(filenames, options, paramcalibname, [], 'r', true, 'stefrpcbest', recomputevalues);








%Analysis paperopt
additionalname='Cfallp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'c'); %all
additionalname='Cfffp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'k',true); %stm
additionalname='Cfaap50papeopt'; Computecm(filenames,additionalname,requestdelconf,'g',true); %sta
additionalname='Cfstifp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'y',true); %stt+aba
additionalname='Cfstefp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'b',true); %stt+abm
additionalname='Cfltifp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'r',true); %ltt+aba
additionalname='Cfltefp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'m',true); %ltt+abm
additionalname='Cfstltp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'c',true); %stt+ltt

clear options; options.stpcas='paperopt'; %all
Getaffstatistics(filenames, options, paramcalibname, [], 'c', false, 'allpaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'stm'}; %stm
Getaffstatistics(filenames, options, paramcalibname, [], 'k', true, 'stmpaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'sta'}; %stm
Getaffstatistics(filenames, options, paramcalibname, [], 'g', true, 'stapaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'stt','aba'}; %stt,aba
Getaffstatistics(filenames, options, paramcalibname, [], 'y', true, 'sttabapaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'stt','abm'}; %stt,abm
Getaffstatistics(filenames, options, paramcalibname, [], 'b', true, 'sttabmpaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'ltt','aba'}; %ltt,aba
Getaffstatistics(filenames, options, paramcalibname, [], 'r', true, 'lttabapaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'ltt','abm'}; %ltt,abm
Getaffstatistics(filenames, options, paramcalibname, [], 'm', true, 'lttabmpaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'stt','ltt'}; %stt,ltt
Getaffstatistics(filenames, options, paramcalibname, [], 'c', true, 'sttlttpaperopt', recomputevalues);

additionalname='Cfallp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'c'); %all
additionalname='Cfstltffp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'k',true); %motion affinities
additionalname='Cfstltffaap50papeopt'; Computecm(filenames,additionalname,requestdelconf,'g',true); %motion affinities + sta
additionalname='Cfallminusstp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'y',true); %all affinities - stt
additionalname='Cfallminusltp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'b',true); %all affinities - ltt
additionalname='Cfallminusifp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'r',true); %all affinities - aba
additionalname='Cfallminusefp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'m',true); %all affinities - abm
additionalname='Cfallminusffp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'c',true); %all affinities - stm
additionalname='Cfallminusaap50papeopt'; Computecm(filenames,additionalname,requestdelconf,'k',true); %all affinities - sta
additionalname='Cfallmixp50papeopt'; Computecm(filenames,additionalname,requestdelconf,'r',true); %all + aa (rpcbest) wsum 0.1

clear options; options.stpcas='paperopt'; %all
Getaffstatistics(filenames, options, paramcalibname, [], 'c', false, 'allpaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'stm','stt','ltt'}; %motion affinities
Getaffstatistics(filenames, options, paramcalibname, [], 'k', true, 'motpaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'stm','stt','ltt','sta'}; %motion affinities + sta
Getaffstatistics(filenames, options, paramcalibname, [], 'g', true, 'motstapaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'ltt','aba','abm','stm','sta'}; %all affinities - stt
Getaffstatistics(filenames, options, paramcalibname, [], 'y', true, 'allmsttpaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'stt','aba','abm','stm','sta'}; %all affinities - ltt
Getaffstatistics(filenames, options, paramcalibname, [], 'b', true, 'allmlttpaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'stt','ltt','abm','stm','sta'}; %all affinities - aba
Getaffstatistics(filenames, options, paramcalibname, [], 'r', true, 'allmabapaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'stt','ltt','aba','stm','sta'}; %all affinities - abm
Getaffstatistics(filenames, options, paramcalibname, [], 'm', true, 'allmabmpaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'stt','ltt','aba','abm','sta'}; %all affinities - stm
Getaffstatistics(filenames, options, paramcalibname, [], 'c', true, 'allmstmpaperopt', recomputevalues);
clear options; options.stpcas='paperopt'; options.requestedaffinities={'stt','ltt','aba','abm','stm'}; %all affinities - sta
Getaffstatistics(filenames, options, paramcalibname, [], 'c', true, 'allmstapaperopt', recomputevalues);
% clear options; options.stpcas='paperopt'; options.requestedaffinities={'stt','ltt','aba','abm','stm','sta'}; %all affinities + sta rpcbest wsum 0.1
% Getaffstatistics(filenames, options, paramcalibname, [], 'c', true, 'allpstarpcbestpaperopt', recomputevalues);

