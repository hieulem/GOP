function [noSelected,meanlength,stdlength]=Getmeanstdtrajectorylengths(trajectories,selectedtreetrajectories)

noTrajectories=numel(trajectories);
if ( (~exist('selectedtreetrajectories','var')) || (isempty(selectedtreetrajectories)) )
    selectedtreetrajectories=true(1,noTrajectories);
end

theselected=find(selectedtreetrajectories);
noSelected=sum(selectedtreetrajectories);

if (noSelected<1)
    meanlength=-1; stdlength=-1;
    return;
end

totallengths=0;
totalsquaredlength=0;
for j=theselected
    totallengths=totallengths+trajectories{j}.totalLength;
    totalsquaredlength=totalsquaredlength+(trajectories{j}.totalLength)^2;
end


meanlength=totallengths/noSelected;
stdlength= sqrt( (totalsquaredlength/noSelected) - (meanlength^2) );