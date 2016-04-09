function thevideoname=Findthevideosequencename(thefilename)
% thefilename=iids(1).name
%it is assumed that four characters are used for the .ext



wheretheat=strfind(thefilename,'_atc_');
if (isempty(wheretheat))
    thevideoname=thefilename(1:end-4);
else
    thevideoname=thefilename(1:wheretheat(1)-1);
end

