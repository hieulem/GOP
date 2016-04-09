function [Y,R,E]=Laplacian(D,n_fcn,n_size,options)
%D is the distance matrix
%The function may be tested on toy cases (Testtoycase.m)

%required files: components.m, jdqz.m



%Parameters

if ( (~exist('options','var')) || (~isstruct(options)) )
    options=struct();
end

if (~isfield(options,'useoneminus'))
    useoneminus=true;
else
    useoneminus=options.useoneminus;
end
if (~isfield(options,'dims'))
    no_dims=6;
else
    no_dims=options.dims;
end
if (~isfield(options,'display'))
    printonscreen=false;
else
    printonscreen=options.display;
end
if (~isfield(options,'verbose'))
    printthetext=false;
else
    printthetext=options.verbose;
end
if (~isfield(options,'overlay'))
    overlay=true;
else
    overlay=options.overlay;
end
if (~isfield(options,'sigma'))
    sigma=1;
else
    sigma=options.sigma;
end

if (~isfield(options,'eig_impl'))
    eig_impl='matlab'; %'JDQR'
else
    eig_impl=options.eig_impl;
end

if ( (~exist('n_size','var')) || (isempty(n_size)) )
    n_size=0; %keep n_size neighbours at maximum or threshold for 'epsilon'
end
if ( (~exist('n_fcn','var')) || (isempty(n_fcn)) )
    n_fcn='k'; %comparing function 'k' or 'epsilon'
end


G = double(D);


N = size(D,1); 
minimum_conn=min(full(sum(G'>0)));
if ( (strcmp(n_fcn,'k')) && (minimum_conn<n_size) )
    fprintf('Minimum connectivity %d, n_size %d\n',minimum_conn,n_size);
end
if issparse(G)
     if (strcmp(n_fcn,'k'))
         if (n_size~=0)
             fprintf('n_size %d specified for connectivity (this includes self-connectivity)\n',n_size);
             makesymmetric=true;
             gisdistance=true;
             G = Selectkneighbours(G,n_size,N,printthetext,makesymmetric,gisdistance);
         else %when n_size==0 G does not have to be changed
             G = max(G,G');    %% Make sure distance matrix is symmetric
         end
     elseif (strcmp(n_fcn,'epsilon'))
         G =  G.*(G<=n_size); 
         G = max(G,G');    %% Make sure distance matrix is symmetric
     else
         G = max(G,G');    %% Make sure distance matrix is symmetric
     end
else
     if (strcmp(n_fcn,'k'))
         fprintf('Non simmetric max connectivity\n');
         [tmp, ind] = sort(G,'ascend'); 
         tic; 
         for i=1:N
             G(i,ind((2+n_size):end,i)) = Inf; 
             if ((printthetext == 1) && (rem(i,50) == 0)) 
                 disp([' Iteration: ' num2str(i) '     Estimated time to completion: ' num2str((N-i)*toc/60/50) ' minutes']); tic; 
             end
         end
     elseif (strcmp(n_fcn,'epsilon'))
         warning off    %% Next line causes an unnecessary warning, so turn it off
         G =  G./(G<=n_size); 
         G = min(G,Inf); 
         warning on
     end
     G = min(G,G');    %% Make sure distance matrix is symmetric
end    



if (~useoneminus)
    G = G .^ 2;
    G = G ./ max(max(G));
end



blocks = components(G)';
count = zeros(1, max(blocks));
for i=1:max(blocks)
    count(i) = length(find(blocks == i));
end
[count, block_no] = max(count);
conn_comp = find(blocks == block_no);
%conn_comp contains the indexes of the embedded components
Y.index=conn_comp;
G = G(conn_comp, conn_comp);

% Compute weights (W = G)
disp('Computing weight matrices...');



if (~useoneminus)
    % Compute Gaussian kernel (heat kernel-based weights)
    G(G ~= 0) = exp(-G(G ~= 0) / (2 * sigma ^ 2));
else
    G=Similaritiesfromd(G,[]);
    forceonediagonal=true;
    G=Forceonediagonal(G,[],forceonediagonal);
end



% Construct diagonal weight matrix
DD = diag(sum(G, 2));

% Compute Laplacian
DDminushalf=sqrt(DD^(-1));
L=speye(size(G,1))-DDminushalf*G*DDminushalf;
if ( (any(isnan(L(:)))) || (any(isnan(DD(:)))) )
    fprintf('Found NaN values in L or DD\n');
    L(isnan(L)) = 0; DD(isnan(DD)) = 0;
    L(isinf(L)) = 0; DD(isinf(DD)) = 0;
end


% Construct eigenmaps (solve Ly = lambda*Dy)
disp('Constructing Eigenmaps...');



%The manifold is learnt for the maximum number of dimensions
%The eigenvectors are extracted according to the maximum number of dimensions
nodims=max(no_dims);
tol = 0;
if strcmp(eig_impl, 'JDQR')
    opts.Disp = 0;
    opts.LSolver = 'bicgstab';
    [mappedX, lambda] = jdqz(L, DD, nodims + 1, tol, opts);			% only need bottom (nodims + 1) eigenvectors
else
    opts.disp = 0;
    opts.isreal = 1;
    opts.issym = 1;
    [mappedX, lambda] = eigs(L, nodims + 1, tol, opts);			% only need bottom (nodims + 1) eigenvectors
    mappedX=DDminushalf*mappedX; %Port eigenvectors to the corresponding from the unnormalized Laplacian
    %eigenspace spanned by DDminushalf*eigenvetors (not piecewise constant)
    %mappedX is no_data_points x (nodims+1)
end

% Sort eigenvectors in ascending order
lambda = diag(lambda);
[lambda, ind] = sort(lambda, 'ascend');
if (printonscreen)
    Init_figure_no(5), plot(lambda,'*');
end
% lambda(2:nodims + 1);



%The corresponding outputs are copied to Y.coords
Y.coords=cell(1,numel(no_dims));
for idim=1:numel(no_dims)
    nodims=no_dims(idim);
        
    mappedXd = mappedX(:,ind(2:nodims + 1));
    
    Y.coords{no_dims==nodims}=mappedXd';
    
    if (printthetext)
        fprintf('Embedded to %d-dimensional manifold\n',nodims);
    end
end
fprintf('Lambda(dim):         ');fprintf(' %10f(%d)',[lambda';0:max(no_dims)]);fprintf('\n');



if issparse(D)
    [a,b,c] = find(D); 
    E = sparse(a,b,ones(size(a)));
else
    E = (~isinf(D));
end

%TODO: compute the residual
R=zeros(1,numel(no_dims));







