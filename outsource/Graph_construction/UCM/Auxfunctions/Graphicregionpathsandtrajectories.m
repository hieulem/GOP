function Graphicregionpathsandtrajectories(notrajectory,ucm2,allregionsframes,allregionpaths,trajectories,cim,showregionpaths)
%if cim is passed, the function shows the region on the image, otherwise
%the mask of the region is shown
%This function has been extracted from Seeregionpath

if ( (~exist('showregionpaths','var')) || (isempty(showregionpaths)) )
    showregionpaths=false;
end


%Initialisation of necessary part
if (exist('cim','var') && (~isempty(cim)) )
    thicker=false;
    SE=Getstrel(thicker);
end

nopath=trajectories{notrajectory}.nopath;
if (showregionpaths)
    rangetodisplay=allregionpaths.startPath(nopath):allregionpaths.endPath(nopath);
else
    rangetodisplay=trajectories{notrajectory}.startFrame:trajectories{notrajectory}.endFrame;
end
for f=rangetodisplay
    
    fregion=Lookupregioninallregionpaths(allregionpaths,f,nopath);
    level=allregionsframes{f}{fregion}.ll(1,1);
    label=allregionsframes{f}{fregion}.ll(1,2);
    mask=Getthemask(ucm2{f},level,label);
                
    figure(20)
    set(gcf, 'color', 'white');
    if ( (~exist('cim','var')) || (isempty(cim)) )
        %imagesc(mask);
        imshow(mask,[]);colormap(jet);
        title (['Mask of region (frame=',int2str(f),', level=',int2str(level),')']);
    else
        edge = uint8(imdilate(mask, SE)-mask);
        noEdge=(1-edge);

        img=cim{f};
        img(:,:,1)=img(:,:,1).*noEdge+img(:,:,1).*edge*255;
        img(:,:,2)=img(:,:,2).*noEdge;
        img(:,:,3)=img(:,:,3).*noEdge;

        imshow(img)
        title (['Highlighted region (frame=',int2str(f),', level=',int2str(level),')']);

        %for writing the image (no centroids)
        % imwrite(img,['C:\Epsimages\regionatframe',num2str(f),'.png'],'png'); %or ppm
    end
    
    if ( (trajectories{notrajectory}.startFrame<=f) && (trajectories{notrajectory}.endFrame>=f) )
        posInarray=f-trajectories{notrajectory}.startFrame+1;
        hold on;
        plot(trajectories{notrajectory}.Xs(posInarray),trajectories{notrajectory}.Ys(posInarray),'+r','MarkerSize',13,'LineWidth',1);
        hold off;
        
        %for writing the image with the centroid
%         if any(f==[16,31,46,60])
%             print('-depsc',['C:\Epsimages\regionwithcentroidatframe',num2str(f),'.eps']);
%         end

        %for acquiring the video of the region trajectory
%         regiontrajectory(count)=getframe;
    end


    pause(0.05)
end
fprintf('The trajectory has occurred through %d frames, the regionpath through %d frames\n',...
    trajectories{notrajectory}.totalLength,allregionpaths.totalLength(nopath));

%for acquiring the video of the region trajectory
% movie2avi(regiontrajectory,'D:\Regiontrajectoryexample.avi','compression','None','fps',7);




% region=Lookupregioninallregionpaths(allregionpaths,frame,nopath);
% level=allregionsframes{frame}{region}.ll(1,1);
% label=allregionsframes{frame}{region}.ll(1,2);
% mappednopath=correspondentPath{frame}{level}(label);
% 
% region=lookUpRegioninAllregionsframes(allregionsframes,f,l,nl);
% nopath=allregionpaths.nopath{f}(region);
% notrajectory=mapPathToTrajectory(nopath);


