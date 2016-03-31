function [ aff ] = compute_affinitymatrix( sp,edge,grayimg,splist)
%COMPUTE_AFFINITYMATRIX Summary of this function goes here
%   Detailed explanation goes here
numi = size(grayimg,3);
geo_hist2d = cell(numi,1);

for ii=1:inp.numi
    Z = spAffinities_vu(sp(:,:,ii),edge(:,:,ii);
    Z(Z<0) =0 ;Z = sparse(double(Z));
    nsp = splist(ii);
    area =zeros(1,nsp);
    for k =1:nsp
        area(k) = sum(sum(sp(:,:,ii) == k))/(h*w);
    end
    
end

    
end



end

