function [ c,m ] = avglen_one_lv( allthesegmentations )
%AVGLENSV Summary of this function goes here
%   Detailed explanation goes here
numfr = size(allthesegmentations);

c = 0;
m = 0;

a = length(unique(allthesegmentations));
lesv = zeros(1,a);
for j=1:numfr(end)
    b = unique(allthesegmentations(:,:,j));
    lesv(b) = lesv(b)+1;
end
c = sum(lesv)/a;
m = median(lesv);



end

