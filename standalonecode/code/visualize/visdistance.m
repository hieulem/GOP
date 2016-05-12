function [ A ] = visdistance( sp,dist )
%VISDISTANCE Summary of this function goes here
%   Detailed explanation goes here
    A = double(sp);
    for i=1:length(dist)
        A(sp == i) = dist(i);
    end;
    
%    imagesc(A);

end

