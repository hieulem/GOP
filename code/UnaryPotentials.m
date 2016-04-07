tic;
sf = 2;
tf = 1;
ch = 371;
spp = sp(:,:,2);
figure(1);imshow(I(:,:,:,1));

phi_hist_sq = 0.5;
hist_dist = pdist2(geo_hist{sf}(:,:), geo_hist{tf}(:,:), 'emd' );

%hist_dist =-log(hist_dist);
%hist_dist = norm_matrix_row(hist_dist);

%hist_dist = exp(-hist_dist/phi_hist_sq);
hist_dist = hist_dist./repmat(max(hist_dist,[],2),[1,size(hist_dist,2)]);
%hist_dist(366,366) = 0;


phi_pos =3;
pos_dist = pdist2(pos{sf}(:,:), pos{tf}(:,:), 'euclidean' );
%pos_dist = double(exp(-pos_dist/phi_pos^2));
pos_dist = pos_dist./repmat(max(pos_dist,[],2),[1,size(pos_dist,2)]);
%pos_dist(pos_dist < 1e-3) = 0;


phi_RGB =3;
RGB_dist = pdist2(rgbhistogram{sf}(:,:), rgbhistogram{tf}(:,:), 'chisq' );
%RGB_dist = double(exp(-RGB_dist/phi_RGB^2));
RGB_dist = RGB_dist./repmat(max(RGB_dist,[],2),[1,size(RGB_dist,2)]);

L_dist = pdist2(L_hist{sf}(:,:), L_hist{tf}(:,:), 'emd' );
%L_dist = L_dist./repmat(max(L_dist,[],2),[1,size(L_dist,2)]);

A_dist = pdist2(A_hist{sf}(:,:), A_hist{tf}(:,:), 'emd' );
%A_dist = A_dist./repmat(max(A_dist,[],2),[1,size(A_dist,2)]);

B_dist = pdist2(B_hist{sf}(:,:), B_hist{tf}(:,:), 'emd' );
%B_dist = B_dist./repmat(max(B_dist,[],2),[1,size(B_dist,2)]);

LAB_dist = L_dist+A_dist+B_dist;
LAB_dist = LAB_dist./repmat(max(LAB_dist,[],2),[1,size(LAB_dist,2)]);
%visdistance(spp,pos_dist(100,:));
%visdistance(spp,RGB_dist(10,:));
%visdistance(spp,LAB_dist(10,:));
%visdistance(sp(:,:,1),hist_dist(370,:));


final_dist = log(LAB_dist + pos_dist);
final_dist2 = log(hist_dist+ LAB_dist + pos_dist);
%final_dist =final_dist./repmat(sum(final_dist,2),[1,size(final_dist,2)]);


%visgeodistance(sp(:,:,1),graph{1},10 );
%visdistance(spp,final_dist(ch,:));
bs
toc;
%k = diag(ones(1,splist(1)));
%k=1-k;
%final_dist = final_dist.*k;

