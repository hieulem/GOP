function Parametercalibrationbench(theDir, outDir, justavideo)

if (~exist('justavideo','var'))
    justavideo=[];
end
if (isempty(justavideo))
    analyzeonevideo=false;
else
    analyzeonevideo=true;
end



%Init data structures
allthescores.affinities=cell(0);
allthescores.scores=cell(0);



%List of files in Input
iids = dir(fullfile(theDir,'*.txt'));
if (numel(iids)<1)
    fprintf('Statistics to be computed\n');
    return;
end
fprintf('Evaluating scores:');
for i = 1:numel(iids)
    
    [thepath, thename, theext] = fileparts(iids(i).name); if (~isempty(thepath)), fprintf('This dir name %s should be empty\n', thepath); end %#ok<NASGU>
    
    inFile= fullfile(theDir, iids(i).name); %[thename, theext]

    [thevideoname,theaffinity]=Findthecaseandaffinity(thename);
    score = dlmread(inFile);
    
    %Option to only analyse a video
    if ( (analyzeonevideo) && (~strcmp(thevideoname,justavideo)) )
        continue;
    end
    

    [allthescores]=Findaddcheckvideoandcase(allthescores,theaffinity,score);
    
    if (mod(i,20)==0), fprintf(' %d', i); end
end
fprintf('\n');



for i=1:numel(allthescores.affinities)
    
    Writenotcomputed(outDir,allthescores.affinities{i},allthescores.scores{i});
    
end









