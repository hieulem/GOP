Init_w = gready_choose(Unary);

input.numi=2
for ii=2:input.numi
    dist = pop_pair_wise_potentials(ii-1,ii,geo_hist,pos,L_hist,A_hist,B_hist);
    [~,map{ii}] = max(dist,[],1);
end

sp2= sp;
for i=input.numi:-1:2
    s=sp2(:,:,i);
    for j=i:-1:2
        s = convertspmap(s,1:splist(j),map{j});
    end
    sp2(:,:,i) = s;
end

%sp2(:,:,1) = convertspmap(sp2(:,:,1),1:splist(1),map{1});


gen_color;
