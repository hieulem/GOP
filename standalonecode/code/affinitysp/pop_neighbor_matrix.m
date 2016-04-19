function [ C,pos_dist ] = pop_neighbor_matrix( pos1,pos2,offset)
%POP_NEIGHBOR_MATRIX 
% Pop sparse neighbor matrix from sf frame to tf, each sp search for its
% neighbors in offset radius
pos_ = pdist2(pos1(:,:), pos2(:,:), 'euclidean' );
pos_dist=pos_;
pos_(pos_ > offset^2) = 0;

C = spfun(@(x) 1, pos_);
C(logical(eye(size(pos_)))) = 1;
end

 