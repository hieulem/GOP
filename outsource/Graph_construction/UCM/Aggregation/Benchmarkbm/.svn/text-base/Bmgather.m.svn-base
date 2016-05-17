function Bmgather(theDir, thecode, outDir)



%Filename for all tracks (all the tracks filenames)
alltracks=sprintf('%s_all_tracks.txt',thecode);
fullalltracks = fullfile(outDir,alltracks);

yettoprocess=(~(length(dir(fullalltracks))==1));
if (~yettoprocess)
    fprintf('All tracks already written\n');
    return
end

%Filename for all shots (all the Def.dat filenames)
allshots=sprintf('%s_all_shots.txt',thecode);
fullallshots = fullfile(outDir,allshots);

yettoprocess=(~(length(dir(fullallshots))==1));
if (~yettoprocess)
    fprintf('All shots already written\n');
    return
end



iids = dir(fullfile(theDir,[thecode,'_*.txt']));
textallshots=cell(0);
textalltracks=cell(0);
count=0;
for i=1:numel(iids)
    
    
    inFile = fullfile(theDir, iids(i).name);
    
    fid = fopen(inFile,'r');
    if fid==-1,
        fprintf('Could not open file %s for reading.',inFile);
        continue;
    end
    newtrack=fgetl(fid);
    newshot=fgetl(fid);
    fclose(fid);

    count=count+1;
    textalltracks{count}=newtrack;
    textallshots{count}=newshot;

end



fid = fopen(fullalltracks,'w');
if fid==-1,
    fprintf('Could not open file %s for writing.',fullalltracks);
    return;
end
for i=1:numel(textalltracks)
    fprintf(fid,'%s\n',textalltracks{i});
end
fclose(fid);

fid = fopen(fullallshots,'w');
if fid==-1,
    fprintf('Could not open file %s for writing.',fullallshots);
    return;
end
fprintf(fid,'%d\n',numel(textallshots));
for i=1:numel(textallshots)
    fprintf(fid,'%s\n',textallshots{i});
end
fclose(fid);









