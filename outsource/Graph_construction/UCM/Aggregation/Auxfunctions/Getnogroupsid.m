function nogroupsvalues=Getnogroupsid(nototlabels,framestoconsider,nocases,themin,themax,remultiply)

% averageframelabels/40
% 
% averageframelabels*3
% 
% log2(averageframelabels*3/(averageframelabels/40))
% 
% (averageframelabels/40)*((2^0.25)^28)
% 
% 58*30/(3600)

if ( (~exist('nocases','var')) || (isempty(nocases)) )
    nocases=48;
end
if ( (~exist('remultiply','var')) || (isempty(remultiply)) )
    remultiply=true;
end


powtwostep=0.125;
extranogroups=2;
averageframelabels=nototlabels/numel(framestoconsider);
if ( (~exist('themin','var')) || (isempty(themin)) )
    themin=averageframelabels/((2^powtwostep)^(nocases+extranogroups));
end
if ( (~exist('themax','var')) || (isempty(themax)) )
    themax=averageframelabels/((2^powtwostep)^(1));
end


nogroupsvalues=0:1:(nocases-1);

nogroupsvalues=nogroupsvalues*(themax-themin)/(nocases-1)+themin;

if (remultiply)
    nogroupsvalues=floor(nogroupsvalues*numel(framestoconsider));
else
    nogroupsvalues=floor(nogroupsvalues);
end




