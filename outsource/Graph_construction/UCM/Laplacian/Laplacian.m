function [Y,R,E]=Laplacian(D,n_fcn,n_size,options)
%D is the distance matrix
%The function may be tested on toy cases (Testtoycase.m)

%required files: components.m, jdqz.m



%Parameters
usenormalisedlaplacian=true; %choice between L=D-w and L= 1 - D^(1/2) W D^(1/2)
multipledminushalftimeseigenvectors=true; %eigenvectors=Dminushalf*eigenvectors (eigenvetors from normalized Laplacian are not piecewise constant)
normaliseeachdatapointtounitlength=false; %Normalize each data point to unit length
normaliseeachdatapointtounitlengthafterlambda=false; %Normalize each data point to unit length



if ( (~exist('options','var')) || (~isstruct(options)) )
    options=struct();
end
if ( (~isfield(options,'normalisezeroone')) || (isempty(options.normalisezeroone)) )
    %Normalize each eigenvector to values in [0,1]
    normalisezeroone=false; %true in paper
else
    normalisezeroone=options.normalisezeroone;
end
if ( (~isfield(options,'normalize')) || (isempty(options.normalize)) )
    %Normalize the eigenvectors according to the inverse square root of the eigenvalues
    %so the distance of the mapped points is normalized according to inv lambdas
    normalizewitheigenvalues=false; %true in paper
else
    normalizewitheigenvalues=options.normalize;
end
fprintf('Laplacian: normalisezeroone %d, normalize %d\n',normalisezeroone,normalizewitheigenvalues);

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
%     sigma=1; _value in original function
    sigma=sqrt(0.5*0.1); %a value (0.22361)
%     sigma=sqrt(1/(2*0.1)); _value used by Brox (2.2361)
else
    sigma=options.sigma;
end
% x=[0:0.01:1];
% plot(x,exp(-0.5*x.^2/(2^2)))
% plot(x,exp(-0.5*x.^2/(0.1^2)))
% plot(x,exp(-0.5*x.^2/(0.3^2)))
% plot(x,exp(-0.5*x.^2/(0.22361^2))) _looks like the best (distances bigger than 0.7 are flattened to 0 similarity)
% plot(x,exp(-0.5*x.^2/(0.5^2))) _0.5 and 0.43 put the nearly linear part around 0.5
% plot(x,exp(-0.5*x.^2/(0.43^2))) _keeps 0.5 on 0.5086
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
    %Functions for inverse transformation
%     G=Dfromsimilarities(G,[]);
%     forcezerodiagonal=true;
%     G=Forcezerodiagonal(G,[],forcezerodiagonal);
end



% Construct diagonal weight matrix
DD = diag(sum(G, 2));

% Compute Laplacian
if (usenormalisedlaplacian)
    DDminushalf=sqrt(DD^(-1));
    L=speye(size(G,1))-DDminushalf*G*DDminushalf;
else
    L = DD - G;
end
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
    if (usenormalisedlaplacian)
        [mappedX, lambda] = eigs(L, nodims + 1, tol, opts);			% only need bottom (nodims + 1) eigenvectors
        if (multipledminushalftimeseigenvectors)
            mappedX=DDminushalf*mappedX; %Port eigenvectors to the corresponding from the unnormalized Laplacian
            %Von Luxburg: eigenspace spanned by DDminushalf*eigenvetors (not piecewise constant)
            %[prev:DDminushalf^(-1)*eigenvetors]
        end
    else
        [mappedX, lambda] = eigs(L, DD, nodims + 1, tol, opts);			% only need bottom (nodims + 1) eigenvectors
    end
    %mappedX is no_data_points x (nodims+1)
end

% Sort eigenvectors in ascending order
lambda = diag(lambda);
[lambda, ind] = sort(lambda, 'ascend');
if (printonscreen)
    Init_figure_no(5), plot(lambda,'*');
end
% lambda(2:nodims + 1);



%Normalize all eigenvectors to [0,1]
if (normalisezeroone)
    mappedX= ( mappedX-repmat(min(mappedX,[],1),size(mappedX,1),1) ) ./...
        repmat(max(mappedX,[],1)-min(mappedX,[],1),size(mappedX,1),1) ;
end
    


if (printonscreen)
    minvectors=min(mappedX,[],1);
    fprintf('Min of vectors(dim): ');fprintf(' %10f(%d)',[minvectors;0:max(no_dims)]);fprintf('\n');
    maxvectors=max(mappedX,[],1);
    fprintf('Max of vectors(dim): ');fprintf(' %10f(%d)',[maxvectors;0:max(no_dims)]);fprintf('\n');
    vectornorms=sum(abs(mappedX).^2,1).^(1/2);
    fprintf('Norms of vectors(dim):');fprintf(' %10f(%d)',[vectornorms;0:max(no_dims)]);fprintf('\n');
end



%The corresponding outputs are copied to Y.coords
Y.coords=cell(1,numel(no_dims));
for idim=1:numel(no_dims)
    nodims=no_dims(idim);
    
    
    
    if (normaliseeachdatapointtounitlength)
        mappedX(:,ind(1:nodims + 1))=mappedX(:,ind(1:nodims + 1))./repmat( sqrt(sum(mappedX(:,ind(1:nodims + 1)).^2,2)) , 1 , (nodims + 1) );
    end
    
    
    
    if (normalizewitheigenvalues)
        %Normalize the eigenvectors according to the inverse square root
        %This provides normalized distances between mapped points
        mappedXd = mappedX(:,ind(2:nodims + 1))./repmat(sqrt(lambda(2:nodims + 1)'),size(mappedX,1),1);
    else
        mappedXd = mappedX(:,ind(2:nodims + 1));
    end
    
    
    
    if (normaliseeachdatapointtounitlengthafterlambda)
        mappedXd=mappedXd./repmat( sqrt(sum(mappedXd.^2,2)) , 1 , nodims );
    end
    
    
    
    Y.coords{no_dims==nodims}=mappedXd';
    
    if (printthetext)
        fprintf('Embedded to %d-dimensional manifold\n',nodims);
    end
end
fprintf('Lambda(dim):         ');fprintf(' %10f(%d)',[lambda';0:max(no_dims)]);fprintf('\n');
% var(Y.coords{3}(1,:))/var(Y.coords{3}(3,:))



%Same code repeating the calculation for each dimension set
% Y.coords=cell(1,numel(no_dims));
% for idim=1:numel(no_dims)
%     nodims=no_dims(idim);
%     
% 	tol = 0;
%     if strcmp(eig_impl, 'JDQR')
%         opts.Disp = 0;
%         opts.LSolver = 'bicgstab';
%         [mappedX, lambda] = jdqz(L, DD, nodims + 1, tol, opts);			% only need bottom (nodims + 1) eigenvectors
%     else
%         opts.disp = 0;
%         opts.isreal = 1;
%         opts.issym = 1;
%         [mappedX, lambda] = eigs(L, DD, nodims + 1, tol, opts);			% only need bottom (nodims + 1) eigenvectors
%     end
%     lambda = diag(lambda);
%     [lambda, ind] = sort(lambda, 'ascend');
% 	mappedX = mappedX(:,ind(2:nodims + 1));
%     Y.coords{no_dims==nodims}=mappedX';
% end



if issparse(D)
    [a,b,c] = find(D); 
    E = sparse(a,b,ones(size(a)));
else
    E = (~isinf(D));
end

%TODO: compute the residual
R=zeros(1,numel(no_dims));


if (printonscreen)
     %%%%% Plot fall-off of residual variance with dimensionality %%%%%
     figure(19), clf, set(gcf, 'color', 'white');
     hold on
     plot(no_dims, R, 'bo'); 
     plot(no_dims, R, 'b-'); 
     hold off
     ylabel('Residual variance'); 
     xlabel('Isomap dimensionality'); 

     %%%%% Plot two-dimensional configuration %%%%%
     twod = find(no_dims==2,1,'first'); 
     if ~isempty(twod)
         figure(20), clf, set(gcf, 'color', 'white');
         hold on;
         plot(Y.coords{twod}(1,:), Y.coords{twod}(2,:), 'ro'); 
         if (overlay)
             gplot(E(Y.index, Y.index), [Y.coords{twod}(1,:); Y.coords{twod}(2,:)]'); 
             title('Two-dimensional Isomap embedding (with neighborhood graph).'); 
         else
             title('Two-dimensional Isomap.'); 
         end
         hold off;
     end
     
     %%%%% Plot two-dimensional configuration %%%%%
     threed = find(no_dims==3,1,'first'); 
     if ~isempty(threed)
         figure(21), clf, set(gcf, 'color', 'white');
         hold on;
         scatter3(Y.coords{threed}(1,:), Y.coords{threed}(2,:), Y.coords{threed}(3,:), 'ro');
         title('Three-dimensional Isomap.'); 
         hold off;
     end

end







