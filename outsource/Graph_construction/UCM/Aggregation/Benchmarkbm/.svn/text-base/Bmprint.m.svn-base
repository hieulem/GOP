function Bmprint(thecode, outDir)

%Filename for all tracks (all the tracks filenames)
trackresults=sprintf('%s_all_tracksNumbers.txt',thecode);
fulltrackresults = fullfile(outDir,trackresults);

yettoprocess=(~(length(dir(fulltrackresults))==1));
if (yettoprocess)
    fprintf('All track results to be gathered\n');
    return
end



fprintf('\n\n%s\n\n\n',trackresults);
fid = fopen(fulltrackresults,'r');
if fid==-1,
    fprintf('Could not open file %s for reading.',fulltrackresults);
    return;
end
anewline=fgetl(fid);
while (ischar(anewline))
    fprintf('%s\n',anewline);
    anewline=fgetl(fid);
end
fclose(fid);
