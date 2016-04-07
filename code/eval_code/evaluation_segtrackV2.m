function output = evaluation_segtrackV2(pgpOutput, inputGT)


%inputGT = 'E:\matlab2011b\work\video_segmentation\data\SegTrackv2\GroundTruth\bmx\';
%pgpOutput = 'E:\matlab2011b\work\video_segmentation\outputs\bmx\';
t = dir(inputGT);

t(1) = [];  %.
t(1) = [];  %..

numGT = length(t);

perGTStat = zeros(numGT, 4);

for i = 1:numGT
    perGTStat(i,:) = evaluation_segtrack(pgpOutput, [inputGT,'/', num2str(i), '/']);
end

%output = mean(perGTStat);
output = perGTStat;