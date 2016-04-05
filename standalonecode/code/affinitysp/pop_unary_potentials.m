function [ final_dist ] = pop_unary_potentials( start_frame,geo_hist,pos,L_hist,A_hist,B_hist )
%POP_UNARY_POTENTIALS Summary of this function goes here
%   Detailed explanation goes here

target_frame = start_frame-1;

hist_dist = pdist2(geo_hist{start_frame}(:,:), geo_hist{target_frame}(:,:), 'emd' );
hist_dist = hist_dist./repmat(max(hist_dist,[],2),[1,size(hist_dist,2)]);

pos_dist = pdist2(pos{start_frame}(:,:), pos{target_frame}(:,:), 'euclidean' );
pos_dist = pos_dist./repmat(max(pos_dist,[],2),[1,size(pos_dist,2)]);


L_dist = pdist2(L_hist{start_frame}(:,:), L_hist{target_frame}(:,:), 'emd' );

A_dist = pdist2(A_hist{start_frame}(:,:), A_hist{target_frame}(:,:), 'emd' );

B_dist = pdist2(B_hist{start_frame}(:,:), B_hist{target_frame}(:,:), 'emd' );

LAB_dist = L_dist+A_dist+B_dist;
LAB_dist = LAB_dist./repmat(max(LAB_dist,[],2),[1,size(LAB_dist,2)]);


final_dist = hist_dist+ LAB_dist + pos_dist;



end

