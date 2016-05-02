%colorEMD.m
%
%this function calculates the emd score between L*a*b colorspace
%
%Chen-Ping Yu

function output = labEMD( patch1, patch2 )


%L: 0 to 100, a and b: -110 to 110
hist1 = hist(round(patch1), -110:110);
hist2 = hist(round(patch2), -110:110);

%normalize the histogram so it sums to 1
total1 = sum(sum(hist1));
hist1 = hist1./total1;

%normalize the histogram so it sums to 1
total2 = sum(sum(hist2));
hist2 = hist2./total2;

n = length(hist1);

%output = emd_r(hist1, hist2);
output = sum(abs(cumsum(hist1-hist2)))/n;
end

