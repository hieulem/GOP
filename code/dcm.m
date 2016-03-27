count=0;figure(6);
siz = size(sp(:,:,1));
colormap('bone')
tic;
for i=1:min(42,size(indexPairs,1))
    
    subplot(6,7,i);
  % figure(2)
    mark = sp(:,:,1) *0;
    mark(sp(:,:,1)==seed{1}(indexPairs(i,1))) = 1;
    [t1,t2] = ind2sub(siz,find(mark>0));
    if(length(t1)>1)
        X = mean([t1,t2]);
    else
        X = [t1,t2];
    end;
    I1 = (uint8(mean(I(:,:,:,1),3)/1.5 + double(mark)*100)); 
   % count=count+1;
   % subplot(5,8,count);
    mark = sp(:,:,2) *0;
    mark(sp(:,:,2)==seed{2}(indexPairs(i,2))) = 1;
    I2 = (uint8(mean(I(:,:,:,2),3)/1.5 + double(mark)*100)); 
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