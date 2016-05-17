function allthesegmentations=Loadallsegs(filenames,options)
%options.newsegname='Segmcfalloptvlt';

allthesegmentations=[];

if ( (isfield(options,'newsegname')) && (~isempty(options.newsegname)) )
    additionalmasname=options.newsegname;
else
    return;
end

thecase=filenames.casedirname;

%Assign input directory names and check existance of folders
onlyassignnames=true;
[sbenchmarkdir,imgDir,gtDir,inDir,isvalid] = Benchmarkcreatedirsimvid(filenames, additionalmasname, onlyassignnames); %#ok<ASGLU>
% [sbenchmarkdir,imgDir,gtDir,inDir,isvalid] = Benchmarkcreatedirs(filenames, additionalmasname, onlyassignnames); %#ok<ASGLU>
%imgDir images (for name listing), gtDir ground truth, inDir ucm2, outDir output
if (~isvalid)
    return;
end


iids = dir(fullfile(inDir,'*.mat'));
for i = 1:numel(iids)
    
    if (~strcmp(iids(i).name(1:7),'allsegs'))
        continue;
    end
    
    casename=iids(i).name(8:end-4);
    if (isempty(casename))
        fprintf('Casename empty\n');
    end
    
    if (~strcmp(thecase,casename))
        continue;
    end
    
    inFile = fullfile(inDir, iids(i).name);
    load(inFile); % allthesegmentations

    break;
end

