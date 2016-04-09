function [conrr,concc]=Getconnectivityof(varargin)

%Compute OR of input matrices
similaritiesexisting=(varargin{1}>0);
for i=2:size(varargin,2)
    similaritiesexisting=similaritiesexisting|(varargin{i}>0);
end

%Check simmetry of similaritiesexisting
similaritiesexisting=similaritiesexisting|(similaritiesexisting');

% full(similaritiesexisting)

%Find non-zero elements
[conrr,concc]=find(similaritiesexisting);


%Keep symmetric elements once
includediagonal=true;
if (includediagonal) %Lower diagonal matrix is kept
    whichtodelete=(conrr<concc);
else
    whichtodelete=(conrr<=concc);
end

conrr(whichtodelete)=[];
concc(whichtodelete)=[];



