function [label,m,residualerror] = Litekmeans_one_iteration(X, k, multiplicity, seed)
% Perform k-means clustering.
%   X: d x n data matrix
%   k: number of seeds
% Written by Michael Chen (sth4nth@gmail.com).
%
% multiplicity allows or considering a point several times, as for the
% point to represent a previous grouping



MAXOPTSTEPS=1000;



%Compute n of points
n = size(X,2);
%Assign initial cluster assignments randomly
label = ceil(k*rand(1,n));  % random initialization, numel(unique(label))
%Seed the initial assignments if defined (seed > 0 means that the seed is defined)
label(seed>0)=seed(seed>0);



last = 0;
count=0;
while ( (any(label ~= last)) && (count<MAXOPTSTEPS) )
    [u,~,label] = unique(label);   % remove empty clusters
    k = length(u);
    
    E = sparse(1:n,label,multiplicity,n,k,n);  % Transform label into indicator matrix
    %multiplicity is 1 in the original code as for each point being weighted 1
    
    m = X*(E*spdiags(1./sum(E,1)',0,k,k));    % compute m of each cluster
    last = label';

    [~,label] = max(bsxfun(@minus,m'*X,dot(m,m,1)'/2),[],1); % assign samples to the nearest centers

    count=count+1;
    
%     residualerror= sum(     sqrt(   sum(  (X - m(:,label) )  .^2  ,1  )   )     ); disp(residualerror)
end

%Compute residual error to select best random initialization
residualerror= sum(     sqrt(   sum(  (X - m(:,label) )  .^2  ,1  )   )     );
% fprintf('Countoptsteps = %d, residualerror=%f\n',count,residualerror);

%Compact the labels and arrange the cluster centers accordingly
[ulabels,~,label] = unique(label); % [C,ia,ic] = unique(A), C = A(ia) and A = C(ic)
m=m(:,ulabels);











function test_this() %#ok<DEFNU>

size(ulabels)
min(ulabels)
max(ulabels)
size(label)
min(label)
max(label)
size(u)
min(u)
max(u)

size(m(:,label))
size(m)

size(X)

size(C)
size(IDX)

