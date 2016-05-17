function Writebtrajectories(btrajectories,videosize,borigtracksrewtmp)

noFrames=videosize(3);

if (~exist('borigtracksrewtmp','var') || (isempty(borigtracksrewtmp)) )
    %Just for testing the code
    borigtracksrewtmp=[filenames.filename_directory,'borigtracksrew.dat'];
end

%Re-write the btrajectories to file using the format of BroxMalikECCV10
%and truncating them at the indicated noFrames
notraj=numel(btrajectories);

%Count and exclude btrajectories outside range
count=0;
for i=1:notraj
    if (btrajectories{i}.startFrame>noFrames)
        continue;
    end
    count=count+1;
end
notrajincl=count;

alllabels=zeros(1,notrajincl);

fid=fopen(borigtracksrewtmp,'wt');
fprintf(fid,'%d\n%d\n',noFrames,notrajincl);

count=0;
for i=1:notraj
    if (btrajectories{i}.startFrame>noFrames)
        continue;
    end
    count=count+1;
    thelength=min(btrajectories{i}.endFrame,noFrames)-btrajectories{i}.startFrame+1;
    fprintf(fid,'%d %d\n',btrajectories{i}.nopath-1,thelength);
    alllabels(count)=btrajectories{i}.nopath;
    for f=btrajectories{i}.startFrame:min(btrajectories{i}.endFrame,noFrames)
        pos=f-btrajectories{i}.startFrame+1;
        fprintf(fid,'%f %f %d\n',btrajectories{i}.Xs(pos)-1,btrajectories{i}.Ys(pos)-1,f-1);
    end
end

fclose(fid);

fprintf('%d trajectories included, %d labels identified\n',notrajincl, numel(unique(alllabels)));
