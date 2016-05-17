function Graphicregionpaths(nopath,ucm2,allregionsframes,allregionpaths,cim)
%if cim is passed, the function shows the region on the image, otherwise
%the mask of the region is shown


%Initialisation of necessary part
if (exist('cim','var') && (~isempty(cim)) )
    thicker=false;
    SE=Getstrel(thicker);
end

rangetodisplay=allregionpaths.startPath(nopath):allregionpaths.endPath(nopath);
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

        %for writing the image
        % imwrite(img,['C:\Epsimages\regionatframe',num2str(f),'.png'],'png'); %or ppm
    end
    
    %for writing the image
%     if any(f==[16,31,46,60])
%         print('-depsc',['C:\Epsimages\regionatframe',num2str(f),'.eps']);
%     end


    pause(0.05)
end
fprintf('The regionpath has occurred through %d frames\n',allregionpaths.totalLength(nopath));

%for acquiring the video of the region trajectory
% movie2avi(regiontrajectory,'D:\Regionpathexample.avi','compression','None','fps',7);




% region=Lookupregioninallregionpaths(allregionpaths,frame,nopath);
% level=allregionsframes{frame}{region}.ll(1,1);
% label=allregionsframes{frame}{region}.ll(1,2);
% mappednopath=correspondentPath{frame}{level}(label);
% 
% region=lookUpRegioninAllregionsframes(allregionsframes,f,l,nl);
% nopath=allregionpaths.nopath{f}(region);
% notrajectory=mapPathToTrajectory(nopath);


