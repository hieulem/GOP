function export_shake_trajectories(trackLength,trajectories)

filename='D:\Shake\mine_auto_';

no_track_id=0;
for k=1:size(trajectories,2)
    if (isempty(trajectories{k}))
        continue;
    end
    if (trajectories{k}.totalLength<trackLength)
        continue;
    end
    no_track_id=no_track_id+1;
end

tot_of_tracks=no_track_id;

no_track_id=0;
for k=1:size(trajectories,2)
    if (isempty(trajectories{k}))
        continue;
    end
    if (trajectories{k}.totalLength<trackLength)
        continue;
    end
    no_track_id=no_track_id+1;

    fn_to_write=[filename,int2str(tot_of_tracks+no_track_id-1),'.txt'];
    fid=fopen(fn_to_write,'wt');

    fprintf(fid,'TrackName auto_%s\n',int2str(tot_of_tracks+no_track_id-1));
    fprintf(fid,'Frame        X        Y   Correlation\n');

    for kk=1:trajectories{k}.totalLength
        frame=kk+trajectories{k}.startFrame-1;
        fprintf(fid,'%d  %f  %f  %.1f\n',frame-1,trajectories{k}.Xs(kk),480-trajectories{k}.Ys(kk),1.0);
        %frame-1 because Boujou starts from frame 0
    end
    
    fclose(fid);
end
