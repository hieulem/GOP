function [thevideoname,theaffinity]=Findthecaseandaffinity(thename)
% thename is the name (without extension)



wheretheunderscore=strfind(thename,'_');

if (numel(wheretheunderscore)~=2)
    fprintf('Name and the standard %s\n',thename);
    thevideoname='';
    theaffinity='';
    return;
end

thevideoname=thename(1:wheretheunderscore(1)-1);
theaffinity=thename(wheretheunderscore(1)+1:wheretheunderscore(2)-1);

