function [allnames,nameoccurrences,stepkocc,repeatedocc,thevpos,allthepos]=Findaddcheckavideoname(allnames,nameoccurrences,stepkocc,thevideoname,scorecol)
% scorecol=score(:,1)

[allnames,thevpos]=Addfindname(allnames,thevideoname);

repeatedocc=false(size(scorecol));
allthepos=zeros(1,numel(scorecol));
for j=1:numel(scorecol)
    thepos=find(stepkocc==scorecol(j),1);
    if (isempty(thepos))
        thepos=numel(stepkocc)+1;
        stepkocc(thepos)=scorecol(j);
    end
    allthepos(j)=thepos;

    if ( (all(size(nameoccurrences)>=[thevpos,thepos])) && (nameoccurrences(thevpos,thepos)) )
        fprintf('\n\nVideo sequence repetition encountered (%s,%d)\n\n\n',allnames{thevpos},stepkocc(thepos));
        repeatedocc(j)=true;
    else
        nameoccurrences(thevpos,thepos)=true;
    end
end
