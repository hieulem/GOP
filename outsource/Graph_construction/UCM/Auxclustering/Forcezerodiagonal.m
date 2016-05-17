function D=Forcezerodiagonal(D,usesparse,forcezerodiagonal)

if ( (~exist('forcezerodiagonal','var')) || (isempty(forcezerodiagonal)) )
    forcezerodiagonal=true;
end
if ( (~exist('usesparse','var')) || (isempty(usesparse)) )
    usesparse=issparse(D);
end

if (issparse(D))
    if (~usesparse)
        D=full(D);
        fprintf('Forcezerodiagonal: Requested non-sparse matrix but matrix was sparse, input is converted\n');
    end
else
    if (usesparse)
        D=sparse(D);
        fprintf('Forcezerodiagonal: Requested sparse matrix but matrix was not sparse, input is converted\n');
    end
end

zerosparsevalue=0.0000001;

if (forcezerodiagonal)
    if (usesparse)
        D(logical(speye(size(D,1))))=zerosparsevalue;
    else
        D(logical(eye(size(D,1))))=0;
    end
end
