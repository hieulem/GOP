function [ii,jj,vv]=Reducenewquivwithhein(ii,jj,vv,labelcount)

newsizemax=max( max(ii(:)),max(jj(:)) );
newsize=numel(labelcount);
if (newsize<newsizemax)
    error('New sizes to be checked');
end


sparsesimnew=sparse(ii,jj,vv,newsize,newsize); % max(ii), max(jj), size(twreducedsimilarities), disp(full(sparsesimnew))



USEMEX=true;
if (USEMEX)
    [internallabelvolume,semilabelvolume]=Reducenewwithheinmex(ii,jj,vv,newsize);
else
    internallabelvolume=zeros(newsize,1);
    semilabelvolume=zeros(newsize,1);
    
    for k=1:numel(ii)
        if (ii(k)==jj(k))
            internallabelvolume(ii(k)) = internallabelvolume(ii(k)) + vv(k);
        else
            semilabelvolume(ii(k)) = semilabelvolume(ii(k)) + vv(k);
        end
    end
end



internalvolumecheck=spdiags(sparsesimnew,0);
if (~isequal(internallabelvolume,internalvolumecheck)), fprintf('\n\nDifference in internal volume\n\n\n'); end



%Combine volume and reweight diagonal matrix
internallabelvolume=internallabelvolume./labelcount;
semilabelvolume=semilabelvolume .* (labelcount-1) ./ labelcount;

newdiag= internallabelvolume - semilabelvolume;



sparsesimnew=spdiags(newdiag,0,sparsesimnew);



[ii,jj,vv]=find(sparsesimnew); % size(sparsesimnew,1)
