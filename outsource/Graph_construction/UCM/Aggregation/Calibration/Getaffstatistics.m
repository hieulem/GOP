function Getaffstatistics(filenames, options, paramcalibname, onevideo, usethiscolor, addtofigure, rcname, overwriterecord, printonscreen)

% options.stpcas='default';
% options.requestedaffinities={'stt','ltt','aba','abm','stm','sta'};

if ( (~exist('overwriterecord','var')) || (isempty(overwriterecord)) )
    overwriterecord=false;
end
if ( (~exist('rcname','var')) || (isempty(rcname)) )
    rcname=[];
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=true;
end
if ( (~exist('usethiscolor','var')) || (isempty(usethiscolor)) )
    usethiscolor=[];
end
if ( (~exist('options','var')) || (isempty(options)) )
    options=struct;
end
if ( (~exist('addtofigure','var')) || (isempty(addtofigure)) )
    addtofigure=false;
end
if ( (~exist('onevideo','var')) || (isempty(onevideo)) )
    onevideo=[];
end
if ( (~exist('paramcalibname','var')) || (isempty(paramcalibname)) )
    paramcalibname='Paramcstltifefff'; fprintf('Using standard additional name %s, please confirm\n',paramcalibname); pause;
end
printonscreeninsidefunction=false;

%Assign input directory names and check existance of folders
onlyassignnames=true;
[thebenchmarkdir,theDir,isvalid] = Benchmarkcreateparametercalibrationdirs(filenames, paramcalibname, onlyassignnames); %#ok<ASGLU>
if (~isvalid)
    fprintf('Some Directories are not existing\n');
    return;
end

%Define outDir
[thebenchmarkdir,outDir] = Benchmarkcreatecalibrationparameterout(filenames, paramcalibname,[],false);



recordcasefile=fullfile(outDir, [rcname,'.mat']);
if ( (~isempty(rcname)) && (exist(recordcasefile,'file')) && (~overwriterecord) )
    load(recordcasefile);
    fprintf('Loaded statistics %s\n',rcname);
else

    %List of files in Input
    iids = dir(fullfile(theDir,'*.mat'));
    if (numel(iids)<1)
        fprintf('Statistics to be computed\n');
        return;
    end

    %Determine all video sequence names
    if (~isempty(onevideo))
        allvideonames={onevideo};
    else
        allvideonames=Scanallnames(iids);
    end

    %Transform raw elements of each video sequence according to options and bin results
    theaffinityname.name='resampled'; theaffinityname.adhocnbins=100; %adhocmin, adhocmax
    [thebins,tmpbin,bincenters,themin,themax,casefound]=Inittheparametercalibrationhistogram(theaffinityname); %#ok<NASGU,ASGLU>
    stats=struct();
    stats.numbersnonsparse=0; stats.totnumbers=0;
    totnpoints=0; totsumvol=0; totsumsqrdvol=0; totsumvolabth=0; totsumsqrdvolabth=0; totsumnconn=0; totsumsqrdnconn=0; totsumnconnabth=0; totsumsqrdnconnabth=0;
    fprintf('Video processing:');
    for i=1:numel(allvideonames)
        fprintf(' %d', i);

        includecompletion=false;
        similarities=Getsimilarityaggregated(theDir,allvideonames{i},options,includecompletion);
        noallsuperpixels=size(similarities,1);

        [sxa,sya,sva]=find(similarities);
    %     similarities2=sparse(sxa,sya,sva,noallsuperpixels,noallsuperpixels);
    %     isequal(similarities,similarities2)
    
        [npoints,sumvol,sumsqrdvol,sumvolabth,sumsqrdvolabth,sumnconn,sumsqrdnconn,sumnconnabth,sumsqrdnconnabth]=Getvolumestatistics(sxa,sya,sva,noallsuperpixels);
        totnpoints=totnpoints+npoints; totsumvol=totsumvol+sumvol; totsumsqrdvol=totsumsqrdvol+sumsqrdvol;
        totsumvolabth=totsumvolabth+sumvolabth; totsumsqrdvolabth=totsumsqrdvolabth+sumsqrdvolabth;
        totsumnconn=totsumnconn+sumnconn; totsumsqrdnconn=totsumsqrdnconn+sumsqrdnconn;
        totsumnconnabth=totsumnconnabth+sumnconnabth; totsumsqrdnconnabth=totsumsqrdnconnabth+sumsqrdnconnabth;

        thebins=Addtocalibrationparameterhistogram(bincenters,sva,thebins,printonscreeninsidefunction);
        %CAVEAT: values should actually been halved, as matrices are symmetric

        stats.numbersnonsparse=stats.numbersnonsparse+numel(sva);
        stats.totnumbers=stats.totnumbers+numel(similarities);

        if (printonscreeninsidefunction)
            figurenumber=10; usecumulative=false; doresampling=true; uselog=true;
            Plotaffinityplots(thebins,[],theaffinityname,{'similarities'},figurenumber,usecumulative,doresampling,uselog); %,usethiscolor,addtofigure
        end
    end
    fprintf('\n');
    
    stats.avgconnvalueabth=totsumvolabth/totsumnconnabth; %average edge value counting only edges above threshold
    stats.stdconnvalueabth= sqrt( totsumsqrdvolabth/totsumnconnabth - stats.avgconnvalueabth^2 );
    stats.avgconnvalue=totsumvol/totsumnconn; %average edge value
    stats.stdconnvalue= sqrt( totsumsqrdvol/totsumnconn - stats.avgconnvalue^2 );
    stats.avgnconnabth=totsumnconnabth/totnpoints; %average number of edges per node counting only edges above threshold
    stats.stdnconnabth= sqrt( totsumsqrdnconnabth/totnpoints - stats.avgnconnabth^2 );
    stats.avgnconn=totsumnconn/totnpoints; %average number of edges per node
    stats.stdnconn= sqrt( totsumsqrdnconn/totnpoints - stats.avgnconn^2 );
    stats.avgvolumeabth=totsumvolabth/totnpoints; %average volume per node
    stats.stdvolumeabth= sqrt( totsumsqrdvolabth/totnpoints - stats.avgvolumeabth^2 );
    stats.avgvolume=totsumvol/totnpoints; %average volume per node
    stats.stdvolume= sqrt( totsumsqrdvol/totnpoints - stats.avgvolume^2 );
    
    if (   (~isempty(rcname))   &&   ( ((exist(recordcasefile,'file'))&&(overwriterecord)) || (~exist(recordcasefile,'file')) )   )
        save(recordcasefile,'thebins','stats','theaffinityname','-v7.3');
        fprintf('Saved statistics %s\n',rcname);
    end
end



if (printonscreen)
    %TODO: include percentiles
    fprintf('Sparsity %g, total number of nodes %g\n',stats.numbersnonsparse/stats.totnumbers,stats.totnumbers);
    fprintf('Avg(std) volume per node %g (%g), avg(std) volume ab th per node %g (%g)\n',...
        stats.avgvolume,stats.stdvolume,stats.avgvolumeabth,stats.stdvolumeabth);
    fprintf('Avg(std) edge value %g (%g), avg(std) edge ab th value %g (%g)\n',...
        stats.avgconnvalue,stats.stdconnvalue,stats.avgconnvalueabth,stats.stdconnvalueabth);
    fprintf('Avg(std) n edges %g (%g), avg(std) n edges ab th %g (%g)\n',...
        stats.avgnconn,stats.stdnconn,stats.avgnconnabth,stats.stdnconnabth);
    
    %Print accumulated similarity values
    figurenumber=10; usecumulative=false; doresampling=true; uselog=true;
    Plotaffinityplots(thebins,[],theaffinityname,{'similarities'},figurenumber,usecumulative,doresampling,uselog,usethiscolor,addtofigure);
    
    %Print accumulated similarity values
    theallbins=thebins; theallbins(1)=theallbins(1)+stats.totnumbers-stats.numbersnonsparse;
    figurenumber=11; usecumulative=false; doresampling=true; uselog=true;
    Plotaffinityplots(theallbins,[],theaffinityname,{'similarities'},figurenumber,usecumulative,doresampling,uselog,usethiscolor,addtofigure);

    %Print accumulated similarity values
    figurenumber=12; usecumulative=true; doresampling=true; uselog=true;
    Plotaffinityplots(thebins,[],theaffinityname,{'similarities'},figurenumber,usecumulative,doresampling,uselog,usethiscolor,addtofigure);
    
    %Print accumulated similarity values
    figurenumber=13; usecumulative=true; doresampling=true; uselog=true;
    Plotaffinityplots(theallbins,[],theaffinityname,{'similarities'},figurenumber,usecumulative,doresampling,uselog,usethiscolor,addtofigure);
end

