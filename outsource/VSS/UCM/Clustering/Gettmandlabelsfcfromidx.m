function [labelsfc,Tm,valid]=Gettmandlabelsfcfromidx(IDX,Y,T,maintaintleveloneconnections,tlevelone,allowchanget)
%Computation of outputs of isomap: Tm and labelsfc_output

%The clustering of kmeans in the manifold is already backmapped to the tracks
%So labelsfc are given by a simple reshaping of the vector

labelsfc=reshape(IDX,1,[]); %The generated labelsfc have no gaps, these are compacted in Clusterthepoints
%In fact, this is just a reshape
 
%Computation of first output is complete
if (nargout<2)
    return;
end


%Warning about input values
if (nargin<2)
    fprintf('Tm and valid variables are required but some input values are missing, using default values (T fully connected)\n');
    T=[];
end


%Check multiple or missing mappings in Y and define valid
if (isfield(Y,'missing'))
    theallpoints=[Y.index;Y.missing];
else
    theallpoints=Y.index;
end
if numel(unique(theallpoints))~=numel(theallpoints)
    if ( numel(unique(theallpoints))<numel(theallpoints) )
        fprintf('Found multiple values in backmapping\n');
    else
        fprintf('Found empty values in backmapping\n');
    end
    valid=false;
else
    valid=true;
end
clear theallpoints;



if ( (~exist('allowchanget','var')) || (isempty(allowchanget)) )
    allowchanget=true; %connections are added to preserve the connectivity and clustering of labelsfc on T
end

Tm=Turnlabelstotm(labelsfc,T,allowchanget);



%to use to maintain the connections at the lower level
if ( (exist('maintaintleveloneconnections','var')) && (~isempty(maintaintleveloneconnections)) && (maintaintleveloneconnections) &&...
         (exist('tlevelone','var')) && (~isempty(tlevelone)) )
    Tm=Tm&tlevelone;
end


