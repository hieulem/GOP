function Writeblabelledvideo(labelledvideo,outputfilename)
%Writeblabelledvideo(labelledvideo,outputfilename);
%The written trajectories (minimum label 1) get labels minus 1

videosize=size(labelledvideo);
noFrames=videosize(3);
dimIx=videosize(2);
dimIy=videosize(1);

if (~exist('outputfilename','var') || (isempty(outputfilename)) )
    %Just for testing the code
    outputfilename=['Tracks',num2str(noFrames,'%d'),'generated.dat'];
end

%Write labelledvideo to file using the format of BroxMalikECCV10
%zero values in labelledvideo are considered unlabelled
notraj=sum(sum(sum(labelledvideo>0)));

fid=fopen(outputfilename,'wt');
fprintf(fid,'%d\n%d\n',noFrames,notraj);
% fprintf(fid,'%d\n%013d\n',noFrames,notraj);

fprintf('Writing to disk, processed frames:');
for i=1:noFrames
    for xx=1:dimIx
        for yy=1:dimIy
            if (labelledvideo(yy,xx,i)>0)
                fprintf(fid,'%d %d\n%d %d %d\n',labelledvideo(yy,xx,i)-1,1,xx-1,yy-1,i-1);
            end
        end
    end
    fprintf(' %d',i);
end
fprintf('\n');

fclose(fid);


assignedidxs=unique(labelledvideo);
outmzero=find(assignedidxs<0);
nooutliers=0;
if (~isempty(outmzero))
    nooutliers=numel(outmzero);
    assignedidxs(outmzero)=[]; %so the outliers <0 are not considered among the assigned, nor any IDX<=0
end
numberassignedidxs=numel(assignedidxs);

fprintf('%d btrajectories (single point tracks), %d labels identified, %d outlier labels (<0)\n',notraj, numberassignedidxs, nooutliers);
