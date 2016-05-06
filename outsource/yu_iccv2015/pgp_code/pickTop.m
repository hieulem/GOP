%pickTop.m
%
%keep only the top k most similar neighbors
%
%fAffinity: feature specific similarity matrix
%
%tAffinity: combined similarity matrix

function outSims = pickTop(offSet1, offSet2, fAffinity, tAffinity, k)

%Sort by size, then location, then shape, then intensity, then color, then
%orientation.
pairsF = [];
pairsB = [];

%for backwards
tAffinity2 = tAffinity;
fAffinity2 = fAffinity;

regionInd = 1:size(tAffinity,1);
regionInd2 = 1:size(tAffinity,2);

for i = 1:k
    
%forward
[minVals, forward] = min(tAffinity, [], 2);
ind = sub2ind(size(tAffinity), regionInd', forward);

if i == 1
    pairsF = [regionInd', forward, fAffinity(ind)];
else
    pairsF = [pairsF; [regionInd', forward, fAffinity(ind)]];
end

%set the min values -> Inf
tAffinity(ind) = Inf;
%fAffinity(ind) = Inf;

%backward
[minVals, backward] = min(tAffinity2, [], 1);
ind = sub2ind(size(tAffinity2), backward', regionInd2');

if i == 1
    pairsB = [regionInd2', backward', fAffinity2(ind)];
else
    pairsB = [pairsB; [regionInd2', backward', fAffinity2(ind)]];
end

%set the min values -> Inf
tAffinity2(ind) = Inf;
%fAffinity2(ind) = Inf;

end

%first, get rid of the Inf ones
% pairsF(isinf(pairsF(:,3)),:) = [];
% pairsB(isinf(pairsB(:,3)),:) = [];

pairsF(:,1) = pairsF(:,1) + offSet1;
pairsF(:,2) = pairsF(:,2) + offSet2;

pairsB(:,1) = pairsB(:,1) + offSet2;
pairsB(:,2) = pairsB(:,2) + offSet1;

outSims = unique([[pairsF(:,1); pairsB(:,2)], [pairsF(:,2); pairsB(:,1)], [pairsF(:,3); pairsB(:,3)]], 'rows');

