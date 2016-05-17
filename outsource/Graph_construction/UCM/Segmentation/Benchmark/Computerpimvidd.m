function sum=Computerpimvid(filenames,nthresh,additionalmasname,requestdelconf,minimumimagenumber,curvecolor,plotsuperpose,considervideos,bmetrics,justavideo,outputdir,excludevideo,excludevideo2)
%Computerpimvid(filenames,99,'tttttSegm',true,0,true,'r')
% Fabio Galasso
% February 2014

if (~exist('justavideo','var'))
    justavideo=[];
end
if (~exist('outputdir','var'))
    outputdir=[]; %The default directory in additionalmasname is defined in the function Benchmarkcreateoutimvid
end
if ( (~exist('curvecolor','var')) || (isempty(curvecolor)) )
    curvecolor='r'; %rp curves color
end
if ( (~exist('plotsuperpose','var')) || (isempty(plotsuperpose)) )
    plotsuperpose=false; %superpose rp curves
end
if ( (~exist('minimumimagenumber','var')) || (isempty(minimumimagenumber)) )
    minimumimagenumber=0; %number of images to wait for starting computation (0 means no wait)
end
if ( (~exist('requestdelconf','var')) || (isempty(requestdelconf)) )
    requestdelconf=true;
end
if ( (~exist('nthresh','var')) || (isempty(nthresh)) )
    nthresh=5;
end
if ( (~exist('considervideos','var')) || (isempty(considervideos)) )
    considervideos=true;
end
if ( (~exist('bmetrics','var')) || (isempty(bmetrics)) )
    bmetrics={'bdry','regpr'}; %'bdry','3dbdry','regpr','sc','pri','vi','lengthsncl','all'
end
if ( (~exist('additionalmasname','var')) || (isempty(additionalmasname)) )
    additionalmasname='tttttSegm';
end
if ( (~exist('filenames','var')) || (isempty(filenames)) )
    filenames.benchmark=[pwd,filesep];
end
if (~isstruct(filenames))
    tmp=filenames; clear filenames; filenames.benchmark=tmp; clear tmp;
end

%Assign input directory names and check existance of folders
onlyassignnames=true;
[sbenchmarkdir,imgDir,gtDir,inDir,isvalid] = Benchmarkcreatedirsimvid(filenames, additionalmasname, onlyassignnames); %#ok<ASGLU>
%imgDir images (for name listing), gtDir ground truth, inDir ucm2, outDir output
if (~isvalid)
    fprintf('Some Directories are not existing\n');
    return;
end



%Check existance of output directory and request confirmation of deletion
onlyassignnames=true;
[sbenchmarkdir,outDir,isvalid] = Benchmarkcreateoutimvid(filenames, additionalmasname, onlyassignnames, outputdir); %#ok<ASGLU>
% if ( isvalid )
%     if (requestdelconf) %Setting requestdelconf to true deletes without requesting confirmation
%         theanswer = input('Remove previous output? [ 1 , 0 (default) ] ');
%     else
%         theanswer=1;
%     end
%     if ( (~isempty(theanswer)) && (theanswer==1) )
%         Removetheoutputimvid(filenames,additionalmasname,outputdir);
        isvalid=false;
%     end
% end
if (~isvalid)
    [sbenchmarkdir,outDir,isvalid] = Benchmarkcreateoutimvid(filenames, additionalmasname, [], outputdir); %#ok<ASGLU>
end



%Wait minimumimagenumber for processing
iids=Listacrossfolders(imgDir,'jpg',Inf); % iids = dir(fullfile(imgDir,'*.jpg'));
if (minimumimagenumber>0)
    while(numel(iids)<minimumimagenumber)
        pause(10);
        iids=Listacrossfolders(imgDir,'jpg',Inf); % iids = dir(fullfile(imgDir,'*.jpg'));
    end
    fprintf('All images are in the directory\n');
end
fprintf('%d images are in the folder (and first-level subfolders)\n',numel(iids));

 evFile6 = fullfile(outDir, strcat('fin2.txt')); %regpr

tic;
if (isvalid)
    [sum,bestFb,F_maxb,Area_PRb,bestFv,F_maxv,Area_PRv] = Benchmarksegmevalparallell(imgDir, gtDir, inDir, outDir, nthresh, [], [], bmetrics, considervideos,justavideo,excludevideo,excludevideo2)

    
    %     Benchmarksegmeval(imgDir, gtDir, inDir, outDir, nthresh, [], [], bmetrics, considervideos,justavideo);
 fid = fopen(evFile6, 'a');
    if fid == -1, 
        error('Could not open file %s for writing.', evFile6);
    end
    fseek(fid, 0, 'eof');
    fprintf(fid,'%10g %10g %10g %10g %10g %10g %10g %10g\n',[excludevideo,sum,bestFb,F_maxb,Area_PRb,bestFv,F_maxv,Area_PRv]');
    fclose(fid);
end
toc;



% tic
% if (isvalid)
%     Benchmarkevalstatsparallel(imgDir, gtDir, inDir, outDir, nthresh, [], [], bmetrics, considervideos, justavideo);
% %     Benchmarkevalstats(imgDir, gtDir, inDir, outDir, nthresh, [], [], bmetrics, considervideos, justavideo);
% end
% toc

delete(sprintf('%s/eval_regpr_globossods.txt', outDir));
delete(sprintf('%s/eval_regpr_globalthr.txt', outDir));
delete(sprintf('%s/eval_regpr_globossods.txt', outDir));
delete(sprintf('%s/eval_bdry_globalthr.txt', outDir));
delete(sprintf('%s/eval_bdry_segmbestrscores.txt', outDir));
delete(sprintf('%s/eval_*.txt', outDir));

% output=Plotsegmevall(outDir,plotsuperpose,curvecolor);

%     rmdir(sbenchmarkdir,'s')
%     rmdir(outDir,'s')





