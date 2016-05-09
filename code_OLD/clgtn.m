count=0;
siz = size(sp(:,:,1));

offset = 30;
b = squeeze(hist{1}(:,:));
tic;
geo_graph=[];
sp1 = sp(:,:,1);
sp2 = sp(:,:,2);
newsp2=  sp2;
newlable = sp;

for i=1:length(seed{2})
 %   i=randi(size(seed{1},2),1);
  %  subplot(5,6,iii);
  % figure(2)
    mark = sp(:,:,2) *0;
 %   mark(sp(:,:,1)==seed{1}(indexPairs(i,1))) = 1;
    mark(sp(:,:,2)==seed{2}(i)) = 1;
    [t1,t2] = ind2sub(siz,find(mark>0));
    if(length(t1)>1)
        X = mean([t1,t2]);
    else
        X = [t1,t2];
    end;
    minx = max(1,uint32(X(1)-offset));
    miny = max(1,uint32(X(2)-offset));
    maxx = min(siz(1),uint32(X(1)+offset));
    maxy = min(siz(2),uint32(X(2)+offset));
    
    neighbor_set = unique(sp(minx:maxx,miny:maxy,1));

    [ind,s] = findbestMatch(squeeze(hist{2}(i,:)),b(neighbor_set,:));
    %ind = setsp(ind);
    geo_graph(i,neighbor_set(ind)) = s(ind);
    
    newsp2(sp2 == i) = neighbor_set(ind(1));
end
newlable(:,:,2) = newsp2;
im = [newlable(:,:,1),newlable(:,:,2)];
imagesc(im);colormap('jet');
toc;