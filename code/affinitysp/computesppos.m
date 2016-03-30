function [ X ] = computesppos( sp,seed )
%COMPUTESPPOS Summary of this function goes here
%   Detailed explanation goes here
siz = size(sp);
[t1,t2] = ind2sub(siz,find(sp==seed));
    if(length(t1)>1)
        X = mean([t1,t2]);
    else
        X = [t1,t2];
    end;

end

