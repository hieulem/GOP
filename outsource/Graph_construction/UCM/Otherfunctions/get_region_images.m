function get_region_images(ucm2,filenames,region_trajectories_purged)


if (~exist('region_trajectories_purged','var'))
    load(filenames.filename_vijay_regiontrajectoriespurged);
end

%determine the size of the mask
frame=region_trajectories_purged.startFrame(1); %frame in the sequence to which the which_frame correspond to
mask=Getthemask(ucm2{frame},region_trajectories_purged.level{1}(1),region_trajectories_purged.label{1}(1));
dimI=size(mask,1);
dimJ=size(mask,2);

[XX,YY]=meshgrid(1:dimJ,1:dimI);

IND=zeros(dimI,dimJ);
IND(:)=sub2ind([dimI,dimJ],YY(:),XX(:));

noTrajectories=numel(region_trajectories_purged.totalLength);
region_pixel_locations=cell(1,noTrajectories);
fprintf('Trajectory (out of %05d) %05d',noTrajectories,0);
for selected_trajectory=1:noTrajectories %1,13
    fprintf('\b\b\b\b\b%05d',selected_trajectory);
    for i=1:region_trajectories_purged.totalLength(selected_trajectory)

        frame=region_trajectories_purged.startFrame(selected_trajectory)+i-1; %frame in the sequence to which the which_frame correspond to
        %Getthemask with corrensponding ucm2, level and label
%         figure(5), imshow(mask); set(gcf, 'color', 'white'); set(gca,'xtick',[],'ytick',[]);
        mask=Getthemask(ucm2{frame},region_trajectories_purged.level{selected_trajectory}(i),region_trajectories_purged.label{selected_trajectory}(i));
%         figure(6), imshow(mask); set(gcf, 'color', 'white'); set(gca,'xtick',[],'ytick',[]);
%         pause(0.5)
        
%         imwrite(mask,['D:\Regionwarping\images\region_',num2str(selected_trajectory,'%05d'),'_seq_',num2str(i,'%03d'),'.pgm'],'pgm');
        imwrite(mask,['D:\Regionwarping\images\region_n_seq_',num2str(i,'%03d'),'.pgm'],'pgm');
    end
    
    %run the correspondence executable
    commandExt=['D:\Regionwarping\region_mapping.exe D:\Regionwarping\images\region_n_seq_',num2str(1,'%03d'),'.pgm'];
    [stat,data]=dos(commandExt);

    
    for i=1:region_trajectories_purged.totalLength(selected_trajectory)

        if (i==1)
%             region_pixel_locations{selected_trajectory}{i}.X=zeros(size(mask));
%             region_pixel_locations{selected_trajectory}{i}.Y=zeros(size(mask));
            region_pixel_locations{selected_trajectory}{i}=[];
            continue;
        end
        
        M = textread(['D:\Regionwarping\images\region_n_seq_',num2str(i,'%03d'),'_output.txt'],'','commentstyle','shell');
        M(:,end)=[];
        X=M(1:fix(size(M,1)/2),:)';
        Y=M(fix(size(M,1)/2)+1:end,:)';
        nonEmpty= ( (X>=0) & (Y>=0) );
        X(nonEmpty)=X(nonEmpty)+1;
        Y(nonEmpty)=Y(nonEmpty)+1;
        
%         figure(1), set(gcf, 'color', 'white'); imshow(X);
%         figure(2), set(gcf, 'color', 'white'); imshow(Y);
%         pause(2.5);

%         region_pixel_locations{selected_trajectory}{i}.X=X;
%         region_pixel_locations{selected_trajectory}{i}.Y=Y;
        
        region_pixel_locations{selected_trajectory}{i}=[XX(nonEmpty),YY(nonEmpty),X(nonEmpty),Y(nonEmpty)];

%         region_pixel_locations{selected_trajectory}{i}=[IND(nonEmpty),X(nonEmpty),Y(nonEmpty)];
    end
    
    %clean the images directory
    commandExt='del /q D:\Regionwarping\images\*.*';
    [stat,data]=dos(commandExt);
    
end
fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');

save(filenames.filename_vijay_regionpixellocations, 'region_pixel_locations','-v7.3');






function [xp,yp]=correspondence_if_any_unique_index(x,y,dimI,dimJ,region_pixel_locations,selected_trajectory,frame_in_traj)
%to look for a correspondence, if any
index=sub2ind([dimI,dimJ],y,x);
%[yp,xp] = ind2sub([dimI,dimJ],index);
r=find(region_pixel_locations{selected_trajectory}{frame_in_traj}(:,1)==index);
if (isempty(r))
    xp=-1;
    yp=-1;
else
    xp=region_pixel_locations{selected_trajectory}{frame_in_traj}(r(1),2);
    yp=region_pixel_locations{selected_trajectory}{frame_in_traj}(r(1),3);
end


