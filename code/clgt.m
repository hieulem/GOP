count=0;figure(7);
siz = size(sp(:,:,1));
colormap('bone');
offset = 30;
a= [squeeze(hist{1}(:,:))];%,squeeze(seeds_color{2}(:,:))];
b= [squeeze(hist{2}(:,:))];%,squeeze(seeds_color{2}(:,:))];
%b = squeeze(hist{2}(:,:));
tic;
geo_graph=[];
ww =[];
D = pdist2( a, b, ['chisq'] );
D2 = pdist2( seeds_color{1}(:,:), seeds_color{2}(:,:), 'sqeuclidean' );
%[s,ind] = min(D,[],2);
D=D+D2;

for i=1:min(12,length(seed{1}))
    i=randi(size(seed{1},2),1);
    subplot(3,4,iii);
  % figure(2)
    mark = sp(:,:,1) *0;
    mark2 = repmat(mark,[1,1,3]);
    mark(sp(:,:,1)==seed{1}(i)) = 1;
    [t1,t2] = ind2sub(siz,find(mark>0));
    if(length(t1)>1)
        X = mean([t1,t2]);
    else
        X = [t1,t2];
    end;
    mark2(:,:,1) = mark*200;
    I1 = uint8(I(:,:,:,1)  + uint8(mark2)); 
    
    minx = max(1,uint32(X(1)-offset));
    miny = max(1,uint32(X(2)-offset));
    maxx = min(siz(1),uint32(X(1)+offset));
    maxy = min(siz(2),uint32(X(2)+offset));
    
  %  setsp = 1:nsp;%
    setsp =unique(sp(minx:maxx,miny:maxy,2));
  
   % setsp = seed{2}(IDX);
   % [ind,score] = findbestMatch([squeeze(hist{1}(i,:)),squeeze(seeds_color{1}(i,:))],b(setsp,:));
   %  [ind,score] = findbestMatch([squeeze(hist{1}(i,:))],b(setsp,:));
    [score,ind] = min(D(i,setsp));
    ww= [ww,score(1)];
    ind = setsp(ind);
    mark = sp(:,:,2) *0;
    mark2 = repmat(mark,[1,1,3]);
    
    mark(sp(:,:,2)==seed{2}(ind(1))) = 1;
    mark2(:,:,1) = mark*200;
    
    I2 = uint8(I(:,:,:,2) + uint8(mark2)); 
    [t3,t4] = ind2sub(siz,find(mark>0));
    if(length(t3)>1)
        Y = mean([t3,t4]);
    else
        Y = [t3,t4];
    end;
    imagesc([I1,I2]);hold on;
    line([X(2),Y(2)+siz(2)-1],[X(1),Y(1)],...
        'LineWidth',1,...
        'Color',[.8 .8 .8]);
end
toc;