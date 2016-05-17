function Seelengthofregionpaths(ucm2,frame,level,correspondentPath)
%In the 3D part, x is towards right, y is towards bottom, as for u and v
%Here ipos is towards bottom and jpos is towards right, as i and j

labels2 = bwlabel(ucm2{frame} < level);
labels = labels2(2:2:end, 2:2:end);
        
newimage=zeros(size(labels,1),size(labels,2));
newimage(:)=correspondentPath{frame}{level}(labels(:));

figure(8), title('Select a region');
[jpos,ipos]=ginput(1);
ipos=round(ipos);
jpos=round(jpos);

pathindex=newimage(ipos,jpos);
fprintf('Index at selected location = %d\n',pathindex);

count=0;
newimage=zeros(size(labels,1),size(labels,2));
for nl=1:numel(correspondentPath{frame}{level})
    if (correspondentPath{frame}{level}(nl)==pathindex)
        count=count+1;
        mask=Getthemask(ucm2{frame},level,nl)*count;
        newimage=newimage+mask;
    end
end
figure(20)
set(gcf, 'color', 'white');
imagesc(newimage);
title (['Mask of regions (frame=',int2str(frame),', level=',int2str(level),') with the same index']);
