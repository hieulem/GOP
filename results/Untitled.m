numfr = size(allthesegmentations{1});
c = zeros(36,1);
for i=1:36
    a(i) = length(unique(allthesegmentations{i}));
    lesv = zeros(1,a(i));
    for j=1:numfr(end)
        b = unique(allthesegmentations{i}(:,:,j));
        lesv(b) = lesv(b)+1;
    end
    c(i) = sum(lesv)/a(i);
end;

c