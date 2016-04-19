function [ c,m ] = avglensv( allthesegmentations )
%AVGLENSV Summary of this function goes here
%   Detailed explanation goes here
numfr = size(allthesegmentations{1});
numlv = length(allthesegmentations);
c = zeros(numlv,1);
m = zeros(numlv,1);
for i=1:numlv
    a(i) = length(unique(allthesegmentations{i}));
    lesv = zeros(1,a(i));
    for j=1:numfr(end)
        b = unique(allthesegmentations{i}(:,:,j));
        lesv(b) = lesv(b)+1;
    end
    c(i) = sum(lesv)/a(i);
    m(i) = median(lesv);
end;


end

