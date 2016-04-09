function backmap=Mapitback(themap)

nobels=max(themap(:));

backmap=zeros(1,nobels);
for i=1:numel(themap)
    backmap(themap(i))=i;
end