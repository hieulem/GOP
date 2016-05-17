function [trackal,mapTracToTrajectoriesal,dist_track_maskal,allDsal]=...
    Prepare_region_tracks_and_allds_alllengths(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,flows,filenames,firstTrajectory,cim)
%cim is only added to not generate the warning

%to see the part worth having a look
%to clean the directory


if ( (~exist('frame','var')) || (isempty(frame)) )
    frame=1;
end
if ( (~exist('image','var')) || (isempty(image)) )
    image=cim{frame};
end
if ( (~exist('trackLength','var')) || (isempty(trackLength)) )
    %trackLength is here considered a starting length
    %selected tracks must exist between the current frame and the next
    %trackLength-1 frames
    trackLength=3;
%     trackLength=10;
end


%%%to set up according to which one is the first trajectory to use, so as
%%%to exclude the full frame
if ( (~exist('firstTrajectory','var')) || (isempty(firstTrajectory)) )
    firstTrajectory=1;
end
%%%

noFrames=numel(allregionsframes);

printonscreen=true;
%temp: printonscreen should be zero


%%%extraction of tracks of innest points and regions

[trackal,mapTracToTrajectoriesal,all_the_lengths]=Prepare_tracks_alllengths(image,trajectories,frame,trackLength,noFrames,filenames,firstTrajectory,printonscreen,cim);
    %trackal = [ which frame , x or y , which trajectory ]
    % all_the_lengths.start= first frame of dist_track_maskal
    % all_the_lengths.end= last frame of dist_track_maskal
    % noTracks=size(trackal,3);

[dist_track_maskal,mapTracToTrajectoriesal,all_the_lengths]=...
    Prepare_regions_alllengths(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,filenames,firstTrajectory,printonscreen,cim);
    % dist_track_maskal{which frame,which trajectory}=mask
    % all_the_lengths.start= first frame of dist_track_maskal
    % all_the_lengths.end= last frame of dist_track_maskal
    % noTracks=size(dist_track_maskal,2);



%%%Computation of distance matrix

if (exist(distance_matrices_filenameal,'file'))
    load(distance_matrices_filenameal);
    fprintf('Loaded D matrices\n');
else
    
    commonlengths=Get_common_lengths(all_the_lengths);
    % commonlengths=[first_traj, second_traj, 1_start/2_end/3_commonlength]

    allDsal=Initallds();
    
    someDs=Getdistance_position_tracksal(trackal,commonlengths);
    allDsal=AddSomeAll(allDsal,someDs);

    clear someDs;
    someDs=Getdistance_position_regionsal(dist_track_maskal,commonlengths,frame,noFrames,flows,trackal);
    allDsal=AddSomeAll(allDsal,someDs);
    
    
    save(distance_matrices_filenameal, 'allDsal','-v7.3');
    fprintf('All D matrices computed and saved\n');
end

