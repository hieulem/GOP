function [framebelong,labelsatframe,numberofelements]=Getmappedframes(mapped)
%for inverse mapping
%[frame,label]=find(mapped==indexx);
%or
%[framebelong,labelsatframe,numberofelements]=Getmappedframes(mapped);
%The function is related to
% [mapped,framebelong,noallsuperpixels,maxnolabels]=Mappedfromlabels(labelledvideo,printonscreen)

lmapped=(mapped'>0);

maxnolabels=size(lmapped,1);
noframes=size(lmapped,2);
[X,Y]=meshgrid(1:noframes,1:maxnolabels);

framebelong=X(lmapped);

if (nargout>1)
    labelsatframe=Y(lmapped);
    
    numberofelements=sum(lmapped(:));
end

framebelong=reshape(framebelong,1,[]);



function Testthefunction(mapped,similarities) %#ok<DEFNU>

[framebelong,labelsatframe]=Getmappedframes(mapped);

for indexx=1:size(similarities,1)
    [frame,label]=find(mapped==indexx);
    
    if (frame~=framebelong(indexx))
        fprintf('*');
    end
    if (label~=labelsatframe(indexx))
        fprintf('+');
    end
end
