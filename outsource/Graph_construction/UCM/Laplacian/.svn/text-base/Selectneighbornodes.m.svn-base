function W = Selectneighbornodes(W,n_size,n_fcn,printthetext,makesymmetric,wisdistance,neglectdiagonal)
% W is a sparse or non-spsarse distance or similarity matrix
% n_size specifies the maximum number of connectivity for each node. The
% elements on the diagonal, if present, may also be considered.
% makesymmetric==false ensures exactly n_size connections for each node
% makesymmetric==true ensures simmetry but the max connectivity is not
% guaranteed to be n_size

if ( (~exist('neglectdiagonal','var')) || (isempty(neglectdiagonal)) )
    neglectdiagonal = true; %by default the diagonal matrix is not considered
end
if ( (~exist('wisdistance','var')) || (isempty(wisdistance)) )
    wisdistance = false; %by default W is a distance matrix, false indicates affinity
end
if ( (~exist('makesymmetric','var')) || (isempty(makesymmetric)) )
    makesymmetric = true;
end
if ( (~exist('printthetext','var')) || (isempty(printthetext)) )
    printthetext = false;
end



%Do not change W when n_size==0
if (n_size==0)
    return;
end



nnodes = size(W,1);



if (issparse(W))
    if (strcmp(n_fcn,'k'))
        fprintf('n_size %d specified for connectivity (this includes self-connectivity)\n',n_size);
        W = Selectkneighboursnodiagonal(W,n_size,printthetext,makesymmetric,wisdistance,neglectdiagonal);
    elseif (strcmp(n_fcn,'epsilon'))
        
        %Save diagonal and replace it with zeros
        if (neglectdiagonal)
            origdiag= spdiags(W,0);
            W = spdiags(zeros([nnodes,1]),0,W);
        end
        
        %Select neighbors with eps
        if (wisdistance)
            W =  W.*(W<=n_size);
            if (makesymmetric) %However the eps selection should not affect symmetry
                W = max(W,W');
            end
        else
            W =  W.*(W>=n_size);
            if (makesymmetric) %However the eps selection should not affect symmetry
                [W]=Getcombinedsimilaritieswithmethod(W,W','wsum',[],0.5,0.5);
            end
        end
    
        %Restore diagonal values
        if (neglectdiagonal)
            W = spdiags(origdiag,0,W);
        end
    else
        error('Neighbor selection method');
    end
    
else
    %Save diagonal and replace it with zeros
    if (neglectdiagonal)
        origdiag= diag(W,0);
        if (wisdistance)
            W(logical(eye(size(W))))=Inf;
        else
            W(logical(eye(size(W))))=0;
        end
    end
    
    if (strcmp(n_fcn,'k'))
        if (wisdistance) %sorting is done once for all values
            [tmp,ind] = sort(W,'ascend');
            subvalue=Inf;
        else
            [tmp,ind] = sort(W,'descend');
            subvalue=0;
        end
        loctimeid=tic;
        for i=1:nnodes
            W(i,ind((1+n_size):end,i)) = subvalue;
            if ((printthetext == 1) && (rem(i,50) == 0)) 
                disp([' Iteration: ' num2str(i) '     Estimated time to completion: ' num2str( ((nnodes-i)*toc(loctimeid)/i) / 60 ) ' minutes']);
            end
        end
    elseif (strcmp(n_fcn,'epsilon'))
        if (wisdistance) %sorting is done once for all values
            warning off    %% Next line causes an unnecessary warning, so turn it off
            W =  W./(W<=n_size); 
%             W = min(W,Inf); 
            warning on
        else
            W =  W.*(W>=n_size); 
        end
    else
        error('Neighbor selection method');
    end
    if (makesymmetric)
        if (wisdistance)
            W = min(W,W');
        else
            W = max(W,W');
        end
    end
    
    %Restore diagonal values
    if (neglectdiagonal)
        W(logical(eye(size(W))))=origdiag;
    end
end    









