function [deffilebase,valid]=Locatefiledir(bdeffile,dir1,dir2,dir3)
%The dirX strings must include a filesep

valid=true;
if ( (exist('dir1','var')) && (exist([dir1,bdeffile],'file')) )
    deffilebase=dir1;
elseif ( (exist('dir2','var')) && (exist([dir2,bdeffile],'file')) )
    deffilebase=dir2;
elseif ( (exist('dir3','var')) && (exist([dir3,bdeffile],'file')) )
    deffilebase=dir3;
else
    fprintf('Could not locate %s\n', bdeffile);
    deffilebase=filesep;
    valid=false;
end

