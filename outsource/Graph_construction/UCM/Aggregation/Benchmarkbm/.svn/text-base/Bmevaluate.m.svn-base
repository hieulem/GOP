function Bmevaluate(thecode, outDir)

%Filename for all tracks (all the tracks filenames)
alltracks=sprintf('%s_all_tracks.txt',thecode);
fullalltracks = fullfile(outDir,alltracks);

yettoprocess=(~(length(dir(fullalltracks))==1));
if (yettoprocess)
    fprintf('All tracks to be gathered\n');
    return
end

%Filename for all shots (all the Def.dat filenames)
allshots=sprintf('%s_all_shots.txt',thecode);
fullallshots = fullfile(outDir,allshots);

yettoprocess=(~(length(dir(fullallshots))==1));
if (yettoprocess)
    fprintf('All shots to be gathered\n');
    return
end

%Output file
resulttracks=sprintf('%s_all_tracksNumbers.txt',thecode);
fullresulttracks = fullfile(outDir,resulttracks);

yettoprocess=(~(length(dir(fullresulttracks))==1));
if (~yettoprocess)
    fprintf('Evaluation results already computed\n');
    return
end




bfileexe=['UCM',filesep,'Aggregation',filesep,'Quantitative',filesep,'Broxcode',filesep,'MoSegEvalAll'];
bfilebis='MoSegEval';
if (~isdir('UCM'))
    fprintf('Please set your directory to the main folder\n');
    return;
else
    system( ['chmod u+x ',bfileexe] );
    system( ['chmod u+x ',bfilebis] );
    system( [bfileexe,sprintf(' %s all %s', fullallshots, fullalltracks)] );
end











        
        
