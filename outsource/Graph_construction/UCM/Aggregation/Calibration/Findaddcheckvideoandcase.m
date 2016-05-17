function [allthescores]=Findaddcheckvideoandcase(allthescores,theaffinity,score)
% allthescores.affinities cell array
% allthescores.scores cell array

%Search for affinity name
theaffpos=0;
for i=1:numel(allthescores.affinities)
    if (strcmp(allthescores.affinities{i},theaffinity))
        theaffpos=i;
        break;
    end
end

%Create non-existing affinity
if (theaffpos==0)
    theaffpos=numel(allthescores.affinities)+1;
    allthescores.affinities{theaffpos}=theaffinity;
    allthescores.scores{theaffpos}=zeros(size(score));
end

%Add new score
allthescores.scores{theaffpos}=allthescores.scores{theaffpos}+score;

