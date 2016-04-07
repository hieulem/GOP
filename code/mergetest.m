num=1;
Im=I(:,:,:,num);
figure(1); imshow(Im);
spn = sp(:,:,num);
%D = pdist2( hist{1}(:,:), hist{1}(:,:), 'chisq' );
%D4 = pdist2(rgbhistogram{1}, rgbhistogram{1},'chisq');
geo = seeds_geo{1}(:,:);
geo2 = sort(geo,2);
geo2(:,1) = [];
grad_geo = geo2(:,2:end) - geo2(:,1:end-1);
[aa,ind] = findpeaks(grad_geo(1,:),'MinPeakWidth',mean(mean(E)));
figure(2)
%E2= E(E>0.001);
%th=0.1
%th= 0.2
nsp =splist(num);
mark = zeros(1,nsp);
l = 1:nsp;
www=[];
for i=1:nsp
    if mark(i) == 0
        g = geo(i,:);
        [t,ind] = sort(g,'ascend');
        w1 = area{2};
        area_over_t = cumsum(w1(ind));
        t_grad = t(2:end) - t(1:end-1);
        peak = find(t_grad ==0);
        th = t(peak(1));
        
       % area_over_t_grad = area_over_t(2:end) - area_over_t(1:end-1);
        
        www= [www,th];
        set = (g<th);
        setl = l(set);
        ind= randi(length(setl),[1,1]);
        newl = setl(ind);
        l=convertspmap(l,[setl',ones(length(setl),1)]);
        mark(l) =1;
    end
end
map{1} = l;
sp2 = convertspmap(spn,[[1:nsp]',l']);
n=numel(unique(sp2))
convertspmap(sp2,[unique(sp2)',randperm(n)']);

imagesc(sp2);colormap('jet');

