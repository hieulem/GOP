labelled_level_video = sp;
numfr = inp.numi;
splist = splist(1:numfr);
cumspn = [0,cumsum(splist)];
t= max(splist);
mapped = zeros(length(splist),t);

numsp = cumspn(end);

for i=1:numfr
    mapped(i,1:splist(i)) = [1:splist(i)] +cumspn(i);
end
flows = cell(1,numfr);

for i=1:numfr
    flows{i}.Up = squeeze(flow(:,:,1,i));
    flows{i}.Vp = squeeze(flow(:,:,2,i));
end

affinity_matrix = sparse(zeros(numsp,numsp));

for i=1:numfr-1
    i
    hist_dist_o = pdist2(geo_hist2d{i},geo_hist2d{i+1},'chisq2d');
    hist_dist_n = exp(-hist_dist_o/0.05);
    affinity_matrix((cumspn(i)+1) : cumspn(i+1),(cumspn(i+1)+1) : cumspn(i+2)) = hist_dist_n;
    affinity_matrix((cumspn(i+1)+1) : cumspn(i+2),(cumspn(i)+1) : cumspn(i+1)) = hist_dist_n';
end