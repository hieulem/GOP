function [posbin,negbin,bincenters,themin,themax,casefound]=Inittheparametercalibrationhistogram(theaffinityname)

if (isstruct(theaffinityname))
    thiscase=theaffinityname.name;
else
    thiscase=theaffinityname;
end

casefound=true;
switch(thiscase)
    case 'sta'
        themin=0;
        themax=4000;
        numberofbins=6000;
    case 'stm'
        themin=0;
        themax=10;
        numberofbins=3000;
    case 'abm'
        themin=0;
        themax=5;
        numberofbins=1000;
    case 'aba'
        themin=0;
        themax=1;
        numberofbins=1000;
    case 'ltt'
        themin=0;
        themax=1;
        numberofbins=1000;
    case 'stt'
        themin=0;
        themax=1;
        numberofbins=1000;
    case 'resampled'
        themin=0;
        themax=1;
        numberofbins=1000;
    otherwise
        fprintf('Case not specified\n');
        themin=0;
        themax=1;
        numberofbins=1000;
        casefound=false;
end



%Ad hoc parameters, if defined
if (isstruct(theaffinityname))
    if (isfield(theaffinityname,'adhocnbins'))
        numberofbins=theaffinityname.adhocnbins;
    end
    if (isfield(theaffinityname,'adhocmin'))
        themin=theaffinityname.adhocmin;
    end
    if (isfield(theaffinityname,'adhocmax'))
        themax=theaffinityname.adhocmax;
    end
end



%Define bin centers and initialize histograms
bincenters=themin:(themax-themin)/(numberofbins-1):themax; %bin centers

posbin=zeros(1,numberofbins);
negbin=zeros(1,numberofbins);
