function allcodes=Bmcreatebestcases(allcodes,theDir,outDir)

bestcodename='Cbest';

%Add the new code to allcodes
allcodes{numel(allcodes)+1}=bestcodename;



%Filename for all tracks (all the tracks filenames)
alltracks=sprintf([bestcodename,'_all_tracks.txt']);
fullalltracks = fullfile(outDir,alltracks);

yettoprocess=(~(length(dir(fullalltracks))==1));
if (~yettoprocess)
    fprintf('All tracks already written\n');
    return
end

%Filename for all shots (all the Def.dat filenames)
allshots=sprintf([bestcodename,'_all_shots.txt']);
fullallshots = fullfile(outDir,allshots);

yettoprocess=(~(length(dir(fullallshots))==1));
if (~yettoprocess)
    fprintf('All shots already written\n');
    return
end



%Extract sequence numbers and Def.dat filenames
thecode=allcodes{1};

iids = dir(fullfile(theDir,[thecode,'_*.txt']));
textallshots=cell(0);
textallcases=cell(0);
count=0;
for i=1:numel(iids)
    
    
    inFile = fullfile(theDir, iids(i).name);
    
    fid = fopen(inFile,'r');
    if fid==-1,
        fprintf('Could not open file %s for reading.',inFile);
        continue;
    end
    newtrack=fgetl(fid); %#ok<NASGU>
    newshot=fgetl(fid);
    fclose(fid);

    count=count+1;
    textallshots{count}=newshot;
    
    
    wheretheat=strfind(iids(i).name,'_');
    thecase=iids(i).name(wheretheat(1)+1:end-4);
    textallcases{count}=thecase;
end



%Extract cluster numbers from Def.dat files
nclusters=zeros(1,numel(textallshots));
for i=1:numel(textallshots)
    
    inFile = textallshots{i};
    
    fid = fopen(inFile,'r');
    if fid==-1,
        fprintf('Could not open file %s for reading.',inFile);
        continue;
    end
    for ll=1:4
        aline=fgetl(fid);
%         disp(aline);
    end
    fclose(fid);
    
    nclusters(i)=str2double(aline);
end
fprintf('Sequences:'); fprintf(' %s',textallcases{:}); fprintf('\n');
fprintf('Cluster numbers in sequences:'); fprintf(' %d',nclusters); fprintf('\n');
fprintf('Average number of clusters %f\n',mean(nclusters));




%Compose allShots and allTracks with nclusters and sequence names,
%if present in the directory
addclusters=0;
textallshots=cell(0);
textalltracks=cell(0);
count=0;
for i=1:numel(textallcases)
    
    afilename=fullfile(theDir, ['C',num2str(nclusters(i))+addclusters,'_',textallcases{i},'.txt']);
    
    if (exist(afilename,'file'))
        fid = fopen(afilename,'r');
        if fid==-1,
            fprintf('Could not open file %s for reading.',afilename);
            continue;
        end
        newtrack=fgetl(fid);
        newshot=fgetl(fid);
        fclose(fid);

        count=count+1;
        textalltracks{count}=newtrack;
        textallshots{count}=newshot;
    else
        fprintf('%s not found\n',afilename)
        continue;
    end
end



%Write the track and shot files
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



