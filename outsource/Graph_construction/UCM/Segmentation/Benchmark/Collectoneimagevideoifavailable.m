function [encimagevideo,encisvideo,videoimagenamewithunderscores]=Collectoneimagevideoifavailable(iids,onevideoimage)


justvideoimage=false; useordering=false; comparealsounderscore=true; comparealsofolders=true;
[videodetected,videoimagename,fnames,nframes]=Detectvideonew(iids,[],onevideoimage,justvideoimage,useordering,comparealsounderscore,comparealsofolders);
videoimagenamewithunderscores=strrep(videoimagename, filesep, '_');



if ( (isempty(nframes)) || (nframes==0) )
    
    encisvideo=false(0);
    encimagevideo=cell(0);
    videoimagenamewithunderscores=onevideoimage;

else

    %Add the one found item
    encisvideo=false(1); %encisvideo=[encisvideo,false]
    encisvideo(1)=videodetected;

    encimagevideo=cell(1);
    encimagevideo{1}=struct;
    encimagevideo{1}.videoimagename=videoimagename;
    encimagevideo{1}.nframes=nframes;
    encimagevideo{1}.fnames=fnames;
    encimagevideo{1}.videoimagenamewithunderscores=videoimagenamewithunderscores;

end



