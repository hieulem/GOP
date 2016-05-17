function group=Selectgroupsfast(image,track,dist_track_mask,group)


%initialisation of necessary parts (strel and frameEdge)
SE=Getstrel();
dimIi=size(image,1);
dimIj=size(image,2);
frameEdge=Getframeedge(dimIi,dimIj);

blank_mask=false(dimIi,dimIj);

imageorig=image;
%image=cim{frame};

nofigure=13;

%track = [ which frame , x or y , which trajectory ]
% dist_track_mask{which frame,which trajectory}=mask
%group{which group}=[tracks/dist_track_mask belonging to it]

noTracks=size(track,3);

figure(nofigure), imshow(image)
set(gcf, 'color', 'white');
hold on
for k=1:noTracks
    line(track(:,1,k),track(:,2,k),'Color','y'); 
    plot(track(:,1,k),track(:,2,k),'+g');
    plot(track(1,1,k),track(1,2,k),'ow');
end
hold off

all_selected_tracks=false(1,noTracks);
noGroups=0;

if ( (exist('group','var')) && (~isempty(group)) )
    noGroups=numel(group);
    for jj=1:noGroups
        for m=1:numel(group{jj})
            all_selected_tracks(group{jj}(m))=true;
        end
    end
else
    group={};
end

entered_empty_already=1;
while (1)
    
    figure(nofigure), imshow(imageorig);
    hold on
    for k=1:noTracks
        line(track(:,1,k),track(:,2,k),'Color','y'); 
        plot(track(:,1,k),track(:,2,k),'+g');
    end
    for jj=1:noGroups
        col=GiveDifferentColours(jj);
        for m=1:numel(group{jj})
            k=group{jj}(m);
            plot(track(1,1,k),track(1,2,k),'o','Color',col,'LineWidth',3);
        end
        plot(dimIj-2,jj*10,'o','Color',col,'LineWidth',3);
    end
    for k=find(~all_selected_tracks)
        plot(track(1,1,k),track(1,2,k),'ow');
    end
    hold off

    if (entered_empty_already)
        noGroups=noGroups+1;
        group{noGroups}=[];

        figure(nofigure);
        fprintf('Please adjust the zoom and press return\n');
        pause;
    end
    
    fprintf('Please select features for group %d (empty for newgroup, empty again for return)\n',noGroups)
    
    figure(nofigure);
    p = ginput(1);
    if (isempty(p))
        if (entered_empty_already)
            
            group(noGroups)=[];
            break;
        else
            if (isempty(group{noGroups}))
                noGroups=noGroups-1;
            end
            entered_empty_already=1;
            continue;
        end
    else
        entered_empty_already=0;
    end
    
    ipos=p(2);
    jpos=p(1);

    dist=sqrt( (track(1,1,:)-jpos).^2+(track(1,2,:)-ipos).^2 );
    [c,r]=min(dist);
    closest=r;

    image=imageorig;
    edge=xor( dist_track_mask{1,closest} , (imerode(dist_track_mask{1,closest}, SE) & frameEdge) );
    %this makes the contours of regions red
    red_part_edge=cat(3,edge,blank_mask,blank_mask);
    green_part_edge=cat(3,blank_mask,edge,blank_mask);
    blue_part_edge=cat(3,blank_mask,blank_mask,edge);
    image(red_part_edge)=255;
    image(green_part_edge)=0;
    image(blue_part_edge)=0;

    figure(nofigure), imshow(image)
    drawnow;
        
    if (~all_selected_tracks(closest))
        group{noGroups}=[group{noGroups},closest];
        fprintf('Feature %d added to group %d\n',closest,noGroups);
    else
        found=false(1);
        for jj=1:noGroups
            for m=1:numel(group{jj})
                if (group{jj}(m)==closest)
                    group{jj}(m)=[];
                    fprintf('Deleted feature %d from group %d\n',closest,jj);
                    found=1;
                    break;
                end
            end
            if ( found )
                if ( (isempty(group{jj})) && (jj~=noGroups) )
                    group(jj)=[];
                    noGroups=noGroups-1;
                    fprintf('Deleted group %d, containing only feature %d\n',jj,closest);
                end
                break;
            end
        end
    end
    all_selected_tracks(closest)=(~all_selected_tracks(closest));
    
        
end
fprintf('\n');



% trajectory=mapTracToTrajectories(closest);
% 
% nopath=trajectories{trajectory}.nopath;
% 
% region=Lookupregioninallregionpaths(allregionpaths,frame,nopath);
% 
% level=allregionsframes{frame}{region}.ll(1,1);
% label=allregionsframes{frame}{region}.ll(1,2);
% 
% mappednopath=correspondentPath{frame}{level}(label);
% 
% if (exist('cim','var')&&exist('mapPathToTrajectory','var')) %shows region on the image
%     Graphicregionpathsandtrajectories(mappednopath,ucm2,correspondentPath,allregionsframes,allregionpaths,trajectories,mapPathToTrajectory,cim);
% elseif (exist('cim','var'))
%     Graphicalcorrespondentpath(mappednopath,ucm2,correspondentPath,cim);
% else %shows region mask
%     Graphicalcorrespondentpath(mappednopath,ucm2,correspondentPath);
% end

