function get_region_trajectories_and_purged(allregionsframes,mapPathToTrajectory,trajectories,allregionpaths,filenames)

trackLength=3;

noTracks=( sum( allregionpaths.totalLength>=trackLength ) - 1 ); %because we exclude the first frame, the full frame
region_trajectories.startFrame=zeros(1,noTracks);
region_trajectories.endFrame=zeros(1,noTracks);
region_trajectories.totalLength=zeros(1,noTracks);
region_trajectories.level=cell(1,noTracks);
region_trajectories.label=cell(1,noTracks);
count=0;
for i=2:numel(mapPathToTrajectory)
    if ( allregionpaths.totalLength(i)<trackLength )
        continue;
    end
    count=count+1;
    nopath=i;
    region_trajectories.startFrame(count)=allregionpaths.startPath(i);
    region_trajectories.endFrame(count)=allregionpaths.endPath(i);
    region_trajectories.totalLength(count)=allregionpaths.totalLength(i);
    region_trajectories.level{count}=zeros(1,allregionpaths.totalLength(i));
    region_trajectories.label{count}=zeros(1,allregionpaths.totalLength(i));
    kcount=0;
    for frame=allregionpaths.startPath(i):allregionpaths.endPath(i)
        kcount=kcount+1;
        region=Lookupregioninallregionpaths(allregionpaths,frame,nopath);
        region_trajectories.level{count}(kcount)=allregionsframes{frame}{region}.ll(1,1);
        region_trajectories.label{count}(kcount)=allregionsframes{frame}{region}.ll(1,2);
        
%         mask=Getthemask(ucm2{frame},region_trajectories.level{count}(kcount),region_trajectories.label{count}(kcount));
%         figure(3), imshow(mask)
    end
%     break;
end
if ( count~=noTracks )
    fprintf('Please check count\n');
end
save(filenames.filename_vijay_regiontrajectories, 'region_trajectories');

    
% sum(mapPathToTrajectory>0)
noTracks=( numel(trajectories) - 1 );
region_trajectories_purged.startFrame=zeros(1,noTracks);
region_trajectories_purged.endFrame=zeros(1,noTracks);
region_trajectories_purged.totalLength=zeros(1,noTracks);
region_trajectories_purged.level=cell(1,noTracks);
region_trajectories_purged.label=cell(1,noTracks);
count=0;
for i=2:numel(trajectories)
    count=count+1;
    nopath=trajectories{i}.nopath;
    region_trajectories_purged.startFrame(count)=trajectories{i}.startFrame;
    region_trajectories_purged.endFrame(count)=trajectories{i}.endFrame;
    region_trajectories_purged.totalLength(count)=trajectories{i}.totalLength;
    region_trajectories_purged.level{count}=zeros(1,trajectories{i}.totalLength);
    region_trajectories_purged.label{count}=zeros(1,trajectories{i}.totalLength);
    kcount=0;
    for frame=trajectories{i}.startFrame:trajectories{i}.endFrame
        kcount=kcount+1;
        region=Lookupregioninallregionpaths(allregionpaths,frame,nopath);
        region_trajectories_purged.level{count}(kcount)=allregionsframes{frame}{region}.ll(1,1);
        region_trajectories_purged.label{count}(kcount)=allregionsframes{frame}{region}.ll(1,2);
    end
end
save(filenames.filename_vijay_regiontrajectoriespurged, 'region_trajectories_purged');

