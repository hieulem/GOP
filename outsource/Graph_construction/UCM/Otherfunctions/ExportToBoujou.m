function noTracks=ExportToBoujou(min_track_length,frames_to_print,trajectories,startframe,filenames,firstTrajectory,justcount)

if ( (~exist('firstTrajectory','var')) || (isempty(firstTrajectory)) )
    firstTrajectory=1;
end
if ( (~exist('justcount','var')) || (isempty(justcount)) )
    justcount=0;
end
if ( (~exist('filenames','var')) || (isempty(filenames)) )
    to_boujou_filename='D:\trajectories.txt';
    fprintf('Saving to %s\n',to_boujou_filename);
else
    if (numel(startframe)>1)
        to_boujou_filename=[filenames.toboujou_filename_base,'_mtl',num2str(min_track_length,'%03d'),'_ftp',num2str(frames_to_print,'%03d'),'_sf',num2str(startframe(1),'%03d'),'to',num2str(startframe(end),'%03d'),'.txt'];
    else
        to_boujou_filename=[filenames.toboujou_filename_base,'_mtl',num2str(min_track_length,'%03d'),'_ftp',num2str(frames_to_print,'%03d'),'_sf',num2str(startframe,'%03d'),'.txt'];
    end
end

%This part counts the trajectories, for initialising the memory
noTracks=0;
for frames=startframe
    for k=firstTrajectory:size(trajectories,2)
        if ( isempty(trajectories{k}) || (trajectories{k}.totalLength<min_track_length) )
            continue;
        end
        if ( (trajectories{k}.startFrame>frames)||(trajectories{k}.endFrame<(frames+frames_to_print-1)) )
            continue;
        end
        noTracks=noTracks+1;
    end
end

if (justcount)
    return
end


%compose the text for Boujou
fid=fopen(to_boujou_filename,'wt');


% fprintf(fid,'# boujou 2d tracks export: text\n');
% fprintf(fid,'# boujou version: 4.0.1 13/10/06:14 14267\n');
% fprintf(fid,'# Creation date : Thu Feb 04 16:40:56 2010\n');
% fprintf(fid,'#\n');
% fprintf(fid,'# track_id    view      x    y\n');

text_id_base='mine_';



for frames=startframe
    for k=1:size(trajectories,2)
        if ( isempty(trajectories{k}) || (trajectories{k}.totalLength<min_track_length) )
            continue;
        end
        if ( (trajectories{k}.startFrame>frames)||(trajectories{k}.endFrame<(frames+frames_to_print-1)) )
            continue;
        end
        no_track_id=k;
        for frame=frames:(frames+frames_to_print-1)
            kk=frame-trajectories{k}.startFrame+1;
            text_id=[text_id_base,num2str(frames,'%03d'),'_',num2str(no_track_id,'%05d')];
    %         text_id=[text_id_base,num2str(no_track_id)];
    %         text_id=[text_id_base,num2str(frames,'%d'),'_',num2str(no_track_id,'%d')];
            fprintf(fid,'%s  %d  %.3f  %.3f\n',text_id,(frame-1),trajectories{k}.Xs(kk),trajectories{k}.Ys(kk));
    %         fprintf(fid,'%s\t%d\t%.3f\t%.3f\n',[track_id_text,int2str(no_track_id-1)],frame-1,trajectories{k}.Xs(kk),trajectories{k}.Ys(kk));
            %frame-1 because Boujou starts from frame 0
        end
    end
end
fprintf(fid,'\n');

fclose(fid);

% filenames.toboujou_filename_base=[filenames.filename_directory,'boujou\toboujou_'];
% filenames.fromboujou_filename_base=[filenames.filename_directory,'boujou\fromboujou_'];

