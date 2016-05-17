function [encimagevideo,encisvideo]=Collectimagevideowithnamesnew(iids,considervideos,useordering)

if ( (~exist('useordering','var')) || (isempty(useordering)) )
    useordering=false;
end
%The useordering option assumes that:
% - video are in alphabetical order (their frame number does not matter)
% - the function is launched with the first (in order) instance of the name (i)



encimagevideo=cell(0);
encisvideo=false(0); %encisvideo=[encisvideo,false]
count=0;
for i = 1:numel(iids)
    
    if (considervideos)
        justvideoimage=true;
        [videodetected,videoimagename,fnames,nframes]=Detectvideonew(iids,i,[],justvideoimage); %#ok<ASGLU> % disp(fnames(1))
        isvideoprocessed=Videoinstruct(encimagevideo,encisvideo,videoimagename);
        if (isvideoprocessed) % The video has already been processed
            continue;
        end
        
        justvideoimage=false;
        [videodetected,videoimagename,fnames,nframes]=Detectvideonew(iids,i,videoimagename,justvideoimage,useordering); % disp(fnames(1))
        % [videodetected,videoimagename,fnames,nframes]=Detectvideo(iids,i); % disp(fnames(1))
        videoimagenamewithunderscores=strrep(videoimagename, filesep, '_');
    else
        videodetected=false;
    end
    
    
    
    %Avoid considering videos twice (already checked above)
%     if (videodetected)
%         isvideoprocessed=Videoinstruct(encimagevideo,encisvideo,videoimagename);
%         if (isvideoprocessed) % The video has already been processed
%             continue;
%         end
%     end
    
    
    
    %Adopt format of images to videos
    if (~videodetected)
        videoimagename=iids(i).name(1:end-4); %Remove extension
        videoimagenamewithunderscores=strrep(videoimagename, filesep, '_');
        nframes=[]; %placeholder
        fnames=[]; %placeholder
    end
    
    
    
    %Add new item
    count=count+1;
    encisvideo(count)=videodetected;
    encimagevideo{count}=struct;
    encimagevideo{count}.videoimagename=videoimagename;
    encimagevideo{count}.nframes=nframes;
    encimagevideo{count}.fnames=fnames;
    encimagevideo{count}.videoimagenamewithunderscores=videoimagenamewithunderscores;
end
