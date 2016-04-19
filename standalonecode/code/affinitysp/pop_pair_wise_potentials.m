function [ final_dist ] = pop_pair_wise_potentials( sf,tf,geo_hist,pos,L_hist,A_hist,B_hist )

phi_hist_sq = 0.5;
hist_dist = pdist2(geo_hist{sf}(:,:), geo_hist{tf}(:,:), 'chisq' );
hist_dist = exp(-hist_dist/phi_hist_sq);

%visdistance(sp(:,:,1),hist_dist(366,:));

phi_pos =3;
pos_dist = pdist2(pos{sf}(:,:), pos{tf}(:,:), 'euclidean' );
pos_dist = double(exp(-pos_dist/phi_pos^2));


L_dist = pdist2(L_hist{sf}(:,:), L_hist{tf}(:,:), 'emd' );
A_dist = pdist2(A_hist{sf}(:,:), A_hist{tf}(:,:), 'emd' );
B_dist = pdist2(B_hist{sf}(:,:), B_hist{tf}(:,:), 'emd' );

phi_LAB =3;
LAB_dist = L_dist+A_dist+B_dist;
LAB_dist = double(exp(-LAB_dist/phi_LAB^2));


%visdistance(spp,RGB_dist(231,:));

final_dist =LAB_dist + pos_dist + hist_dist;% hist_dist + 


%final_dist =final_dist./repmat(sum(final_dist,2),[1,size(final_dist,2)]);

end

