count=0;figure(7);
siz = size(sp(:,:,1));
colormap('bone');
offset = 5;
a= squeeze(hist{1}(:,:));%,squeeze(seeds_color{2}(:,:))];
b= squeeze(hist{2}(:,:));%,squeeze(seeds_color{2}(:,:))];
%b = squeeze(hist{2}(:,:));
tic;
geo_graph=[];
ww =[];
D=final_dist2;
key = get(gcf,'CurrentKey');
count =0;
while ~strcmp (key , 'return')
    imagesc([I(:,:,:,1),I(:,:,:,2)]);hold on;
    
    for ii=1:30
        i=count+ii;
        %   subplot(3,4,iii);
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
        %   mark2(:,:,1) = mark*200;
        %   I1 = uint8(I(:,:,:,1)  + uint8(mark2));
        
        minx = max(1,uint32(X(1)-offset));
        miny = max(1,uint32(X(2)-offset));
        maxx = min(siz(1),uint32(X(1)+offset));
        maxy = min(siz(2),uint32(X(2)+offset));

        setsp =unique(sp(minx:maxx,miny:maxy,2));

        [score,ind] = min(D(i,setsp));
        ww= [ww,score(1)];
        ind = setsp(ind);

        line([pos{1}(i,2),pos{2}(ind(1),2)+siz(2)-1],[pos{1}(i,1),pos{2}(ind(1),1)],...
            'LineWidth',1,...
            'Color','r');
    end
    toc;
    count = count+30;
    key = get(gcf,'CurrentKey');
    hold off;
    pause
end