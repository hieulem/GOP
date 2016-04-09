function D=Dfromsimilarities(similarities,usesparse)
%Inverse of Similaritiesfromd

if ( (~exist('usesparse','var')) || (isempty(usesparse)) )
    usesparse=issparse(similarities);
end

if (issparse(similarities))
    if (~usesparse)
        similarities=full(similarities);
        fprintf('Requested non-sparse matrix but matrix was sparse, input is converted\n');
    end
else
    if (usesparse)
        similarities=sparse(similarities);
        fprintf('Requested sparse matrix but matrix was not sparse, input is converted\n');
    end
end

zerosparsevalue=0.0000001;

if (usesparse)
    sizesim=size(similarities);
    [r,c,v]=find(similarities);
    % similarities2=sparse(r, c, v, sizesim(1), sizesim(2));
    % isequal(similarities, similarities2)
    
    %Previous conversion (everything is converted faithfully apart for
    %values 1, to which zerosparsevalue is assigned in conversion: values
    %bigger than 1-zerosparsevalue may be converted to values smaller than
    %the corresponding to 1 values, converted to zerosparsevalue)
%     v(v==1)=1-zerosparsevalue;
%     D=sparse(r, c, (1-v), sizesim(1), sizesim(2));
    
    %New conversion (values bigger than 1-zerosparsevalue are first
    %transformed to zerosparsevalue and then converted - all values bigger
    %than 1-zerosparsevalue are thus thresholded)
    D=sparse(r, c, max( (1-v) ,zerosparsevalue), sizesim(1), sizesim(2));
%     D=sparse(r, c, max( exp(-v) ,zerosparsevalue), sizesim(1), sizesim(2));
%     D=sparse(r, c, max( 1./(1+exp(v)) ,zerosparsevalue), sizesim(1), sizesim(2));
else
    D=1-similarities;
    D(similarities==0)=Inf;
end



function Compare_d_dbis(D,D2) %#ok<DEFNU>

isequal(D,D2)

isequal(full(D)>0,full(D2)>0)

max(max(abs(full(D)-full(D2))))

numel(find(abs(full(D)-full(D2))))

max(max((full(D)-full(D2))))
max(max((full(D2)-full(D))))

isequal(full(D),full(D2))

adiff=find(abs(full(D)-full(D2)),100,'first');
DD=full(D);
DD2=full(D2);
SIM=full(similarities);

fprintf('%.20f %.20f %.20f\n',[DD(adiff),DD2(adiff),SIM(adiff)]');



function D=Dfromsimilarities_backup_opt(similarities,usesparse) %#ok<DEFNU>

if ( (~exist('usesparse','var')) || (isempty(usesparse)) )
    usesparse=issparse(similarities);
end

if (issparse(similarities))
    if (~usesparse)
        similarities=full(similarities);
        fprintf('Requested non-sparse matrix but matrix was sparse, input is converted\n');
    end
else
    if (usesparse)
        similarities=sparse(similarities);
        fprintf('Requested sparse matrix but matrix was not sparse, input is converted\n');
    end
end

zerosparsevalue=0.0000001;

if (usesparse)
    D=similarities;
    r=find(D);
    D(r)=1-D(r);
    % D(r)=exp(-D(r));
    % D(r)=1./(1+exp(D(r)));
    D(similarities==1)=zerosparsevalue;
else
    D=1-similarities;
    D(similarities==0)=Inf;
end

