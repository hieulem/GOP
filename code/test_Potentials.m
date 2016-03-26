function [ final_dist ] = Potentials( sf,tf,sp,hist,pos,RGB_dist )
%spp = sp(:,:,2);
%figure(1);imshow(I(:,:,:,1));

phi_hist_sq = 0.5;
hist_dist = pdist2(hist{sf}(:,:), hist{tf}(:,:), 'chisq' );
hist_dist = exp(-hist_dist/phi_hist_sq);
hist_dist = hist_dist./repmat(sum(hist_dist,2),[1,size(hist_dist,2)]);
%hist_dist(366,366) = 0;
%visdistance(sp(:,:,1),hist_dist(366,:));

phi_pos =3;
pos_dist = pdist2(pos{sf}(:,:), pos{tf}(:,:), 'euclidean' );
pos_dist = double(exp(-pos_dist/phi_pos^2));
pos_dist = pos_dist./repmat(sum(pos_dist,2),[1,size(pos_dist,2)]);
%pos_dist(pos_dist < 1e-3) = 0;
%visdistance(spp,pos_dist(100,:));

phi_RGB =3;
RGB_dist = pdist2(rgbhistogram{sf}(:,:), rgbhistogram{tf}(:,:), 'chisq' );
RGB_dist = double(exp(-RGB_dist/phi_RGB^2));
RGB_dist = RGB_dist./repmat(sum(RGB_dist,2),[1,size(RGB_dist,2)]);

visdistance(spp,RGB_dist(10,:));

final_dist = (hist_dist + 0.3*RGB_dist).*pos_dist;
final_dist =final_dist./repmat(sum(final_dist,2),[1,size(final_dist,2)]);


%k = diag(ones(1,splist(1)));
%k=1-k;
%final_dist = final_dist.*k;




end

