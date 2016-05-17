function [asegmentation,allthesegmentations]=Retrievevideosegmentations(filenames,additionalmasname,aparticularvideo,aparticularsegmentation,printonscreen)

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



iids = dir(fullfile(inDir,'*.mat'));
for i = 1:numel(iids)
    
    if (~strcmp(iids(i).name(1:7),'allsegs'))
        continue;
    end
    
    casename=iids(i).name(8:end-4);
    if (isempty(casename))
        fprintf('Casename empty\n');
    end
    
    if ( (~isempty(aparticularvideo)) && (~strcmp(aparticularvideo,casename)) )
        continue;
    end
    
    inFile = fullfile(inDir, iids(i).name);
    load(inFile); % allthesegmentations
    
    fprintf('Showing video: %s - %s\n',additionalmasname,casename);
    allclusternumbers=zeros(1,numel(allthesegmentations)); %#ok<USENS>
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


