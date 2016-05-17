function [Y,R,E]=Projecttomanifold(W,n_size,methodofchoice,n_fcn,opts)
% Y.coords = [ dimtouse x no_data_points_largest_conn_comp ]
% % Y.blocks = [ no_data_points x 1 ]
% Y.index  = [ no_data_points_largest_conn_comp x 1 ] given by find on largest among blocks
% E same size and sparsity as W, specifying the graph connections
% R = [ 1 x dimtouse ] residual variance after eigenmapping, to be defined


if ( (~exist('methodofchoice','var')) || (isempty(methodofchoice)) )
    methodofchoice=3;
end
if ( (~exist('n_size','var')) || (isempty(n_size)) )
    n_size=0; %keep n_size neighbours at maximum or threshold for 'epsilon'
end
if ( (~exist('n_fcn','var')) || (isempty(n_fcn)) )
    n_fcn='k'; %comparing function 'k' or 'epsilon'
end

if ( (~exist('opts','var')) || (~isstruct(opts)) )
    opts=struct();
end
if ( (~isfield(opts,'dims')) || (isempty(opts.dims)) )
    dimtouse=6;
else
    dimtouse=opts.dims;
end
if (~isfield(opts,'display'))
    printonscreen=false;
else
    printonscreen=opts.display;
end
if (~isfield(opts,'verbose'))
    printthetext=false;
else
    printthetext=opts.verbose;
end
if (~isfield(opts,'overlay'))
    overlay=true;
else
    overlay=opts.overlay;
end



%Warn about n neighbors below k for some nodes
% nnodes = size(W,1);
minimum_conn=min(full(sum(W>0)));
if ( (strcmp(n_fcn,'k')) && (minimum_conn<n_size) )
    fprintf('Minimum connectivity %d, n_size %d\n',minimum_conn,n_size);
end



%Select nearest neighbors in the W matrix
makesymmetric=true; %if n_size==0 the matrix is just unchanged
wisdistance=false;
neglectdiagonal=true;
W = Selectneighbornodes(W,n_size,n_fcn,printthetext,makesymmetric,wisdistance,neglectdiagonal);



%Restrict calculations to connected components
blocks = components(W)';
count = zeros(1, max(blocks));
for i=1:max(blocks)
    count(i) = length(find(blocks == i));
end
[count, block_no] = max(count);
conn_comp = find(blocks == block_no);
%conn_comp contains the indexes of the embedded components
Y.index=conn_comp;
% Y.blocks=blocks;
W = W(conn_comp, conn_comp);



%The code allows for defining different embeddings specifying an array for dimtouse (e.g. 1:6)
%The eigenmap is learnt for the maximum number of specified dimensions and then copied to the relative variables
optslaplsolver.disp = 0;
optslaplsolver.isreal = 1;
optslaplsolver.issym = 1;
printonscreeninsidefunction=false;
INCLUDEFIRSTEIGENVECTOR=false;
if (INCLUDEFIRSTEIGENVECTOR)
    %%% Include first eigenvector
    mappedX=Getnewlaplacian(W,max(dimtouse),methodofchoice,optslaplsolver,printonscreeninsidefunction); %,lambda,L
    %mappedX = [ no_data_points x dimtouse ]
    %lambda = [ dimtouse x 1 ]
else
    %%% Consider eigenvectors 2 : (dimtouse+1)
    [mappedX,lambda]=Newlaplacian(W,max(dimtouse),methodofchoice,optslaplsolver,printonscreeninsidefunction); %,lambda,L
    %mappedX = [ no_data_points x dimtouse ]
    %lambda = [ dimtouse+1 x 1 ]
end



%Copy eigenmapped coordinates to Y.coords
Y.coords=cell(1,numel(dimtouse));
for idim=1:numel(dimtouse)
    onedim=dimtouse(idim);
    
    
    
    %%%Different normalizations
%     %Normalize the rows of mappedX (the data point coordinates on the manifold) to 1
%     mappedXd=mappedX(:,1:onedim)./repmat( sqrt(sum(mappedX(:,1:onedim).^2,2)) , 1 , onedim );
%     
%     %Normalize the eigenvectors to norm 1 (the columns of mappedX)
%     mappedXd=mappedX(:,1:onedim)./repmat(sqrt(sum(mappedX(:,1:onedim).^2,1)),size(mappedX,1),1);
% 
%     %Normalize all eigenvectors to [0,1] (the columns of mappedX)
%     mappedXd= ( mappedX(:,1:onedim)-repmat(min(mappedX(:,1:onedim),[],1),size(mappedX,1),1) ) ./...
%         repmat(max(mappedX(:,1:onedim),[],1)-min(mappedX(:,1:onedim),[],1),size(mappedX,1),1) ;
%     
%     %Normalize the eigenvectors according to the inverse square root of the eigenvalues
%     mappedXd = mappedX(:,1:onedim)./repmat(sqrt(lambda(2:onedim + 1)'),size(mappedX,1),1);
%       %Here lambda should reflect its size {1,2}:{onedim,onedim+1}
%     
%     Y.coords{dimtouse==onedim}=mappedXd';
    %%%

    
    Y.coords{idim}=mappedX';
    %Y.coords = [ dimtouse x no_data_points ]
    %Y.index = [ no_data_points x 1 ]
    
    if (printthetext)
        fprintf('Embedded to %d-dimensional manifold\n',onedim);
    end
end
% var(Y.coords{3}(1,:))/var(Y.coords{3}(3,:))



if (~INCLUDEFIRSTEIGENVECTOR)
    Y.lambda=lambda;
    %Y.lambda = [ dimtouse+1 x 1 ]
end



if issparse(W)
    E = (W>0);
%     [a,b,c] = find(W);
%     E = sparse(a,b,ones(size(a)));
else
    E = (W>0);
end



%Residual variance undefined in this case
R=zeros(1,numel(dimtouse));



if (printonscreen)
     %%%%% Plot fall-off of residual variance with dimensionality %%%%%
     figure(19), clf, set(gcf, 'color', 'white');
     hold on
     plot(dimtouse, R, 'bo'); 
     plot(dimtouse, R, 'b-'); 
     hold off
     ylabel('Residual variance'); 
     xlabel('Isomap dimensionality'); 

     %%%%% Plot two-dimensional configuration %%%%%
     twod=Getchosend(Y,2); %twod = find(dimtouse==2,1,'first'); 
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
     threed=Getchosend(Y,3); %threed = find(dimtouse==3,1,'first'); 
     if ~isempty(threed)
         figure(21), clf, set(gcf, 'color', 'white');
         hold on;
         scatter3(Y.coords{threed}(1,:), Y.coords{threed}(2,:), Y.coords{threed}(3,:), 'ro');
         title('Three-dimensional Isomap.'); 
         hold off;
     end

end





function Test_this_function() %#ok<DEFNU>

AAA=[0,1,0.5;1,0,0.3;0.5,0.3,0]; %#ok<NASGU>
AAA=[0,1,0.5;1,0,0.3;0.49,0.3,0]; %asymmetric matrix
methodofchoice=3;

[mappedX,lambda]=Newlaplacian(sparse(AAA),size(AAA,1)-1,methodofchoice) %,L

[mappedX,lambda]=Newlaplacian(AAA,size(AAA,1)-1,methodofchoice) %,L

% neigtest=2;
% disp (  (L*mappedX(:,neigtest-1)/lambda(neigtest))  ...
% ./mappedX(:,neigtest-1)  )

% norm(mappedX)
