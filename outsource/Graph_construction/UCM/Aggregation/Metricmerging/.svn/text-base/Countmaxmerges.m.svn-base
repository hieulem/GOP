function [maxmerges, alldistances, mapping]=Countmaxmerges(alldistances, mapping, noallsuperpixels)
% noallsuperpixels=size(similarities,1);

%At distance alldistances(i) the following two points are merged
% point1=mapping(1,i);
% point2=mapping(2,i);

numberofpairs=numel(alldistances);
labelsfc=1:noallsuperpixels;

usefull=false(1,numberofpairs);

for i=1:numberofpairs
    point1=mapping(1,i);
    point2=mapping(2,i);
    
    label1=labelsfc(point1);
    label2=labelsfc(point2);

    if (label1==label2)
        continue;
    end
    
    if (label1<label2)
        themin=label1;
        themax=label2;
    else
        themin=label2;
        themax=label1;
    end
    
    labelsfc(labelsfc==themax)=themin;
    labelsfc(labelsfc>themax)=labelsfc(labelsfc>themax)-1;
    
    usefull(i)=true;
    maxmerges=i;
    
end

fprintf('Countmaxmerges: Labels left to merge %d\n',numel(unique(labelsfc)));

alldistances=alldistances(usefull);
mapline1=mapping(1,:);
mapline2=mapping(2,:);

mapline1=mapline1(usefull);
mapline2=mapline2(usefull);

mapping=[mapline1;mapline2];

% size(alldistances)
% size(mapping)
% size(mapline1)

