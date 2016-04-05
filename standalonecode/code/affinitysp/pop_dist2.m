function [ final_dist ] = pop_dist( geo_hist1,L_hist1,A_hist1,B_hist1,...
                                                                geo_hist2,L_hist2,A_hist2,B_hist2 )
%POP_UNARY_POTENTIALS Summary of this function goes here
%   Detailed explanation goes here

phi_hist_sq=0.4;
hist_dist = pdist2(geo_hist1(:,:), geo_hist2(:,:), 'emd' );
hist_dist = exp(-hist_dist/phi_hist_sq);

L_dist = pdist2(L_hist1(:,:), L_hist2(:,:), 'emd' );
%L_dist_n = L_dist ./ (max(max(L_dist)));

A_dist = pdist2(A_hist1(:,:), A_hist2(:,:), 'emd' );
%A_dist_n = A_dist ./ (max(max(A_dist)));

B_dist = pdist2(B_hist1(:,:), B_hist2(:,:), 'emd' );
%B_dist_n = B_dist ./ (max(max(B_dist)));

LAB_dist = L_dist+A_dist+B_dist;
LAB_dist = exp(-LAB_dist/1.5);

final_dist = (hist_dist.*LAB_dist);

end

