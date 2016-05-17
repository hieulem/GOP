function numberofclusters=Getnumberofclustersnooutliers(IDX,outliervalue)

if ( (~exist('outliervalue','var')) || (isempty(outliervalue)) )
    outliervalue=-1; %in general <0
end

numberofclusters=numel(unique(IDX))-any(IDX==outliervalue);


