function[sp] = applymap(sp,splist,map)
all=double([0,cumsum(splist)]);
numf = size(sp,3);
for i=2:numf
    i;
    map{i}(:,1) = map{i}(:,1) +all(i);
    map{i}(:,2) = map{i}(:,2) + all(i-1);
    sp(:,:,i) = sp(:,:,i) +all(i);
    map{i} = convertmap2map(map{i},map{i-1});
end

for i=1:numf
    
    sp(:,:,i) = convertspmap(sp(:,:,i),map{i}) ;

end

end