minx = max(1,uint32(X(1)-offset));
miny = max(1,uint32(X(2)-offset));
maxx = min(siz(1),uint32(X(1)+offset));
maxy = min(siz(2),uint32(X(2)+offset));

setsp =unique(sp(minx:maxx,miny:maxy,2));