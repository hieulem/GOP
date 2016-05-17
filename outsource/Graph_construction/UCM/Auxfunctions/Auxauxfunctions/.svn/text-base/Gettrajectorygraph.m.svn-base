function Gettrajectorygraph(notrajectory,filenames,trajectories,allregionpaths,ucm2,...
    allregionsframes,selectedtreetrajectories,cim,savevideofile,printonscreen,upwhichlevel,keephighestlevels,howmanyframes)

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('howmanyframes','var')) )
    howmanyframes=[];
end
if ( (~exist('upwhichlevel','var')) )
    upwhichlevel=[];
end
if ( (~exist('keephighestlevels','var')) || (isempty(keephighestlevels)) )
    keephighestlevels=true;
end
if ( (~exist('savevideofile','var')) || (isempty(savevideofile)) )
    savevideofile=false;
end
saveworkfiles=false;



if (exist(filenames.the_gif_file,'file'))
    load(filenames.the_gif_file);
else
    fprintf('Gif needs to be pre-computed\n');
    return;
end



% [allGis,tlevelone]=Computeallgisatveryhighestlevel(Gif,howmanyframes,upwhichlevel,keephighestlevels);
[allGis,tlevelone]=Computeallgisathighestlevel(Gif,howmanyframes,upwhichlevel,keephighestlevels);



notrack=find(allGis.mapTracToTrajectories==notrajectory,1,'first');
if (isempty(notrack))
    fprintf('Please selected a trajectory among the tree selected or double check that the selection be in the clustering range\n');
    return;
end
subtreetrajectories=false(size(selectedtreetrajectories));
subtreetrajectories(allGis.mapTracToTrajectories(tlevelone(notrack,:)))=true;
subtreetrajectories= selectedtreetrajectories & subtreetrajectories;

count=0;
clear sp;
tmptrackLength=1;
for frame=trajectories{notrajectory}.startFrame:trajectories{notrajectory}.endFrame
    count=count+1;

    theimage=cim{frame}; %should only be necessary if printonscreen == true

    %The following is to be used, then allDs are computed on request
    [track,mapTracToTrajectories,dist_track_mask]=... %,all_the_lengths
        Prepareregiontracksonrequest(trajectories,frame,tmptrackLength,allregionpaths,ucm2,allregionsframes,...
        filenames,subtreetrajectories,saveworkfiles,printonscreen,theimage);
    noTracks=size(track,3); %=size(dist_track_mask,2)

    thecorrespondingtrack=find(mapTracToTrajectories==notrajectory,1,'first');
    
    allothers=1:size(dist_track_mask,2);
    allothers(thecorrespondingtrack)=[];
    allweights=zeros(1,numel(allothers));
    thecorrespondingtrackinallgis=Translatefromfirsttosecond(mapTracToTrajectories,thecorrespondingtrack,allGis.mapTracToTrajectories);
    for i=1:numel(allothers)
        trackinallgis=Translatefromfirsttosecond(mapTracToTrajectories,allothers(i),allGis.mapTracToTrajectories);
        allweights(i)=allGis.P(thecorrespondingtrackinallgis,trackinallgis);
    end
    
    nofigure=16;
    Representgraphconnections(track,dist_track_mask,theimage,thecorrespondingtrack,allweights,nofigure)
    
%     T=false(noTracks);
%     T(thecorrespondingtrack,:)=true;
%     T= ( T | (T') );
%     Representspanningtreeatcentre(T,track,dist_track_mask,theimage);
    
    figure(16), title(['Frame ',num2str(frame)]);
    if (savevideofile)
        sp(count)=getframe;
        % print('-depsc',['C:\Epsimages\sp',num2str(nframe),'.eps']);
    end
end
if (savevideofile)
    filenamepicorvideobasename=[filenames.idxpicsandvideobasedir,'Videos',filesep];
    movie2avi(sp,[filenamepicorvideobasename,'graph_trajectory_',num2str(notrajectory),'.avi'],'compression','None','fps',7);
end








