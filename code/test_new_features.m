
k= 1;
md2i = cell(input.numi,1);
seti=unique(seeds_color{1});
tic;
for i=1:input.numi
    seti = unique([unique(seeds_color{i});seti]);
end
maxs = 100;
for k=1:input.numi
    md2i{k}= zeros(splist(k),numel(seti));
    for i=1:splist(k)
        for j =1:numel(seti)
            ls = find(seeds_color{k} == seti(j));
            if ~isempty(ls)
                md2i{k}(i,j) = min(seeds_geo{k}(i,(seeds_color{k} == seti(j))));
            end
        end 
    end
    md2i{k} = (md2i{k}-repmat(mean(md2i{k},2),[1,numel(seti)]));
end
toc;

