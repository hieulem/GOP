addpath(genpath('../outsource/toolbox-master'));
addpath(genpath('../outsource/spDetect'));

%ch=401
%ch = 250
%ch = 400
%ch= 242
sf =1;
tf = 3;
x = -1;
figure(5);imagesc([edge(:,:,sf),edge(:,:,tf)]);
figure(1);imshow(uint8(I(:,:,:,sf)));
%I= uint8(I);
%sp = uint8(sp);
for i=1:30

figure(1);
[x,y] = ginput(1);
p = pdist2([y,x],pos{sf},'euclidean');
[~,ch] = min(p);


phi_hist_sq = 0.4;

%hist_dist = pdist2(geo_hist{sf}(:,:), geo_hist{tf}(:,:), 'chisq' );
hist_dist = pdist2(geo_hist2d{sf}(:,:,:),geo_hist2d{tf}(:,:,:),'chisq2d');

hist_dist = exp(-hist_dist);phi_pos =3;


hist_dist2 = pdist2(geo_hist{sf}(:,:), geo_hist{tf}(:,:), 'emd' );
hist_dist2 = exp(-hist_dist2);

pos_dist = pdist2(pos{sf}(:,:), pos{tf}(:,:), 'euclidean' )/10;
pos_dist = double(exp(-1/100*pos_dist));
% all_dist = pop_dist_all(geo_hist{sf},pos{sf},L_hist{sf},A_hist{sf},B_hist{sf},...
%                         H_hist{sf},S_hist{sf},V_hist{sf},...
%     geo_hist{tf},pos{tf},L_hist{tf},A_hist{tf},B_hist{tf},H_hist{tf},...,
%     S_hist{tf},V_hist{tf});
phi_pos =3;
%pos_dist = pdist2(pos{sf}(:,:), pos{tf}(:,:), 'euclide an' );
%pos_dist = double(exp(-pos_dist/phi_pos^2));

fi = hist_dist2;

[k,i] = max(hist_dist(ch,:))
[k2,i2] = max(fi(ch,:))
figure(2);imshow([visseeds(I(:,:,:,sf),sp(:,:,sf),ch ),visseeds(I(:,:,:,tf),sp(:,:,tf),[i] ),visseeds(I(:,:,:,tf),sp(:,:,tf),[i2] )],[600,1200]);set(figure(2), 'Position', [100, 100, 1000, 300]);

title([num2str(k),'___',num2str(k2)]);
%figure(2);imshow(visseeds(I(:,:,:,tf),sp(:,:,tf),[i,i2] ));
figure(3);visdistance(sp(:,:,tf),hist_dist(ch,:));
figure(4);visdistance(sp(:,:,tf),fi(ch,:));

%figure(6);imagesc(squeeze(geo_hist2d{sf}(ch,:,:)));
%figure(7);imagesc(squeeze(geo_hist2d{tf}(i,:,:)));
%figure(7);bar( geo_hist{tf}(i,:));


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