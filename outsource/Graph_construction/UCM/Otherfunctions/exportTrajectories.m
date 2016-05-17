function exportTrajectories(trackLength,trajectories)

filename='D:\trajectories.txt';
fid=fopen(filename,'wt');

fprintf(fid,'# boujou 2d tracks export: text\n');
fprintf(fid,'# boujou version: 4.0.1 13/10/06:14 14267\n');
fprintf(fid,'# Creation date : Mon Oct 19 16:43:17 2009\n');
fprintf(fid,'#\n');
fprintf(fid,'# track_id    view      x    y\n');

track_id_text='auto_';

no_track_id=8000;
for k=1:size(trajectories,2)
    if (isempty(trajectories{k}))
        continue;
    end
    if (trajectories{k}.totalLength<trackLength)
        continue;
    end
    no_track_id=no_track_id+1;
    for kk=1:trajectories{k}.totalLength
        frame=kk+trajectories{k}.startFrame-1;
        fprintf(fid,'%s  %d  %.3f  %.3f\n',[track_id_text,int2str(no_track_id-1)],frame-1,trajectories{k}.Xs(kk),trajectories{k}.Ys(kk));
%         fprintf(fid,'%s\t%d\t%.3f\t%.3f\n',[track_id_text,int2str(no_track_id-1)],frame-1,trajectories{k}.Xs(kk),trajectories{k}.Ys(kk));
        %no_track_id-1 and frame-1 because Boujou starts from frame 0 and
        %track_id 0
    end
end

fclose(fid);
