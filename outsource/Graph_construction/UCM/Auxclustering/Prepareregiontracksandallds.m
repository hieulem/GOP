function [track,mapTracToTrajectories,dist_track_mask,allDs]=...
    Prepareregiontracksandallds(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,flows,filenames,firstTrajectory,cim,printonscreen)
%cim is only added to not generate the warning

%to see the part worth having a look
%to clean the directory


if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=true;
end
if ( (~exist('frame','var')) || (isempty(frame)) )
    frame=1;
end
if ( (~exist('image','var')) || (isempty(image)) )
    image=cim{frame};
end
if ( (~exist('trackLength','var')) || (isempty(trackLength)) )
    %trackLength means here an exact length
    trackLength=10;
%     trackLength=3;
end


%%%to set up according to which one is the first trajectory to use, so as
%%%to exclude the full frame
if ( (~exist('firstTrajectory','var')) || (isempty(firstTrajectory)) )
    firstTrajectory=1;
end
%%%

track_region_filename=[filenames.filename_trackregiontrackbase,'f',num2str(frame,'%03d'),'tl',num2str(trackLength,'%03d'),'.mat'];
distance_matrices_filename=[filenames.filename_distancematricesbase,'f',num2str(frame,'%03d'),'tl',num2str(trackLength,'%03d'),'.mat'];


%%%extraction of tracks of innest points and regions

if (exist(track_region_filename,'file'))
    load(track_region_filename);
    fprintf('Loaded tracks and region tracks\n');
else
    printin=0; %because a print will be done for both computed and loaded
    
    %extraction of relevant trajectories of the innest points (exactly trackLength long)
    [track,mapTracToTrajectories]=get_tracks_at_frame_innest_points(image,trajectories,frame,trackLength,firstTrajectory,printin);
    %track = [ which frame , x or y , which trajectory ]
    noTracks=size(track,3);

    %extraction of masks corresponding to the trajectories (exactly trackLength long)
    [dist_track_mask,mapTracToTrajectories]=get_track_masks(firstTrajectory,image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,printin);
    % dist_track_mask{which frame,which trajectory}=mask

    if (size(dist_track_mask,2)~=noTracks)
        fprintf('Please check the length of the point and region tracks generated\n');
        return;
    end
    save(track_region_filename, 'track', 'mapTracToTrajectories', 'dist_track_mask','-v7.3');
    fprintf('Tracks and region tracks computed and saved\n');
end
if (printonscreen)
    Printtracks(track,image);
    Printtrackmasks(dist_track_mask,image);
end



%%%Computation of distance matrix

if (exist(distance_matrices_filename,'file'))
    load(distance_matrices_filename);
    fprintf('Loaded D matrices\n');
else
    
    allDs=Initallds();
    
    %1 to 60
    someDs=Getdistance_position_tracks(track);
    allDs=AddSomeAll(allDs,someDs);
    
    clear someDs;
    someDs=Getdistance_position_regions(dist_track_mask,frame,flows,track);
    allDs=AddSomeAll(allDs,someDs);
    
    
    save(distance_matrices_filename, 'allDs','-v7.3');
    fprintf('All D matrices computed and saved\n');
end













%%% The following part provides scripts to pre-compute the tracks, %%%
%%% mapTracToTrajectories, dist_track_mask and allDs %%%

function Runfourprocesses()

%this one runs through all frames - 1+4k
noFrames=numel(allregionsframes);
firstTrajectory=1;
maxtrackLength=17;
mintrackLength=5;
startf=1;
endf=(noFrames-maxtrackLength+1);
for firstframemaxlength=startf:4:endf
    frame=firstframemaxlength-1;
    for trackLength=maxtrackLength:-2:mintrackLength
        frame=frame+1;
        image=cim{frame};
        [track,mapTracToTrajectories,dist_track_mask,allDs]=...
        Prepareregiontracksandallds(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,flows,filenames,firstTrajectory,[],0);
        fprintf('Frame %d and trackLength %d done\n',frame,trackLength);
    end
end

%this one runs through all frames - 2+4k
noFrames=numel(allregionsframes);
firstTrajectory=1;
maxtrackLength=17;
mintrackLength=5;
startf=2;
endf=(noFrames-maxtrackLength+1);
for firstframemaxlength=startf:4:endf
    frame=firstframemaxlength-1;
    for trackLength=maxtrackLength:-2:mintrackLength
        frame=frame+1;
        image=cim{frame};
        [track,mapTracToTrajectories,dist_track_mask,allDs]=...
        Prepareregiontracksandallds(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,flows,filenames,firstTrajectory,[],0);
        fprintf('Frame %d and trackLength %d done\n',frame,trackLength);
    end
end

%this one runs through all frames - 3+4k
noFrames=numel(allregionsframes);
firstTrajectory=1;
maxtrackLength=17;
mintrackLength=5;
startf=3;
endf=(noFrames-maxtrackLength+1);
for firstframemaxlength=startf:4:endf
    frame=firstframemaxlength-1;
    for trackLength=maxtrackLength:-2:mintrackLength
        frame=frame+1;
        image=cim{frame};
        [track,mapTracToTrajectories,dist_track_mask,allDs]=...
        Prepareregiontracksandallds(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,flows,filenames,firstTrajectory,[],0);
        fprintf('Frame %d and trackLength %d done\n',frame,trackLength);
    end
end

%this one runs through all frames - 4+4k
noFrames=numel(allregionsframes);
firstTrajectory=1;
maxtrackLength=17;
mintrackLength=5;
startf=4;
endf=(noFrames-maxtrackLength+1);
for firstframemaxlength=startf:4:endf
    frame=firstframemaxlength-1;
    for trackLength=maxtrackLength:-2:mintrackLength
        frame=frame+1;
        image=cim{frame};
        [track,mapTracToTrajectories,dist_track_mask,allDs]=...
        Prepareregiontracksandallds(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,flows,filenames,firstTrajectory,[],0);
        fprintf('Frame %d and trackLength %d done\n',frame,trackLength);
    end
end



function Runtwoprocesses()

%this one runs through all frames - odd frames
noFrames=numel(allregionsframes);
firstTrajectory=1;
maxtrackLength=17;
mintrackLength=5;
startf=1;
endf=(noFrames-maxtrackLength+1);
for firstframemaxlength=startf:2:endf
    frame=firstframemaxlength-1;
    for trackLength=maxtrackLength:-2:mintrackLength
        frame=frame+1;
        image=cim{frame};
        [track,mapTracToTrajectories,dist_track_mask,allDs]=...
        Prepareregiontracksandallds(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,flows,filenames,firstTrajectory,[],0);
        fprintf('Frame %d and trackLength %d done\n',frame,trackLength);
    end
end

%this one runs through all frames - even frames
noFrames=numel(allregionsframes);
firstTrajectory=1;
maxtrackLength=17;
mintrackLength=5;
startf=2;
endf=(noFrames-maxtrackLength+1);
for firstframemaxlength=startf:2:endf
    frame=firstframemaxlength-1;
    for trackLength=maxtrackLength:-2:mintrackLength
        frame=frame+1;
        image=cim{frame};
        [track,mapTracToTrajectories,dist_track_mask,allDs]=...
        Prepareregiontracksandallds(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,flows,filenames,firstTrajectory,[],0);
        fprintf('Frame %d and trackLength %d done\n',frame,trackLength);
    end
end



function Runonelonger51singleprocess()

%this one runs through all frames
noFrames=numel(allregionsframes);
firstTrajectory=1;
maxtrackLength=51;
mintrackLength=5;
maxlengthdone=35;
startf=1;
endf=(noFrames-maxtrackLength+1);
for firstframemaxlength=startf:endf
    frame=firstframemaxlength-1;
    for trackLength=maxtrackLength:-2:(maxlengthdone+2)
        frame=frame+1;
        image=cim{frame};
        [track,mapTracToTrajectories,dist_track_mask,allDs]=...
        Prepareregiontracksandallds(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,flows,filenames,firstTrajectory,[],0);
        fprintf('Frame %d and trackLength %d done\n',frame,trackLength);
    end
end



function Runonelonger35singleprocess()

%this one runs through all frames
noFrames=numel(allregionsframes);
firstTrajectory=1;
maxtrackLength=35;
mintrackLength=5;
maxlengthdone=17;
startf=1;
endf=(noFrames-maxtrackLength+1);
for firstframemaxlength=startf:endf
    frame=firstframemaxlength-1;
    for trackLength=maxtrackLength:-2:(maxlengthdone+2)
        frame=frame+1;
        image=cim{frame};
        [track,mapTracToTrajectories,dist_track_mask,allDs]=...
        Prepareregiontracksandallds(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,flows,filenames,firstTrajectory,[],0);
        fprintf('Frame %d and trackLength %d done\n',frame,trackLength);
    end
end



function Runoneprocesses()

%this one runs through all frames
noFrames=numel(allregionsframes);
firstTrajectory=1;
maxtrackLength=17;
mintrackLength=5;
startf=1;
endf=(noFrames-maxtrackLength+1);
for firstframemaxlength=startf:endf
    frame=firstframemaxlength-1;
    for trackLength=maxtrackLength:-2:mintrackLength
        frame=frame+1;
        image=cim{frame};
        [track,mapTracToTrajectories,dist_track_mask,allDs]=...
        Prepareregiontracksandallds(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,flows,filenames,firstTrajectory,[],0);
        fprintf('Frame %d and trackLength %d done\n',frame,trackLength);
    end
end



function Runoneprocessesonsomeframes()

noFrames=numel(allregionsframes);
firstTrajectory=1;
maxtrackLength=17;
mintrackLength=5;
framestoprocess=67:77;
for firstframemaxlength=framestoprocess
    frame=firstframemaxlength-1;
    for trackLength=maxtrackLength:-2:mintrackLength
        frame=frame+1;
        image=cim{frame};
        [track,mapTracToTrajectories,dist_track_mask,allDs]=...
        Prepareregiontracksandallds(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,flows,filenames,firstTrajectory,[],0);
        fprintf('Frame %d and trackLength %d done\n',frame,trackLength);
    end
end




function Runoneframeandonelength()

frame=1;
image=cim{frame};
trackLength=17;
firstTrajectory=1;
[track,mapTracToTrajectories,dist_track_mask,allDs]=...
Prepareregiontracksandallds(image,trajectories,frame,trackLength,allregionpaths,ucm2,allregionsframes,flows,filenames,firstTrajectory,[],0);



%check
% any(any(allDs.D_var_distvelmedianregions~=allDs_.D_var_distvelmedianregions))
% any(any(allDs.Dmeansubonstd_var_distvelmedianregions~=allDs_.Dmeansubonstd_var_distvelmedianregions))
% any(any(allDs.D_varweighted_distvelmedianregions~=allDs_.D_varweighted_distvelmedianregions))
% any(any(allDs.Dvxy_varvxy_distvelmedianregions~=allDs_.Dvxy_varvxy_distvelmedianregions))
% any(any(allDs.Dft_abstimesphase_velmedianregions~=allDs_.Dft_abstimesphase_velmedianregions))

