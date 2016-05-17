function [result,averages]=Readbmetrics(basedrive,bmetricsname)
% [result,averages]=Readbmetrics(basedrive);

%filename_sequence_basename_frames_or_video:
%bdeffileorig, bdeffile, bdeffileframes, bdeffilenb, bdeffilenbf, btracksfile

if ( (~exist('bmetricsname','var')) || (isempty(bmetricsname)) )
    bmetricsname='bvotingNumbers.txt'; %'bvotingNumbers.txt','borigtracksrewNumbers.txt'
end

ucmfilename='UCMals.m';

result=struct; result.case=cell(0); result.numbers=[];
averages=[];

fid = fopen(ucmfilename);

nocases=0;
currentcase=''; %this should never be used
currentcasefound=false;
while (true)
    
    tline = fgetl(fid);
    
    if ( (numel(tline)==1) && (tline==-1) )
%         fprintf('End of file reached\n');
        break;
    end
    
    %Only read non-empty lines
    if (numel(tline)<=0)
        continue;
    end
    
    if ( (numel(tline)>=3) && (strcmp(tline(1:3),'%%%')) ) %three % denote a new case name
        currentcase=tline(4:end);
        currentcasefound=true;
%         fprintf('%s ',currentcase);
        continue;
    end
    
    addbnamesfuncstr='filename_sequence_basename_frames_or_video=Addbnames';
    if ( (numel(tline)>53) && (strcmp(tline(1:52),addbnamesfuncstr)) && (currentcasefound) ) %Addbnames function denotes a bmetric applicable

        bmetricsfile=[basedrive,'VideoProcessingTemp',filesep,currentcase,filesep,bmetricsname];
        if (exist(bmetricsfile,'file'))
            thenumbers=Readbnumbers(bmetricsfile);

            nocases=nocases+1;
            result.case{nocases}=currentcase;
            for i=1:numel(thenumbers)
                result.numbers(nocases,i)=thenumbers(i);
            end
        
            fprintf('%s:',result.case{nocases});
            fprintf(' %f',result.numbers(nocases,:));
            fprintf('\n');
        end
        currentcasefound=false;
    end
end
fclose(fid);

fprintf('Cases %d, averages:\n', numel(result.case));
averages=mean(result.numbers,1);

disp(averages)




%Density (in percent)
%Overall (per pixel) clustering error (in percent)
%Average (per region) clustering error (in percent)
%Number of clusters merged
%Regions with less than 10%

