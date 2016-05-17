function SE=Getstrel(thicker)

if ( (~exist('thicker','var')) || (isempty(thicker)) )
    thicker=false;
end

if (thicker)
    SE = strel('diamond',6);
else
    SE = strel('square',3);
end