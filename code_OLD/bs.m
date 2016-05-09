addpath(genpath('../outsource/toolbox-master'));
addpath(genpath('../outsource/spDetect'));

ch = 395;
%ch=401
%ch = 250
%ch = 400
%ch= 242
sf =5;
tf = 6;
for ch=270:1:400



phi_hist_sq = 0.4;

hist_dist = pdist2(geo_hist{sf}(:,:), geo_hist{tf}(:,:), 'chisq' );
hist_dist2 = pdist2(geo_hist{sf}(:,:), geo_hist{sf}(:,:), 'emd' );
hist_dist = exp(-hist_dist/0.2);phi_pos =3;
pos_dist = pdist2(pos{sf}(:,:), pos{tf}(:,:), 'euclidean' )/10;
pos_dist = double(exp(-pos_dist/10));

phi_pos =3;
%pos_dist = pdist2(pos{sf}(:,:), pos{tf}(:,:), 'euclide an' );
%pos_dist = double(exp(-pos_dist/phi_pos^2));

fi = hist_dist.*pos_dist;

[k,i] = max(hist_dist(ch,:))
[k2,i2] = max(fi(ch,:))
figure(1);imshow([visseeds(I(:,:,:,sf),sp(:,:,sf),ch ),visseeds(I(:,:,:,tf),sp(:,:,tf),[i] ),visseeds(I(:,:,:,tf),sp(:,:,tf),[i2] )]);
title([num2str(k),'___',num2str(k2)]);
%figure(2);imshow(visseeds(I(:,:,:,tf),sp(:,:,tf),[i,i2] ));
figure(3);visdistance(sp(:,:,tf),hist_dist(ch,:));
figure(4);visdistance(sp(:,:,tf),fi(ch,:));
pause(2)
end;
%figure(4);visdistance(sp(:,:,1),seeds_geo{tf}(i,:));




%figure(5);visgeodistance(sp(:,:,2),graph{sf},ch );
%figure(1);visseeds(I(:,:,:,2),sp(:,:,2),ch );
%figure(3);visdistance(spp,final_dist(ch,:)); 

%visdistance(spp,LAB_dist(ch,:));
%visdistance(spp,LAB_dist(ch,:));
%visdistance(spp,RGB_dist(ch,:));
%visdistance(spp,pos_dist(ch,:));
%visdistance(spp,hist_dist(ch,:));

%figure(5);visgeodistance(sp(:,:,1),graph{tf},i );
%figure(6);visgeodistance(sp(:,:,2),graph{sf},ch );