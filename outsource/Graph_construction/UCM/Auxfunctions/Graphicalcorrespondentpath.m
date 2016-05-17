function Graphicalcorrespondentpath(pathindex,ucm2,correspondentPath,cim)
%if cim is passed, the function shows the region on the image, otherwise
%the mask of the region is shown

if (exist('cim','var') && (~isempty(cim)) )
    SE = strel('square',3);
end

count=0;
for f=1:size(correspondentPath,2)
    found=0;
    for l=1:size(correspondentPath{f},2)
        for nl=1:numel(correspondentPath{f}{l})
            if (correspondentPath{f}{l}(nl)==pathindex)
                mask=Getthemask(ucm2{f},l,nl);
                count=count+1;
%                 figure(20+count)
                figure(20)
                set(gcf, 'color', 'white');
                
                if ( (~exist('cim','var')) || (isempty(cim)) )
                    %imagesc(mask);
                    imshow(mask,[]);colormap(jet);
                    title (['Mask of region (frame=',int2str(f),', level=',int2str(l),')']);
                else
                    edge = uint8(imdilate(mask, SE)-mask);
                    noEdge=(1-edge);

                    img=cim{f};
                    img(:,:,1)=img(:,:,1).*noEdge+img(:,:,1).*edge*255;
                    img(:,:,2)=img(:,:,2).*noEdge;
                    img(:,:,3)=img(:,:,3).*noEdge;

                    imshow(img)
                    title (['Highlighted region (frame=',int2str(f),', level=',int2str(l),')']);
                end
                
                found=1;
            end
            if (found)
                break;
            end
        end
        if (found)
            break;
        end
    end
%     if (found)
%         framesegment(count) = getframe(gca);
%         imgfilename='C:\Users\fg257\Desktop\path_images\frame';
%         title('');
%         print('-depsc',[imgfilename,num2str(count,'%03d'),'.eps']) %'-r200'
%     end
    pause(0.05)
end
fprintf('Index at selected location (mapped) = %d, the index occurred through %d frames\n',pathindex,count);
% aviName='C:\Users\fg257\Desktop\region_video';
% movie2avi(framesegment,aviName,'fps',10, 'compression', 'none');


