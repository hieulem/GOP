function Expandtheallsegsfiles(filenames,additionalmasname)

if ( (~exist('filenames','var')) || (isempty(filenames)) )
    filenames.benchmark=[pwd,filesep];
end
if (~isstruct(filenames))
    tmp=filenames; clear filenames; filenames.benchmark=tmp; clear tmp;
end

%Assign input directory names and check existance of folders
onlyassignnames=true;
[sbenchmarkdir,imgDir,gtDir,inDir,isvalid] = Benchmarkcreatedirsimvid(filenames, additionalmasname, onlyassignnames); %#ok<ASGLU>
%imgDir images (for name listing), gtDir ground truth, inDir ucm2, outDir output
if (~isvalid)
    fprintf('Some Directories are not existing\n');
    return;
end



iids=Listacrossfolders(imgDir,'jpg',Inf); % iids = dir(fullfile(imgDir,'*.jpg'));
encvideos=cell(0);
fprintf('Expanding all segs (out of %d):',numel(iids));
for i = 1:numel(iids)
    fprintf(' %d', i);
    
    [videodetected,videoimagename,fnames,nframes,fnumber]=Detectvideo(iids,i);
    videoimagenamewithunderscores=strrep(videoimagename, filesep, '_');
    
    if (~videodetected)
        fprintf('Could not detect video for images %s\n',iids(i).name);
        return;
    end
    
    if (videodetected)
        if (any(strcmp(encvideos,videoimagename))) % The video has already been processed
            continue;
        else
            encvideos{numel(encvideos)+1}=videoimagename;
        end
    end
    
    [allsegsvideoimagename,allsegsvideoimagedir]=Getallsegsvideoname(videoimagename);
    allsegfile=fullfile(inDir, ['allsegs',allsegsvideoimagename,'.mat']); % allsegfile=fullfile(inDir, ['allsegs',videoimagename,'.mat']);
    
    videoucmdir=fullfile(inDir,allsegsvideoimagedir);
    if (~exist(videoucmdir,'dir'))
        mkdir(videoucmdir);
    end
    
    [startpoint,spindex]=min(fnumber);
    
    thename=fnames{spindex};
    nfigures=numel(thename)-numel(videoimagename);
    
    if (nfigures==numel(num2str(startpoint)))
        fpres='%d';
    else
        fpres=sprintf('%%0%dd',nfigures);
    end
    
    %destination files are (for k=1:nframes) [inDir,videoimagename,num2str(startpoint+k-1, fpres),'.mat']
    %source file is allsegfile
    
    load(allsegfile)
%     fprintf('Source %s load\n',allsegfile);
    
    for k=1:size(allthesegmentations{1},3) %#ok<USENS> %[1,size(allthesegmentations{1},3)] 
        
        newmatfile=[inDir,videoimagename,num2str(startpoint+k-1, fpres),'.mat']; %load(newmatfile)
        
        if (exist(newmatfile,'file'))
            load(newmatfile);
            
            if (numel(allthesegmentations)~=numel(segs))
                fprintf('Video %s, different number of hierarchical layers\n',videoimagename);
                return;
            end
            for jj=1:numel(allthesegmentations)
                if ( ~isequal(allthesegmentations{jj}(:,:,k),segs{jj}) )
                    fprintf('Video %s, difference at frame %d layer %d\n',k,jj);
                    return;
                end
            end
        end
        
        segs=cell(size(allthesegmentations));
        for jj=1:numel(allthesegmentations)
            segs{jj}=allthesegmentations{jj}(:,:,k);
        end
        
        save(newmatfile,'segs');
%         fprintf('Dest (f=%d) %s write\n',k,newmatfile);
    end
        
end
fprintf('\n');






