function [asegmentation,allthesegmentations]=Retrievenewsegmentations(filenames,additionalmasname,aparticularvideo,aparticularsegmentation,printonscreen)

asegmentation=[];
allthesegmentations=[];

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=true;
end
if ( (~exist('aparticularvideo','var')) || (isempty(aparticularvideo)) )
    aparticularvideo=[];
end
if ( (~exist('aparticularsegmentation','var')) || (isempty(aparticularsegmentation)) )
    aparticularsegmentation=[];
end
if ( (~exist('additionalmasname','var')) || (isempty(additionalmasname)) )
    error('Region trajectories requested to compute higher-order affinities among tracks'); %The segmentation is assumed computed and loadable
end



%Assign input directory names and check existance of folders
onlyassignnames=true;
[sbenchmarkdir,imgDir,gtDir,inDir,isvalid] = Benchmarkcreatedirsimvid(filenames, additionalmasname, onlyassignnames); %#ok<ASGLU>
% [sbenchmarkdir,imgDir,gtDir,inDir,isvalid] = Benchmarkcreatedirs(filenames, additionalmasname, onlyassignnames); %#ok<ASGLU>
%imgDir images (for name listing), gtDir ground truth, inDir ucm2, outDir output
if (~isvalid)
    fprintf('Some Directories are not existing\n');
    return;
end



iids=Listacrossfoldersnoallsegs(inDir,'mat',Inf); % iids = dir(fullfile(inDir,'*.mat'));
% iids=Listacrossfolders(inDir,'mat',Inf); % iids = dir(fullfile(inDir,'*.mat'));


if (~isempty(aparticularvideo))
    [encimagevideo,encisvideo,aparticularvideo]=Collectoneimagevideoifavailable(iids,aparticularvideo); %aparticularvideo may be modified in the call to match the exact name
else
    considervideos=true;
    useordering=true;
    [encimagevideo,encisvideo]=Collectimagevideowithnamesnew(iids,considervideos,useordering);
end
% [encimagevideo,encisvideo]=Collectimagevideowithnames(iids,considervideos);
% fprintf('Encountered %d videos / images\n',numel(encimagevideo));
% isequal(encimagevideo,encimagevideo2)
% isequal(encisvideo,encisvideo2)




for i = 1:numel(encimagevideo)
    
    casename = encimagevideo{i}.videoimagenamewithunderscores;
    if ( (~isempty(aparticularvideo)) && (~strcmp(casename,aparticularvideo)) ) % A policy for images may be introduced based on (considervideos)
        continue;
    end
 
    %Retrieve image / video variables
    videodetected=encisvideo(i);
    videoimagename=encimagevideo{i}.videoimagename;
    nframes=encimagevideo{i}.nframes;
    fnames=encimagevideo{i}.fnames;
    videoimagenamewithunderscores=encimagevideo{i}.videoimagenamewithunderscores;
 
    
    
    %Prepare inFile (either all segs or the single files)
    inFile=Prepareinfile(videodetected,videoimagename,inDir,iids);
    
    
    
    if (~iscell(inFile))
        tmpfile=inFile; clear inFile; inFile=cell(1); inFile{1}=tmpfile;
    end

    allthesegmentations=Loadvideofrominfile(inFile);


    
    fprintf('Showing video: %s - %s\n',additionalmasname,casename);
    allclusternumbers=zeros(1,numel(allthesegmentations));
    for lev=1:numel(allthesegmentations)
        numberofclusters=numel(unique(allthesegmentations{lev})); %Others(0) and outliers(-1) labels are counted in the number
        allclusternumbers(lev)=numberofclusters;

        if (  (~isempty(aparticularsegmentation))  &&...
                ~( (aparticularsegmentation==numberofclusters) || (isinf(aparticularsegmentation)&&(lev==numel(allthesegmentations))) )  )
            continue;
        end

        fprintf(' lev %d (clusters %d) ',lev,numberofclusters);
        
        asegmentation=Doublebackconv(allthesegmentations{lev}); %The variable remains assigned to the requested video
        
        if (printonscreen)
            Printthevideoonscreen(asegmentation, true, 5, true,[],false,true);
                %thevideo, printonscreen, nofigure, toscramble, showcolorbar, writethevideo,treatoutliers,outputfile,printthetext
    %         Printthevideoonscreen(cim, true, 5, false,[],true,false,'Sequence.avi'); %write original video
    %         Printthevideoonscreen(asegmentation, true, 5, false,[],true,true,'Sequence.avi'); %same as before but saved
    %         Printthevideoonscreensuperposed(asegmentation, true, 1, true, [], false, true, cim,[]); %same as before but superposed
    %         Printthevideoonscreensuperposed(asegmentation, true, 1, true, [], true, true, cim,[],'Sequence.avi'); %same as before but superposed and saved
                %thevideo, printonscreen, nofigure, toscramble, showcolorbar, writethevideo,treatoutliers,cim,mixpropvideo,outputfile,printthetext
        end
    end
    fprintf('\n');
    fprintf('Available cluster numbers '); fprintf('%d ',allclusternumbers); fprintf('\n');
end
fprintf('\n');


