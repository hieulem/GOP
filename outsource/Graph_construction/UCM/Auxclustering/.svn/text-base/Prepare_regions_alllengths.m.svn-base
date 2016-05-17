function [dist_track_maskal,mapTracToTrajectoriesal,all_the_lengths]=...
    Prepare_regions_alllengths(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,filenames,firstTrajectory,printonscreen,cim)
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

disttrackmask_filenameal=[filenames.filename_trackregiontrackbase,'f',num2str(frame,'%03d'),'tl',num2str(trackLength,'%03d'),'disttrackmaskal.mat'];

%%%extraction of tracks of innest points and regions

if (exist(disttrackmask_filenameal,'file'))
    load(disttrackmask_filenameal);
    fprintf('Loaded dist_track_maskal\n');
else
    %extraction of masks corresponding to the trajectories (at least trackLength long in common)
    [dist_track_maskal,mapTracToTrajectoriesal,all_the_lengths]=Get_track_masks_all_lengths(firstTrajectory,image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,printonscreen);
    % dist_track_maskal{which frame,which trajectory}=mask
    % all_the_lengths.start= first frame of dist_track_maskal
    % all_the_lengths.end= last frame of dist_track_maskal
    % noTracks=size(dist_track_maskal,2);

    save(disttrackmask_filenameal, 'dist_track_maskal', 'mapTracToTrajectoriesal','all_the_lengths','-v7.3');
    fprintf('Dist_track_maskal computed and saved\n');
end


%%%Computation of common length
% commonlengths=Get_common_lengths(all_the_lengths);
% commonlengths=[first_traj, second_traj, 1_start/2_end/3_commonlength]


