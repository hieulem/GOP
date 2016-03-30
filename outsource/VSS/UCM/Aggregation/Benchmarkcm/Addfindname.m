function [allvideonames,thevpos]=Addfindname(allvideonames,thevideoname)

thevpos=0;
for i=1:numel(allvideonames)
    if (strcmp(allvideonames{i},thevideoname))
        thevpos=i;
        break;
    end
end
if (thevpos==0)
    thevpos=numel(allvideonames)+1;
    allvideonames{thevpos}=thevideoname;
end

