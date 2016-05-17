function [bincounts,bincenters]=Prepareatwodhistogram(minU,maxU,minV,maxV,binunumbers,binvnumbers)

ucenters=minU:(maxU-minU)/(binunumbers-1):maxU; %u bin centers
vcenters=minV:(maxV-minV)/(binvnumbers-1):maxV; %v bin centers

bincenters{1}=ucenters; %binunumbers elements
bincenters{2}=vcenters; %binvnumbers elements

bincounts=zeros([binunumbers,binvnumbers]);

% bincounts(n,m) corresponds to flows closer to the center ucenters(n), v<ucenters(m)

