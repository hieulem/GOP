fr1= 1;
fr2 = 7;
se1=20;
se2 = 150;

a1=seeds_geo{fr1}(se1,:);
[~,i] =sort(a1);

b= cumsum(area{fr1}(i));
figure(1);
d=plot(a1(i),b);hold on;

a2=seeds_geo{fr2}(se2,:);
[~,i] =sort(a2);

b2= cumsum(area{fr2}(i));
d=plot(a2(i),b2);
hold off;
figure(2);
im1 = visseeds(I(:,:,:,fr1),sp(:,:,fr1),[se1]);
im2 = visseeds(I(:,:,:,fr2),sp(:,:,fr2),[se2]);
imshow([im1,im2]);

aa= unique(round(a1,3));
for i=1:length(aa)
    bb(i) = sum(area{fr1}(a1<=aa(i)));
end
%figure(3);
% cc = bb(2:end)./aa(2:end);
% 
% [~,i] = max(cc)
aa(i)
figure(4)
for j=0:0.001:2
imshow( visseeds(I(:,:,:,fr1),sp(:,:,fr1),find(a1<j)));
pause(0.001);
end;