function [ ind,score ] = findbestMatch( feature,feature2 )
n2 = size(feature2,1);
f1 = repmat(feature,[n2,1]);
%k=(f1-feature2).^2;
k=(f1-feature2).^2;

t=sum(k,2);
[score,ind] = sort(t,'ascend');

end

