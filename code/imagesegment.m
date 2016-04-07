
for i=1:21
im = I(:,:,:,i);
imshow(im);
th =0.3;
graph = seeds_geo{i};
numsp = size(seeds_geo{i},1);

sm = -ones(1,numsp);
numsp = size(graph,1);


count =0;

ind =1; 

while sum(sm==-1)>0
    count = count +1;
    ind = find(sm==-1,1);
    seg =[];
    while numel(ind)>numel(seg)
        seg = unique([seg,ind]);
        cur = min(graph(seg,:),[],1);
        ind = find(cur<th);
    end
    
    sm(seg) =  count;
   
end

im2 = convertspmap(sp(:,:,i),[[1:numsp]',sm']);
im3 = gen_cl_one_fr(im2);
    
imagesc(uint8 (im3));
pause 
end;