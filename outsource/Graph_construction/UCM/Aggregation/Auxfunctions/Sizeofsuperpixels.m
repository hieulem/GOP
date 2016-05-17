function [sizeofsprpix, fillspx] = Sizeofsuperpixels( labelledvideo,numberofsuperpixelsperframe, noallsuperpixels)

sizeofsprpix = zeros(noallsuperpixels,1);
fillspx = zeros(noallsuperpixels,1);
noFrames=size(labelledvideo,3);

indx=1;
for frame=1:noFrames   
    
    labels = labelledvideo(:,:,frame);
    
    for superpix = 1:numberofsuperpixelsperframe(frame)
%         [x,y] = find(labels==superpix);   
       sizeofsprpix(indx) = sum(sum(labels==superpix));
%        fillspx(indx) = (sum(sum(labels==superpix)))/((max(x)-min(x)+1)*(max(y)-min(y)+1));       
       indx = indx+1; 
    end
    
end
end

