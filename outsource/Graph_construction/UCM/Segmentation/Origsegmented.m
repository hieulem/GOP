for f=1:numel(ucm2)
    
    f=24;
    
    theucm2=ucm2{f};

    % convert ucm to the size of the original image
    ucm = theucm2(3:2:end, 3:2:end);

    % get the boundaries of segmentation at scale k in range [1 255]
    k = 180;
    bdry = (ucm >= k);

    % get the partition at scale k without boundaries:
    labels2 = bwlabel(theucm2 <= k);
    labels = labels2(2:2:end, 2:2:end);

    figure(2);imshow(ucm);
    figure(3);imshow(bdry);
    figure(4);imshow(labels,[]);colormap(jet);

end



labelledvideo=zeros( size(labels,1),size(labels,2),100);

for f=1:50
    labelledvideo(:,:,f)=labels;
end

for f=51:100
    labelledvideo(:,:,f)=labels;
end

for f=51:100
    cim{f}=cim{24};
end
for f=1:50
    cim{f}=cim{24};
end


