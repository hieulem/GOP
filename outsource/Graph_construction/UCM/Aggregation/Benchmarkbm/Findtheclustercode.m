function theclustercode=Findtheclustercode(thefilename)
% thefilename=iids(1).name
%it is assumed that four characters are used for the .ext



wheretheat=strfind(thefilename,'_');
if (isempty(wheretheat))
    theclustercode=[];
    fprintf('\nReturned theclustercode empty\n\n');
else
    theclustercode=thefilename(1:wheretheat(1)-1);
end

