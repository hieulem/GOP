function [btrajectories,noblabels]=Readbroxtrajectories(inputfilename)
%[btrajectories,noblabels]=Readbroxtrajectories(inputfilename);

if (~exist('inputfilename','var') || (isempty(inputfilename)) )
    btrajectories=[];
    noblabels=[];
    fprintf('Please specify a filename to load btrajectories\n');
    return;
%     inputfilename=['/BS/galasso_proj_spx/work/VideoProcessingTemp/Carsone/','gtimages',filesep,'Tracks',num2str(19,'%d'),'.dat'];
%     inputfilename=[filenames.filename_directory,'Tracks',num2str(nobframes,'%d'),'generated.dat'];
end

if (~exist(inputfilename,'file'))
    btrajectories=[];
    noblabels=[];
    fprintf('Could not open the file to load btrajectories\n');
    return;
end

fid = fopen(inputfilename,'rt');

tline = fgetl(fid);
%nobframes is read but not used
nobframes=str2double(tline); %#ok<NASGU> 
tline = fgetl(fid);
notraj=str2double(tline);

btrajectories=cell(1,notraj);
allthelabels=zeros(1,notraj);
for i=1:notraj
    
    tline = fgetl(fid); %trajectory header
    if ( (numel(tline)==1) && (tline==-1) )
        fprintf('File ended prematurely\n');
        break;
    end
    startpos=1;
    [thelabel,startpos]=Findnextnumber(tline,startpos,' ');
    thelabel=thelabel+1; %because first label in BM is 0
    allthelabels(i)=thelabel;
    [trajlength,startpos]=Findnextnumber(tline,startpos,' '); %#ok<NASGU>
    btrajectories{i}.nopath=thelabel;
    btrajectories{i}.totalLength=trajlength;
    btrajectories{i}.Xs=zeros(1,trajlength);
    btrajectories{i}.Ys=zeros(1,trajlength);
    
    for j=1:trajlength
        tline = fgetl(fid); %trajectory per frame
        
        if ( (numel(tline)==1) && (tline==-1) )
            fprintf('File ended prematurely\n');
            break;
        end

        startpos=1;
        [xx,startpos]=Findnextnumber(tline,startpos,' ');
        [yy,startpos]=Findnextnumber(tline,startpos,' ');
        [ff,startpos]=Findnextnumber(tline,startpos,' '); %#ok<NASGU>
        xx=xx+1; yy=yy+1; ff=ff+1;
        
        btrajectories{i}.Xs(j)=xx;
        btrajectories{i}.Ys(j)=yy;
        
        if (j==1)
            btrajectories{i}.startFrame=ff;
        end
        if (j==trajlength)
            btrajectories{i}.endFrame=ff;
        end
    end
    
    if ( (numel(tline)==1) && (tline==-1) )
        fprintf('File ended prematurely\n');
        break;
    end
end
% fprintf(fid,'%d %d\n%d %d %d\n',labelledvideo(yy,xx,i),1,xx-1,yy-1,i-1);

fclose(fid);

%some labels may be empty so we use maximum label
noblabels=max(allthelabels);
fprintf('%d unique labels, %d max label\n',numel(unique(allthelabels)),noblabels)

