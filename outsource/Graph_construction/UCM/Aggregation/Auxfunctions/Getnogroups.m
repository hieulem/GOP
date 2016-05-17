function nogroupsvalues=Getnogroups(nototlabels,framestoconsider)

% averageframelabels/40
% 
% averageframelabels*3
% 
% log2(averageframelabels*3/(averageframelabels/40))
% 
% (averageframelabels/40)*((2^0.25)^28)
% 
% 58*30/(3600)


averageframelabels=nototlabels/numel(framestoconsider);

nocases=48;
powtwostep=0.125;
extranogroups=2;

basepow=averageframelabels/((2^powtwostep)^(nocases+extranogroups));

nogroupsvalues=zeros(1,nocases);
for i=1:nocases
    
    nogroupsvalues(i)=basepow;
    
    basepow=basepow*(2^powtwostep);
    
end

nogroupsvalues=floor(nogroupsvalues*numel(framestoconsider));

