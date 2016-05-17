function viewUCM()

load('C:\Users\fg257\Desktop\Code\UCM\cim.mat')

directory='D:\Data\CrowdVideo\Frames_Segments\ucm\';
directory2='D:\Data\CrowdVideo\Frames_Segments\ucm2\';

% for boundaries: ucm
% for regions: ucm2


for i=1:70
    name=[directory,'tmp',num2str(i,'%05d'),'_ucm.png'];
    name2=[directory2,'tmp',num2str(i,'%05d'),'_ucm2.png'];
    ucm{i}=imread(name);
    ucm2{i}=imread(name2);
end

k = 35;
for i=1:70
    % get the boundaries of segmentation at scale k in range [1 255]
    bdry = (ucm{i} >= k);
    figure(10)
    set(gcf, 'color', 'white');
    imshow(bdry)
    
    % convert ucm to the size of the original image
    ucmm = ucm2{i}(3:2:end, 3:2:end);
    bdry = (ucmm >= k); % get the boundaries of segmentation at scale k in range [1 255]
    figure(11)
    set(gcf, 'color', 'white');
    imshow(bdry)
    set(gca,'xtick',[],'ytick',[]); %title ('');
%     framecontour(i) = getframe(gca);
    
    % get the partition at scale k without boundaries:
    labels2 = bwlabel(ucm2{i} <= k);
    labels = labels2(2:2:end, 2:2:end);
    figure(12)
    set(gcf, 'color', 'white');
%     imagesc(labels)
    imshow(labels,[]);colormap(jet);
    set(gca,'xtick',[],'ytick',[]); %title ('');
%     framesegment(i) = getframe(gca);

    figure(13), imshow(cim{i})
    set(gcf, 'color', 'white');

    pause(0.01)
end

% aviName='contour';
% movie2avi(framecontour,aviName,'fps',10, 'compression', 'none');
% aviName='segment';
% movie2avi(framesegment,aviName,'fps',10, 'compression', 'none');


%%

%menu
k=35;
i=1;
noFrames=size(ucm2,2);
while 1
    % convert ucm to the size of the original image
    ucmm = ucm2{i}(3:2:end, 3:2:end);
    bdry = (ucmm >= k); % get the boundaries of segmentation at scale k in range [1 255]
    figure(11)
    set(gcf, 'color', 'white');
    imshow(bdry)
    set(gca,'xtick',[],'ytick',[]); %title ('');
%     framecontour(i) = getframe(gca);
    
%     % get the partition at scale k without boundaries:
%     labels2 = bwlabel(ucm2{i} <= k);
%     labels = labels2(2:2:end, 2:2:end);
%     figure(12)
%     set(gcf, 'color', 'white');
% %     imagesc(labels)
%     imshow(labels,[]);colormap(jet);
%     set(gca,'xtick',[],'ytick',[]); %title ('');
% %     framesegment(i) = getframe(gca);

    figure(13), imshow(cim{i})
    set(gcf, 'color', 'white');

    ch = menu(['Choose an action (f = ',num2str(i),', l = ',num2str(k),')'],...
        'Next frame','Previous frame','Level up','Level down','Quit','Next frame 10',...
        'Previous frame 10','Level up 10','Level down 10','Select region'); %displays
    switch ch
       case 1
          i=i+1;
          if (i>noFrames)
              i=noFrames;
          end
       case 2
          i=i-1;
          if (i<1)
              i=1;
          end
       case 3
          k=k+1;
          if (k>255)
              k=255;
          end
       case 4
          k=k-1;
           if (k<1)
              k=1;
          end
      case 5
          break;
       case 6
          i=i+10;
          if (i>noFrames)
              i=noFrames;
          end
       case 7
          i=i-10;
          if (i<1)
              i=1;
          end
       case 8
          k=k+10;
          if (k>255)
              k=255;
          end
       case 9
          k=k-10;
           if (k<1)
              k=1;
           end
        case 10
            
            figure(11), title('Select a point');
            [ypos,xpos]=ginput(1);
            ypos=round(ypos);
            xpos=round(xpos);
            labels2 = bwlabel(ucm2{i} <= k);
            labels = labels2(2:2:end, 2:2:end);
            pos=find(labels(xpos,ypos)==labels(:,:));
            mask=zeros(size(image,1),size(image,2));
            mask(pos)=1;
            count=0;
            for j=k+1:min(255,k+5)
                j
                labels2 = bwlabel(ucm2{i} <= j);
                labels = labels2(2:2:end, 2:2:end);
                pos=find(labels(xpos,ypos)==labels(:,:));
                mask2=zeros(size(image,1),size(image,2));
                mask2(pos)=1;
                if all(all(mask2==mask))
                    count=count+1
                else
                    break;
                end
            end
            for j=k-1:-1:max(1,k-5)
                j
                labels2 = bwlabel(ucm2{i} <= j);
                labels = labels2(2:2:end, 2:2:end);
                pos=find(labels(xpos,ypos)==labels(:,:));
                mask2=zeros(size(image,1),size(image,2));
                mask2(pos)=1;
                if all(all(mask2==mask))
                    count=count+1
                else
                    break;
                end
            end
            figure(10)
            set(gcf, 'color', 'white');
            imagesc(mask);
            set(gca,'xtick',[],'ytick',[]); %title ('');
            
            fprintf('%d\n',count);
        otherwise
          disp('Unknown action')
    end
end

%%