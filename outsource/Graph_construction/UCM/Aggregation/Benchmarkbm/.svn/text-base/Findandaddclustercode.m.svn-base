function [allcodes,thepos]=Findandaddclustercode(allcodes,theclustercode)

thepos=0;
for i=1:numel(allcodes)
    if (strcmp(allcodes{i},theclustercode))
        thepos=i;
        break;
    end
end
if (thepos==0)
    thepos=numel(allcodes)+1;
    allcodes{thepos}=theclustercode;
end
