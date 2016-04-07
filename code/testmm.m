 %a= outputs{3};
 %seed = outputs{2}(1)
 a= Z;
 seed = se(2);
 b= geocompute(a,seed);
 [d,t] = sort(b,2,'ascend');
 top = max(d);
 bot = min(d);
 nv = 100;
 ival = (top-bot) / nv;
 k=0;
 for i=1:nv
     k(i) = sum(d<i*ival);
 end
figure(1); plot(k)
dk = k(2:end) - k(1:end-1);
[topt, topdk] =  sort(dk,2,'descend');


 
 
for i=1:10
     subplot(3,4,i,'align')
    prop{i} = find(b< ival*topdk(i));
    spp = sp*0;
    for j=1:length(prop{i})
     
        spp(sp == prop{i}(j))=1;
        
    end
    
    
    image([ I.*uint8(repmat(spp,[1,1,3]))]);
end
