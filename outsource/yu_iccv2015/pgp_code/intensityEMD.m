%intensityEMD.m
%
%this calculates the EMD between 2 intensity distributions

%input should be between 0 to 255
function output = intensityEMD(region1, region2)

%make them into cdf
t1 = hist(region1, 0:1:255);
t1 = t1./sum(t1);
%t1 = cumsum(t1);

t2 = hist(region2, 0:1:255);
t2 = t2./sum(t2);
%t2 = cumsum(t2);

output =  sum(abs(cumsum(t1-t2)))/256;
%output = emd_r(t1', t2');