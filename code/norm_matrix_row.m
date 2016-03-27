function [ out ] = norm_to_one( X )
%NORM_TO_ONE Summary of this function goes here
%   Detailed explanation goes here
out = zeros(size(X));
for i=1:size(X,2)
    out(i,:) = X(i,:) / norm(X(i,:),1);
end

end

