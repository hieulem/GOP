function [ C,pos_dist ] = pop_neighbor_matrix_hist( geo_hist1,geo_hist2,offset)
%POP_NEIGHBOR_MATRIX 
% Pop sparse neighbor matrix from sf frame to tf, each sp search for its
% neighbors in offset radius
pos_ = pdist2(geo_hist1(:,:), geo_hist2(:,:), 'emd' );
pos_dist=pos_;
pos_(pos_ > offset) = 0;

C = spfun(@(x) 1, pos_);
C(logical(eye(size(pos_)))) = 1;
end

 