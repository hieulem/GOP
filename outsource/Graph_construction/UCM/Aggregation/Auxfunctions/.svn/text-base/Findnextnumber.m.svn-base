function [number,startpos]=Findnextnumber(astring,startpos,thechar)

i=startpos;
while ( (strcmp(astring(i),thechar)) && (i<=numel(astring)) )
    i=i+1;
end

if (i>numel(astring)) %number not found
    number='';
    startpos='';
    return
end

firstchar=i;

i=i+1;
while ( (i<=numel(astring)) && (~strcmp(astring(i),thechar)) )
    i=i+1;
end
i=i-1;

lastchar=i;

if (i==numel(astring))
    startpos=0;
else
    startpos=i+1;
end

number=str2double(astring(firstchar:lastchar));

if (isnan(number))
    number='';
    startpos='';
end



