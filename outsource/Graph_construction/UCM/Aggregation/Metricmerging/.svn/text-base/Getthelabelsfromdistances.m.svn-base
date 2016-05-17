function [labelsfc,valid]=Getthelabelsfromdistances(labelsfc, mapping, startmerge, endmerge)
% labelsfc=consideredlabelsfc;
% startmerge=(mergesteps(level+1)+1); endmerge=mergesteps(level+2);

%At distance alldistances(i) the following two points are merged
% point1=mapping(1,i);
% point2=mapping(2,i);


for i=startmerge:endmerge
    point1=mapping(1,i);
    point2=mapping(2,i);
    
    label1=labelsfc(point1);
    label2=labelsfc(point2);

    if (label1==label2)
        fprintf('Repeated labels should have been removed by functino Countmaxmerges\n');
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
    
end

valid=true;

fprintf('Labels left to merge %d\n',numel(unique(labelsfc)));




