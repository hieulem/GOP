function [ final_dist ] = pop_dist_all( geo_hist1,geo_hist2d1,pos1,L_hist1,A_hist1,B_hist1,...
                                                        H_hist1,S_hist1,V_hist1,...
                                                                geo_hist2,geo_hist2d2,pos2,L_hist2,A_hist2,B_hist2, H_hist2,S_hist2,V_hist2 )
%POP_UNARY_POTENTIALS Summary of this function goes here
%   Detailed explanation goes here

phi_hist_sq=0.01;
%hist_dist_o = pdist2(geo_hist1(:,:), geo_hist2(:,:), 'chisq' );
hist_dist_o = pdist2(geo_hist2d1,geo_hist2d2,'chisq2d');
hist_dist_n = exp(-hist_dist_o/0.05);
% mep = mean(hist_dist_o,2);
% varp = var(hist_dist_o,[],2);
% hist_dist_n = (hist_dist_o - repmat(mep,[1,size(hist_dist_o,2)])) ./ repmat(varp,[1,size(hist_dist_o,2)]);

%phi_hist_sq=0.01;
%hist_dist = exp(-hist_dist_o/phi_hist_sq);
%hist_dist = hist_dist /(max(max(hist_dist)));

pos_dist = pdist2(pos1(:,:), pos2(:,:), 'euclidean' );
%  mep = mean(pos_dist,2);
%  varp = var(pos_dist,[],2);
%  pos_dist_n = (pos_dist - repmat(mep,[1,size(pos_dist,2)])) ./ repmat(varp,[1,size(pos_dist,2)]);
pos_dist_n = exp(-pos_dist/20);


L_dist = pdist2(L_hist1(:,:), L_hist2(:,:), 'emd' );
L_dist_n = L_dist ./ (max(max(L_dist)));

A_dist = pdist2(A_hist1(:,:), A_hist2(:,:), 'emd' );
A_dist_n = A_dist ./ (max(max(A_dist)));

B_dist = pdist2(B_hist1(:,:), B_hist2(:,:), 'emd' );
B_dist_n = B_dist ./ (max(max(B_dist)));

LAB_dist = L_dist_n+A_dist_n+B_dist_n;

LAB_dist_n = exp(-LAB_dist/1.5);
% mep = mean(LAB_dist,2);
% varp = var(LAB_dist,[],2);
% LAB_dist_n = (LAB_dist - repmat(mep,[1,size(LAB_dist,2)])) ./ repmat(varp,[1,size(LAB_dist,2)]);
% 


H_dist = pdist2(H_hist1(:,:), H_hist2(:,:), 'emd' );
H_dist_n = H_dist ./ (max(max(H_dist)));

S_dist = pdist2(S_hist1(:,:),S_hist2(:,:), 'emd' );
S_dist_n = S_dist ./ (max(max(S_dist)));

V_dist = pdist2(V_hist1(:,:), V_hist2(:,:), 'emd' );
V_dist_n = V_dist ./ (max(max(V_dist)));

HSV_dist = H_dist_n+V_dist_n+S_dist_n;
HSV_dist = exp(-HSV_dist);

HSV_dist = HSV_dist ./ (max(max(HSV_dist)));
%HSV_dist(HSV_dist>0.6) = inf;


%LH = hist_dist+LAB_dist;
w1= 1;
w2=2;
w3=2;
final_dist =w2*pos_dist_n + w3*LAB_dist_n + hist_dist_n*w1 + HSV_dist;
%final_dist = LAB_dist.*HSV_dist.*pos_dist;
%final_dist = LAB_dist + HSV_dist +pos_dist;
%final_dist=final_dist./ (max(max(final_dist)));
%final_dist(LH>0.4) = inf;
%final_dist(pos_dist>0.3) = inf;
%final_dist(H_dist_n>0.1) = inf;
end

