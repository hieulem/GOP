function Getwarpedsequence(flows,cim,noFrames,useinterp,destbasename,numberformat,nameclosure,startnumber,printonscreen,howmanyframestowarpinbothdirs,ratios)

if ( (~exist('noFrames','var')) || (isempty(noFrames)) )
    noFrames=numel(flows.whichDone);
end
if ( (~exist('useinterp','var')) || (isempty(useinterp)) )
    useinterp=false;
end
if ( (~exist('destbasename','var')) || (isempty(destbasename)) )
    if (ispc)
        basedrive=['D:',filesep];
    else
        basedrive=[filesep,'media',filesep,'Data',filesep];
    end
    destbasename=[basedrive,'temp',filesep,'EWCmovwrp'];
end
if ( (~exist('numberformat','var')) || (isempty(numberformat)) )
    numberformat='%03d';
end
if ( (~exist('nameclosure','var')) || (isempty(nameclosure)) )
    nameclosure='.png';
end
if ( (~exist('startnumber','var')) || (isempty(startnumber)) )
    startnumber=0;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('howmanyframestowarpinbothdirs','var')) || (isempty(howmanyframestowarpinbothdirs)) )
    howmanyframestowarpinbothdirs=2;
end
if ( (~exist('ratios','var')) || (isempty(ratios)) )
    ratios=[];  %in this way default value defined in Getawarpedframenew is used (ratios=[2.25 1.5 1])
end

newcim=cell(1,noFrames);
for frame=1:noFrames
    newcim{frame}=Getawarpedframenew(flows,cim,frame,howmanyframestowarpinbothdirs,useinterp,noFrames,printonscreen,ratios);
%     newcim{frame}=Getwarpedframe(flows,cim,frame,howmanyframestowarpinbothdirs,useinterp,noFrames,printonscreen,ratios);
    
    tmpfilename=[destbasename,num2str(frame-1+startnumber,numberformat),nameclosure];
    imwrite(newcim{frame},tmpfilename) %the format is left implicit in the extension
%     imwrite(newcim{frame},tmpfilename,'png')
end




