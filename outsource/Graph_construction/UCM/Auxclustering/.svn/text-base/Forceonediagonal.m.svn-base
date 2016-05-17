function similarities=Forceonediagonal(similarities,usesparse,forceonediagonal)

if ( (~exist('forceonediagonal','var')) || (isempty(forceonediagonal)) )
    forceonediagonal=true;
end
if ( (~exist('usesparse','var')) || (isempty(usesparse)) )
    usesparse=issparse(similarities);
end

if (issparse(similarities))
    if (~usesparse)
        similarities=full(similarities);
        fprintf('Forceonediagonal: Requested non-sparse matrix but matrix was sparse, input is converted\n');
    end
else
    if (usesparse)
        similarities=sparse(similarities);
        fprintf('Forceonediagonal: Requested sparse matrix but matrix was not sparse, input is converted\n');
    end
end

onesparsevalue=1;

if (forceonediagonal)
    if (usesparse)
        similarities(logical(speye(size(similarities,1))))=onesparsevalue;
    else
        similarities(logical(eye(size(similarities,1))))=1;
    end
end
