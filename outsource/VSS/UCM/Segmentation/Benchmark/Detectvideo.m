function [videodetected,videoname,fnames,nframes]=Detectvideo(iids,i)

videodetected=false; videoname=[]; fnames=[]; nframes=[];



% basename= 'hey223123'
basename=iids(i).name(1:end-4);

nonnumberpos=Getnamepos(basename);
if (isempty(nonnumberpos))
    % Filenames containing only numbers return [] and are not considered for videos
    return;
end



videoname=iids(i).name(1:nonnumberpos);
count=0;
fnames=cell(0);
for k=1:numel(iids)
    
    if ( (numel(iids(k).name)>=nonnumberpos) && (strcmp(videoname,iids(k).name(1:nonnumberpos))) )
        
        newbasename=iids(k).name(1:end-4);
        
        %Additional check to exclude names with the same initial part
        thenewnonnumberpos=Getnamepos(newbasename); %check with isempty is not needed as the initial part is already the same as basename
        if ( (~isempty(thenewnonnumberpos)) && (thenewnonnumberpos==nonnumberpos) )
            
            fnames{numel(fnames)+1}=newbasename;
            count=count+1;
            
        end
        
    end
end

if (count>1)
    videodetected=true;
    nframes=count;
end

