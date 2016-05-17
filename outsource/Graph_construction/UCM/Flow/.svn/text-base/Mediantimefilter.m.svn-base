function [newflows,flowwasmodified]=Mediantimefilter(flows,framedepth,twolessedges)

if ( (~exist('twolessedges','var')) || (isempty(twolessedges)) )
    twolessedges=false;
    %option to exclude one flow from the edge frames, unless already excluded at the first and last frames
end
if ( (~exist('framedepth','var')) || (isempty(framedepth)) )
    framedepth=1;
end

newflows=flows;

flowwasmodified=false;

noFrames=numel(flows.flows);

dimi=size(flows.flows{1}.Up,1);
dimj=size(flows.flows{1}.Up,2);
numberofpixels=dimi*dimj;

[U,V]=meshgrid(1:dimj,1:dimi); %pixel coordinates

newvelup=zeros([dimi,dimj]);
newvelvp=zeros([dimi,dimj]);
for f=1:noFrames
    
    if (flows.whichDone(f)>=2) %so the filtering process is not reiterated out of mistake
        continue;
    end
    
    firstframe=max(1,f-framedepth);
    lastframe=min(noFrames,f+framedepth);
    
    numbertocount=(lastframe-firstframe)*2;
    if (numbertocount<1)
        fprintf('Frame %d not filetered\n',f);
        continue;
    end
    if (twolessedges)
        if (firstframe==f-framedepth)
            numbertocount=numbertocount-1;
        end
        if (lastframe==f+framedepth)
            numbertocount=numbertocount-1;
        end
    end
    
    alltheflowsu=zeros(numberofpixels,numbertocount);
    alltheflowsv=zeros(numberofpixels,numbertocount);
    
    count=0;
    for af=firstframe:lastframe
        [velUm,velVm,velUp,velVp]=GetUandV(flows.flows{af});
        if (af<lastframe)
            if ( (~twolessedges) || (af~=(f-framedepth)) ) %extra check
                count=count+1;
                alltheflowsu(:,count)=velUp(:);
                alltheflowsv(:,count)=velVp(:);
            end
        end
        if (af>firstframe)
            if ( (~twolessedges) || (af~=(f+framedepth)) ) %extra check
                count=count+1;
                alltheflowsu(:,count)=-velUm(:);
                alltheflowsv(:,count)=-velVm(:);
            end
        end
    end
    
    newvelup(:)=median(alltheflowsu,2);
    newvelvp(:)=median(alltheflowsv,2);
    
    newflows.flows{f}.Up=newvelup+U;
    newflows.flows{f}.Vp=newvelvp+V;
    
    newflows.flows{f}.Um=-newvelup+U;
    newflows.flows{f}.Vm=-newvelvp+V;
    
    newflows.whichDone(f)=2; %2 in whichDone will identify a temporal median filtered flow
    flowwasmodified=true;
end



function [newflows,flowwasmodified]=Mediantimefilter_backup_nolessedges(flows,framedepth) %#ok<DEFNU>

if ( (~exist('framedepth','var')) || (isempty(framedepth)) )
    framedepth=1;
end

newflows=flows;

flowwasmodified=false;

noFrames=numel(flows.flows);

dimi=size(flows.flows{1}.Up,1);
dimj=size(flows.flows{1}.Up,2);
numberofpixels=dimi*dimj;

[U,V]=meshgrid(1:dimj,1:dimi); %pixel coordinates

newvelup=zeros([dimi,dimj]);
newvelvp=zeros([dimi,dimj]);
for f=1:noFrames
    
    if (flows.whichDone(f)>=2) %so the filtering process is not reiterated out of mistake
        continue;
    end
    
    firstframe=max(1,f-framedepth);
    lastframe=min(noFrames,f+framedepth);
    
    numbertocount=(lastframe-firstframe)*2;
    if (numbertocount<1)
        fprintf('Frame %d not filetered\n',f);
        continue;
    end
    
    alltheflowsu=zeros(numberofpixels,numbertocount);
    alltheflowsv=zeros(numberofpixels,numbertocount);
    
    count=0;
    for af=firstframe:lastframe
        [velUm,velVm,velUp,velVp]=GetUandV(flows.flows{af});
        if (af<lastframe)
            count=count+1;
            alltheflowsu(:,count)=velUp(:);
            alltheflowsv(:,count)=velVp(:);
        end
        if (af>firstframe)
            count=count+1;
            alltheflowsu(:,count)=-velUm(:);
            alltheflowsv(:,count)=-velVm(:);
        end
    end
    
    newvelup(:)=median(alltheflowsu,2);
    newvelvp(:)=median(alltheflowsv,2);
    
    newflows.flows{f}.Up=newvelup+U;
    newflows.flows{f}.Vp=newvelvp+V;
    
    newflows.flows{f}.Um=-newvelup+U;
    newflows.flows{f}.Vm=-newvelvp+V;
    
    newflows.whichDone(f)=2; %2 in whichDone will identify a temporal median filtered flow
    flowwasmodified=true;
end

