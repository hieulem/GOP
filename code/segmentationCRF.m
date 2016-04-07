addpath(genpath('../outsource/toolbox-master'));
addpath(genpath('../outsource/spDetect'));

%close all
frame1 =6;
frame2 = 1;
im = I(:,:,:,frame1);
figure();
imshow(im);
spi = sp(:,:,frame1);
nsp = splist(frame1);


num_label = splist(frame1);
dist_matrix2 = pop_dist_all(geo_hist{frame1},pos{frame1},L_hist{frame1},A_hist{frame1},B_hist{frame1},...
    H_hist{frame1},S_hist{frame1},V_hist{frame1},...
    geo_hist{frame1},pos{frame1},L_hist{frame1},A_hist{frame1},B_hist{frame1},H_hist{frame1},S_hist{frame1},V_hist{frame1});
neighbor = sparse(pop_adjacent_matrix(spi));

dist_matrix = pop_dist2(geo_hist{frame1},L_hist{frame1},A_hist{frame1},B_hist{frame1},...
   geo_hist{frame1},L_hist{frame1},A_hist{frame1},B_hist{frame1});
%dist_matrix = -seeds_geo{frame};


th =0.05;
[a,b,t] = extract_seeds_under_th(dist_matrix,th,80);
a
visseeds(im,spi,a);
[~,m] = max(dist_matrix(a,:),[],1);

for i=1:nsp
    spi(spi == i) = m(i);
end

kk = gen_cl_from_spmap(spi,[]);
imshow(uint8(kk));



