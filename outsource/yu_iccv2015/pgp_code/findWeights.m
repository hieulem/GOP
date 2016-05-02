%findWeights.m
%
%compute the adaptive feature weights

function [intW, hueW, labW, oriW, motionW] = findWeights(maxWeights, currMax, labelsList, fromST, toST, spList, satImg, lImg, uvMag, mag, mErr)

maxInt = maxWeights(1);
maxHue = maxWeights(2);
maxLab = maxWeights(3);
maxO = maxWeights(4);
maxM = maxWeights(5);

%first, find the frame number for the from and to superpixels
fromF = find(fromST <= labelsList,1);
toF = find(toST <= labelsList,1);

currMaxI = currMax(1);
currMaxC = currMax(2);
currMaxO = currMax(3);
currMaxM = currMax(4);

%% color
avgSat = mean([satImg{fromF}(spList{fromST}); satImg{toF}(spList{toST})]);
hueW = maxHue*avgSat;
labW = maxLab*avgSat;


%% orientation
avgO = mean([mag{fromF}(spList{fromST}); mag{toF}(spList{toST})]);
oriW = maxO*avgO/currMaxO;

%% motion
if maxM == 0 || mErr == 1% it is a temporal connection, then no motion
    motionW = 0;
else
    avgM = mean([uvMag{fromF}(spList{fromST}); uvMag{toF}(spList{toST})]);
    motionW = maxM*avgM/currMaxM;
end

%% intensity
%diffInt = abs(mean(lImg{fromF}(spList{fromST}))/100 - mean(lImg{toF}(spList{toST}))/100);
%avgInt = mean([lImg{fromF}(spList{fromST}); lImg{toF}(spList{toST})]);
%minLightW = 0.5; %when lightness is at the middle, the lowest weight is set at <-

%[aLow, bLow] = linTransform(0, 50, 1, minLightW);
%[aHigh, bHigh] = linTransform(50, 100, minLightW, 1);

%if avgInt < 50
%    avgInt = aLow*avgInt + bLow;
%else
%    avgInt = aHigh*avgInt + bHigh;
%end

%intW = maxInt*avgInt;

intW = 1-avgSat;









