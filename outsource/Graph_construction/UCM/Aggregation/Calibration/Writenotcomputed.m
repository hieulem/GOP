function Writenotcomputed(outDir,theaffinity,thescore)
%theaffinity=allthescores.affinities{1};thescore=allthescores.scores{1};

thecasename=[theaffinity,'.txt'];
thecasefile=fullfile(outDir, thecasename);

%Check if existing
yettoprocess=(~(length(dir(thecasefile))==1));
if (~yettoprocess)
    fprintf('Affinity file %s existing\n',thecasename);
    return
end

%Write affinity to outdir
fid = fopen(thecasefile,'w');
if fid==-1,
    error('Could not open file %s for writing.',thecasefile);
end
fprintf(fid,'%10g %10g\n',...
    thescore');
fclose(fid);
fprintf('Affinity file %s written\n',thecasename);
