function [videodetected,videoname,fnames,nframes,fnumber]=Detectvideonew(iids,i,providedvideoname,justvideoimage,useordering,comparealsounderscore,comparealsofolders)
%If a video name is provided, then the search will be done over iids
%ignoring i, else the video name will be extracted from iids at position i

videodetected=false; videoname=[]; fnames=[]; nframes=[]; fnumber=[];



if ( (~exist('useordering','var')) || (isempty(useordering)) )
    useordering=false;
end
%The useordering option assumes that:
% - video are in alphabetical order (their frame number does not matter)
% - the function is launched with the first (in order) instance of the name (i)
if ( (~exist('justvideoimage','var')) || (isempty(justvideoimage)) )
    justvideoimage=false;
end
if ( (~exist('comparealsounderscore','var')) || (isempty(comparealsounderscore)) )
    comparealsounderscore=false;
end
if ( (~exist('comparealsofolders','var')) || (isempty(comparealsofolders)) )
    comparealsofolders=false;
end



if ( (exist('providedvideoname','var')) && (~isempty(providedvideoname)) && (ischar(providedvideoname)) )
    
    videoname=providedvideoname;
    nonnumberpos=numel(videoname);
    
else

    % basename= 'hey223123'
    basename=iids(i).name(1:end-4);

    nonnumberpos=Getnamepos(basename);
    if (isempty(nonnumberpos))
        % Filenames containing only numbers return [] and are not considered for videos
        return;
    end

    videoname=iids(i).name(1:nonnumberpos);

    comparealsofolders=false; %This feature should only be used with provided video names
end



if (justvideoimage)
    return
end



count=0;
fnames=cell(0);
if (~useordering), initnum=1; else initnum=i; end
for k=initnum:numel(iids)
    
    if (   (numel(iids(k).name)>=nonnumberpos)   &&...
            (  (strcmp(videoname,iids(k).name(1:nonnumberpos)))  ||  ( comparealsounderscore && (strcmp(videoname,strrep(iids(k).name(1:nonnumberpos), filesep, '_'))) )  )...
            )
        
        newbasename=iids(k).name(1:end-4);
        
        %Additional check to exclude names with the same initial part
        thenewnonnumberpos=Getnamepos(newbasename); %check with isempty is not needed as the initial part is already the same as basename
        if (   (~isempty(thenewnonnumberpos))   &&...
                (  (thenewnonnumberpos==nonnumberpos)  ||  ( (comparealsofolders) && (thenewnonnumberpos>nonnumberpos) && (newbasename(nonnumberpos+1)==filesep) )  )...
                )
            
            fnames{numel(fnames)+1}=newbasename;
            count=count+1;
            
            if ( comparealsounderscore || comparealsofolders ) %update of videoname is not necessary in all cases but it does not harm
                %( comparealsounderscore && (strcmp(videoname,strrep(iids(k).name(1:nonnumberpos), filesep, '_'))) )
                
                videoname=iids(k).name(1:thenewnonnumberpos);
                %videoname=iids(k).name(1:nonnumberpos);
                nonnumberpos=thenewnonnumberpos;
            end %Note: as soon as one videoname is found the underscores are re-translated into filesep, if using comparealsounderscore, according to the first example
            
        else
            if (useordering)
                break;
            end
        end

    else
        if (useordering)
            break;
        end
    end
end

if (count>1)
    videodetected=true;
    nframes=count;
end


if (count>1)
    fnumber=zeros(1,count);
    for k=1:numel(fnames)
        thenewnonnumberpos=Getnamepos(fnames{k});
        fnumber(k) = str2double(  fnames{k}( (thenewnonnumberpos+1) : end )  );
    end
end
