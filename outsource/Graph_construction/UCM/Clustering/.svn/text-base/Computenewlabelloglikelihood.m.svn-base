function loglikelihood=Computenewlabelloglikelihood(labels,P,T)

nolabels=max(labels);

loglikelihood=0;
for i=1:nolabels
    li=find(labels==i);
    
    
    [r,c]=find(T(li,li));
    re=r(r<c);
    ce=c(r<c);
    if ( ~(isempty(re)||isempty(ce)) )
        loglikelihood=loglikelihood+sum(log(  P( sub2ind(size(P),li(re),reshape(li(ce),size(li(re)))) )  ));
    end
    
    
    for j=i+1:nolabels
        lj=find(labels==j);
        [r,c]=find(T(li,lj));
        if ( ~(isempty(r)||isempty(c)) )
            loglikelihood=loglikelihood+sum(log(  1-P( sub2ind(size(P),li(r),reshape(lj(c),size(li(r)))) )  ));
        end
    end
end
