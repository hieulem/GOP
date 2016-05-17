function trajectories=Mergetrajectorylabels(trajectories,labelsmerged)

if (numel(labelsmerged)<=1)
    return;
end

for i=1:numel(trajectories)
    if ( any(trajectories{i}.nopath==labelsmerged(2:end)) )
        trajectories{i}.nopath=labelsmerged(1);
    end
end
