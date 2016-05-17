function similarities=Similaritiesfromd(D,usesparse)
%Inverse of Dfromsimilarities

if ( (~exist('usesparse','var')) || (isempty(usesparse)) )
    usesparse=issparse(D);
end

if (issparse(D))
    if (~usesparse)
        D=full(D);
        fprintf('Requested non-sparse matrix but matrix was sparse, input is converted\n');
    end
else
    if (usesparse)
        D=sparse(D);
        fprintf('Requested sparse matrix but matrix was not sparse, input is converted\n');
    end
end

zerosparsevalue=0.0000001;

%We allow distances to be larger than 1, in this case the max corresponds to zerosparsevalue distance

if (usesparse)
    %Convert distance by using the found values
    sized=size(D);
    [r,c,v]=find(D);

    maxd=max(1,max(v(~isinf(v))));

    %Convert the values
    newv=max( (maxd-v) ,zerosparsevalue);
    %Alternative convertions
%     newv=max( exp(-v) ,zerosparsevalue);
%     newv=max( 1./(1+exp(v)) ,zerosparsevalue);
    
    newv(isinf(v))=0; %Assign 0 only to Inf distances, all other large distances are assigned zerosparsevalue
    
    %Create the sparse similarities matrix
    similarities=sparse(r, c, newv, sized(1), sized(2));
    
else
    maxd=max(1,max(D(:)));
    
    similarities=maxd-D;
    similarities(isinf(D))=0;
end






function D=test() %#ok<DEFNU>

aadist=[1,0,0.5,0.000000001;1,0.5,0.99999999,Inf]; %Backup version provides the same results for [1,0,0.5,0.000000001;1,0.5,0.99999,Inf]
disp(aadist)

aadistsparse=sparse(aadist);

aasimsparse=Similaritiesfromd(aadistsparse);
% aasimsparse2=Similaritiesfromd_backup_indexing(aadistsparse); disp(isequal(aasimsparse,aasimsparse2)); disp(find(aasimsparse-aasimsparse2));
disp(full(aasimsparse));

aadistsparser=Dfromsimilarities(aasimsparse);

aadistsparserf=full(aadistsparser);

disp(aadistsparserf)


