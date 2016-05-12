clear;
load('meta');
load('pos');
a1 = load('1d_g0_f0')
a2 = load('1d_g50_f0')
a3 = load('2d_g50_f0')
a4 = load('2d_g50_3_3')

i1 = a1.affinity_matrix(1:splist(1),1:splist(1));
o1 = a1.affinity_matrix(1:splist(1),(splist(1)+1):(splist(1)+splist(2)));
i2 = a2.affinity_matrix(1:splist(1),1:splist(1));
o2 = a2.affinity_matrix(1:splist(1),(splist(1)+1):(splist(1)+splist(2)));
i3 = a3.affinity_matrix(1:splist(1),1:splist(1));
o3 = a3.affinity_matrix(1:splist(1),(splist(1)+1):(splist(1)+splist(2)));
i4 = a4.affinity_matrix(1:splist(1),1:splist(1));
o4 = a4.affinity_matrix(1:splist(1),(splist(1)+1):(splist(1)+splist(2)));


figure(5); imshow(img(:,:,:,2));
%save([options.type,num2str(options.useSpatialGrid)]);
display('done');
while true
    figure(2);imshow(img(:,:,:,1));
   [x,y] = ginput(1);
    p = mypdist2([y,x],ppos{1},'euclidean');
    [~,ch] = min(p)
 %   ch = 593;
    figure(3);imshow(visseeds(img(:,:,:,1),sp(:,:,1),ch));
    
    g1 = o1(ch,:);
    g2 = o2(ch,:);
    g3 = o3(ch,:);
    g4 = o4(ch,:);
    figure(4);
    imagesc([visdistance(sp(:,:,2),g1),visdistance(sp(:,:,2),g2)]);
     figure(5);
    imagesc([visdistance(sp(:,:,2),g3),visdistance(sp(:,:,2),g4)]);
    
    gg1 = i1(ch,:);
    gg2 = i2(ch,:);
    gg3 = i3(ch,:);
    gg4 = i4(ch,:);
    
    figure(6);
    imagesc([visdistance(sp(:,:,1),gg1),visdistance(sp(:,:,1),gg2)]);
     figure(7);
    imagesc([visdistance(sp(:,:,1),gg3),visdistance(sp(:,:,1),gg4)]);
    
    
end