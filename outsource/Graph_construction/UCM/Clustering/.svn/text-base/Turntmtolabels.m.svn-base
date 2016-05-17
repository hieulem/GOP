function labels=Turntmtolabels(Tm)

noregions=size(Tm,1);

labels=1:noregions;

[r,c]=find(Tm&(~logical(eye(noregions))));

for i=1:numel(r)
    if (r(i)>c(i))
        continue;
    end
    
    if (Tm(r(i),c(i)))
        if (labels(r(i))~=labels(c(i)))
            lmin=min(labels(r(i)),labels(c(i)));
            lmax=max(labels(r(i)),labels(c(i)));
            labels( labels==lmax )=lmin;
            labels( labels > lmax )=labels( labels > lmax )-1;
        end
    end
    
end

