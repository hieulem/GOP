function [trackal,mapTracToTrajectoriesal,all_the_lengths]=Prepare_tracks_alllengths(image,trajectories,frame,trackLength,noFrames,filenames,firstTrajectory,printonscreen,cim)
%cim is only added to not generate the warning

if (  (~exist('printonscreen','var'))  ||  (isempty(printonscreen))  )
    printonscreen=false;
end

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

track_filenameal=[filenames.filename_trackregiontrackbase,'f',num2str(frame,'%03d'),'tl',num2str(trackLength,'%03d'),'trackal.mat'];

%%%extraction of tracks of innest points and regions

if (exist(track_filenameal,'file'))
    load(track_filenameal);
    fprintf('Loaded trackal\n');
else
    %extraction of relevant trajectories of the innest points (at least trackLength long in common)
    [trackal,mapTracToTrajectoriesal,all_the_lengths]=Get_tracks_innest_points_all_lengths(image,trajectories,frame,trackLength,noFrames,firstTrajectory,printonscreen);
    %trackal = [ which frame , x or y , which trajectory ]
    % all_the_lengths.start= first frame of dist_track_maskal
    % all_the_lengths.end= last frame of dist_track_maskal
    % noTracks=size(trackal,3);

    save(track_filenameal, 'trackal', 'mapTracToTrajectoriesal','all_the_lengths','-v7.3');
    fprintf('Trackal computed and saved\n');
end



%%%Computation of common length
% commonlengths=Get_common_lengths(all_the_lengths);
% commonlengths=[first_traj, second_traj, 1_start/2_end/3_commonlength]


