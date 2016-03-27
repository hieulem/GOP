function uniquelabelswhichmustlink=Computeuniquelabelswhichmustlinkmex(remappedlabels,labelledleveltmp,numberofsuperpixels,maxnewlabelsalreadyassigned)
%Compute uniquelabelswhichmustlink
%Assume that segments from twsegmentation do not span multiple superpixels
%This version should be much faster in a c implementation

USEMEX=true;

if (USEMEX)
    
    uniquelabelswhichmustlink=Computeuniquelabelswhichmustlinkmeximpl(remappedlabels,labelledleveltmp,numberofsuperpixels,maxnewlabelsalreadyassigned); %Computeuniquelabelswhichmustlinkmeximpl.cpp
    
else
    
    uniquelabelswhichmustlink=zeros(1,numberofsuperpixels);
    
    for j=1:numel(remappedlabels)

        i=remappedlabels(j);
        if ( (i>=1) && (i<=maxnewlabelsalreadyassigned) )
            uniquelabelswhichmustlink(labelledleveltmp(j))=i;
        end
    end
    
end


