function [ final_dist ] = pop_dist( geo_hist1,pos1,L_hist1,A_hist1,B_hist1,...
                                                                geo_hist2,pos2,L_hist2,A_hist2,B_hist2 )
%POP_UNARY_POTENTIALS Summary of this function goes here
%   Detailed explanation goes here


hist_dist = pdist2(geo_hist1(:,:), geo_hist2(:,:), 'emd' );
hist_dist = hist_dist ./ (max(max(hist_dist)));
hist_dist(hist_dist>0.2) = inf;
%hist_dist = hist_dist./repmat(max(hist_dist,[],2),[1,size(hist_dist,2)]);

pos_dist = pdist2(pos1(:,:), pos2(:,:), 'euclidean' );

pos_dist = pos_dist ./ (max(max(pos_dist)));
pos_dist(pos_dist>0.2) = inf;
%pos_dist = pos_dist./repmat(max(pos_dist,[],2),[1,size(pos_dist,2)]);


L_dist = pdist2(L_hist1(:,:), L_hist2(:,:), 'emd' );
L_dist_n = L_dist ./ (max(max(L_dist)));

A_dist = pdist2(A_hist1(:,:), A_hist2(:,:), 'emd' );
A_dist_n = A_dist ./ (max(max(A_dist)));

B_dist = pdist2(B_hist1(:,:), B_hist2(:,:), 'emd' );
B_dist_n = B_dist ./ (max(max(B_dist)));

LAB_dist = L_dist+A_dist+B_dist;

LAB_dist = LAB_dist ./ (max(max(LAB_dist)));
LAB_dist(LAB_dist>0.2) = inf;
% LAB_dist(L_dist_n>0.2) = inf;
% LAB_dist(A_dist_n>0.2) = inf;
% LAB_dist(B_dist_n>0.2) = inf;

LH = hist_dist+LAB_dist;
final_dist = hist_dist+LAB_dist + pos_dist;
%final_dist=final_dist./ (max(max(final_dist)));
final_dist(LH>0.4) = inf;
end

