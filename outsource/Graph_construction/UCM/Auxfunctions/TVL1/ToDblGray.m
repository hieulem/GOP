function newImages=ToDblGray(outImages)
%converts colour and BW images and cell array of images into BW images and cell
%arrays of images

%requires: path(path,'TVL1');

if iscell(outImages)
    for i=1:size(outImages,2)
        if (size(outImages{i},3)~=1)
            newImages{i} = double(rgb2gray(outImages{i}))/255;
        else
            newImages{i} = double(outImages{i})/255;
        end
    end
    for i=1:size(outImages,2)
        figure(149+i),imshow(newImages{i});
        set(gcf, 'color', 'white');
        %axis ij
    end
else
    if (size(outImages,3)~=1)
        newImages=double(rgb2gray(outImages))/255;
    else
        newImages = double(outImages)/255;
    end
end
