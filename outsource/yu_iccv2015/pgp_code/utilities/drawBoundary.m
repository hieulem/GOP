function output = drawBoundary(newLBimg, I)
%tic
if size(I,3) == 1
    I(:,:,2) = I(:,:,1);
    I(:,:,3) = I(:,:,1);
    I = uint8(I);
end


%draw the boundaries
imgTotal = size(I,1)*size(I,2);
uniqueLB = unique(newLBimg);
newImg = zeros(size(newLBimg));

for i = 1:length(uniqueLB)
    
    blankImg = newLBimg == uniqueLB(i);
    blankImg = bwmorph(blankImg, 'remove');
    %blankImg = bwmorph(blankImg, 'thin');
    %blankImg = bwperim(blankImg);
    newImg = newImg|blankImg;
    
end

%newImg = bwmorph(newImg, 'majority');

%draw it back to the original image
bdInd = find(newImg == 1);

newImgC = I;
newImgC(bdInd) = 255;
newImgC(bdInd+imgTotal) = 0;
newImgC(bdInd+imgTotal*2) = 0;

output = newImgC;
%toc