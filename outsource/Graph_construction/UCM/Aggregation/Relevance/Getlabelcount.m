function [normpertrack]=Getlabelcount(twlabelledlevelvideo,tmpoptions,twucm2,printonscreen)
%In case the pixel level is specified (tmpoptions.ucm2levelfrw==0) twucm2 is not
%needed

if (~exist('tmpoptions','var'))
    tmpoptions=[];
end

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
% printonscreeninsidefunction=false;




%Level at which to threshold the UCM2 to get the superpixels for which the
%reweighting should be done (Level 0 specifies the pixel level)
if ( (isfield(tmpoptions,'ucm2levelfrw')) && (~isempty(tmpoptions.ucm2levelfrw)) )
    Level=tmpoptions.ucm2levelfrw;
else
    Level=1;
end

noFrames=size(twlabelledlevelvideo,3);



%Assign unique labels to larger superpixels (used in computing the correspondence matrix)
twinlabelledlevelunique=twlabelledlevelvideo;
count=0;
for f=2:size(twinlabelledlevelunique,3)
    count=count+max(max(twlabelledlevelvideo(:,:,(f-1))));
    twinlabelledlevelunique(:,:,f)=twinlabelledlevelunique(:,:,f)+count;
end
% nlargesuperpixels=count+max(max(twlabelledlevelvideo(:,:,size(twinlabelledlevelunique,3))));



maxnotracks=max(twinlabelledlevelunique(:));



%Labelledlevelvideo for the layer lower down in the hierarchy (0 stands for pixels)
%The required output for the equivalent computation is normpertrack
if (Level==0) %Compute normpertrack with the pixels within the provided superpixelization
    
    

    %Compute normpertrack with pixels
    normpertrack=zeros(maxnotracks,1);
    for i=1:numel(twinlabelledlevelunique)
        normpertrack(twinlabelledlevelunique(i))=normpertrack(twinlabelledlevelunique(i))+1;
    end
    
    
    
else %Compute normpertrack with the superpixelization at the specified lower level
    %only noFrames are used in the function
    [twlabelledlowerlevel]=Labellevelframes2(twucm2,Level,noFrames,printonscreen); %,numberofsuperpixelsperframe
    
    
    
    %Assign unique labels to superpixels (used in computing the correspondence matrix)
    twinlabelledlowerunique=twlabelledlowerlevel;
    count=0;
    for f=2:size(twlabelledlowerlevel,3)
        count=count+max(max(twlabelledlowerlevel(:,:,(f-1))));
        twinlabelledlowerunique(:,:,f)=twinlabelledlowerunique(:,:,f)+count;
    end
    noallsuperpixels=count+max(max(twlabelledlowerlevel(:,:,size(twlabelledlowerlevel,3))));
    % Printthevideoonscreen(twlabelledlowerlevel, true, 1, true, [], [], true);
    % Printthevideoonscreen(twinlabelledlowerunique, true, 1, true, [], [], true);



    %Compute correspondence matrix between superpixels and supervoxels
    corrsupertracks=Getcorrsupertracksmatrixmex(twinlabelledlevelunique,twinlabelledlowerunique,maxnotracks,noallsuperpixels);
%     corrsupertracks=Getcorrsupertracksmatrix(twinlabelledlevelunique,twinlabelledlowerunique,maxnotracks,noallsuperpixels);
%     if (~isequal(corrsupertracks,corrsupertracks2)), fprintf('\n\n\n\n\n\n\n\n\n\n\n\nDissimilarity corrsupertracks\n\n\n\n\n\n\n\n\n\n\n\n'); end
%     clear corrsupertracks2

    
    
    %%%norm
    normpertrack=sum(corrsupertracks,2); %This contains the number of superpixels per track
end
% normpertrack=(normpertrack).^2;
% normpertrack=sqrt(normpertrack);











function Reretest()

Init_figure_no(1), plot(normpertrack2,(normpertrack),'r+')

newsimilarities2=Reweightequivalently(twsimilarities,normpertrack,maxnotracks);
if (~isequal(newsimilarities,newsimilarities2)), fprintf('\n\n\n\n\n\n\n\n\n\n\n\nDissimilarity newsimilarities\n\n\n\n\n\n\n\n\n\n\n\n'); end
clear newsimilarities2






function Retest()


%edge weights
c=0.2; %edge 12
a=0.9; %edge 13
b=0.7; %edge 23



%node cardinality
numnodes=3;
k=3; %node 1
m=2; %node 2
l=5; %node 3



%internal weights
Z=1.0;
% d=Z*(k*a*l+k*c*m);%node 1
% e=Z*(l*b*m+k*c*m);%node 2
% f=Z*(k*a*l+l*b*m);%node 3
d=Z*(a+c);%node 1
e=Z*(b+c);%node 2
f=Z*(a+b);%node 3
% d=1;%node 1
% e=1;%node 2
% f=1;%node 3



Wnaive=[0,c,a;c,0,b;a,b,0];
Wnaive=sparse(Wnaive);




%Initialize the support variables
maxnotrackstt=size(Wnaive,1);
normpertracktt=zeros(maxnotrackstt,1);
normpertracktt(1)=k;
normpertracktt(2)=m;
normpertracktt(3)=l;



%Find edges in twsimilarities
[rr,cc,rcv]=find(Wnaive);
fprintf('Mean similarity value orig %.8f\n',mean(rcv));



%Eliminate diagonal elements from twsimilarities's decomposing elements
diagonalelements= (rr==cc);
rr(diagonalelements)=[];
cc(diagonalelements)=[];
rcv(diagonalelements)=[];



%Transform the elements on the diagonal
Z=1;
rrd=zeros(maxnotrackstt,1); ccd=zeros(maxnotrackstt,1); rcvd=zeros(maxnotrackstt,1);
for i=1:maxnotrackstt
    
    rrd(i)=i;
    ccd(i)=i;
    
    
%     W(1,1)=(k-1)*d - (k-1)*l*a - (k-1)*m*c;
    
    % g_i is given by numel(find(.)) on vector corrsupertracks(i,:), number of subcomponents of node i (finer touched superpixels)
    % w(e_{ij}) is given by rcv, in paticular i=rr(k), j=cc(k), w(e_{ij})=rcv(k)
    % set of j~=i with an edge to i is find( rr==i )
    % w(e_{ij}) for all j~=i is rcv( rr==i )
    % j's edged to i, i~=j are cc( rr==i )
    % g_j is therefore normpertracktt( cc( rr==i )  )
    
    rcvd(i)=...
    (normpertracktt(i)-1) * ...   %g_i
    ...
    ( ...
    ...
    Z*sum( rcv( rr==i ) ) ... %sum( Zw(e_{ij}) )
    ...
    - ...
    ...
    sum( ... %sum( g_j  w(e_{ij}) )
    rcv( rr==i ) .* ... 
    normpertracktt( cc( rr==i )  )...
    )...
    ...
    );

    %%%Compute diagonal elements assuming there are diagonal elements in twsimilarities
    % g_i is given by numel(find(.)) on vector corrsupertracks(i,:), number of subcomponents of node i (finer touched superpixels)
    % w(e_{ij}) is given by rcv, in paticular i=rr(k), j=cc(k), w(e_{ij})=rcv(k)
    % set of j~=i with an edge to i is find( (rr==i) & (cc~=i) )
    % w(e_{ij}) for all j~=i is rcv( (rr==i) & (cc~=i) )
    % j's edged to i, i~=j are cc( (rr==i) & (cc~=i) )
    % g_j is therefore normpertracktt( cc( (rr==i) & (cc~=i) )  )
    %
%     rcvd(i)=...
%     (normpertracktt(i)-1) * ...   %g_i
%     ...
%     ( ...
%     ...
%     Z*sum( rcv( (rr==i) & (cc~=i) ) ) ... %sum( Zw(e_{ij}) )
%     ...
%     - ...
%     ...
%     sum( ... %sum( g_j  w(e_{ij}) )
%     rcv( (rr==i) & (cc~=i) ) .* ... 
%     normpertracktt( cc( (rr==i) & (cc~=i) )  )...
%     )...
%     ...
%     );
end



%Transform the non-diagonal elements
rcv=rcv.*normpertracktt(rr).*normpertracktt(cc);
%Transform the non-diagonal elements (assuming there diagonal elements)
% nondiagonalelements= ( rr~=cc );
% rcv(nondiagonalelements)=rcv(nondiagonalelements).*normpertracktt(rr(nondiagonalelements)).*normpertracktt(cc(nondiagonalelements));
% fprintf('%d %d %f\n',[rr,cc,rcv]');



%Reweight edges
% rcv= rcv.*(normpertracktt(rr)+normpertracktt(cc)-1); %\delta=(normpertracktt(rr)+normpertracktt(cc))
[modercv,freqrcv]=mode(rcv);
[modercvd,freqrcvd]=mode(rcvd);
fprintf('Similarities multiplied (just off diagonal values) mean %.8f, min %.8f, max %.8f, med %.8f, mode %.8f (freq %d)\n',mean(rcv),min(rcv),max(rcv),median(rcv),modercv,freqrcv);
fprintf('Similarities multiplied (diagonal values) mean %.8f, min %.8f, max %.8f, med %.8f, mode %.8f (freq %d)\n',mean(rcvd),min(rcvd),max(rcvd),median(rcvd),modercvd,freqrcvd);



%Normalize rcv to [0,1]
% rcv=rcv./(max(rcv(:)));
% fprintf('Mean similarity value reweighted %.8f\n',mean(rcv));



%Recombine twsimilarities
Wequiv=sparse([rr;rrd],[cc;ccd],[rcv;rcvd],maxnotrackstt,maxnotrackstt);
% newsimilarities=sparse(rr,cc,rcv,maxnotrackstt,maxnotrackstt);







W=zeros(numnodes);
W(1,1)=(k-1)*d - (k-1)*l*a - (k-1)*m*c;
W(2,2)=(m-1)*e - (m-1)*l*b - (m-1)*k*c;
W(3,3)=(l-1)*f - (l-1)*m*b - (l-1)*k*a;
W(1,2)=k*c*m; W(2,1)=W(1,2);
W(1,3)=k*a*l; W(3,1)=W(1,3);
W(3,2)=l*b*m; W(2,3)=W(3,2);

W=sparse(W);

%Find edges in twsimilarities
[rr,cc,rcv]=find(W);

%Eliminate diagonal elements from twsimilarities's decomposing elements
% diagonalelements= (rr==cc);
% rr(diagonalelements)=[];
% cc(diagonalelements)=[];
% rcv(diagonalelements)=[];

fprintf('%d %d %f\n',[rr,cc,rcv]');
















function Test()
%Original function written with Margret

%%

% clear all;
close all;

%edge weights
c=0.1; %edge 12
a=0.4; %edge 13
b=0.1; %edge 23

%internal weights
d=1;%node 1
e=1;%node 2
f=1;%node 3


%node cardinality
numnodes=3;
k=3; %node 1
m=2; %node 2
l=5; %node 3

%internal weights
Z=1.0;
d=Z*(k*a*l+k*c*m);%node 1
e=Z*(l*b*m+k*c*m);%node 2
f=Z*(k*a*l+l*b*m);%node 3
% d=Z*(a+c);%node 1
% e=Z*(b+c);%node 2
% f=Z*(a+b);%node 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W=zeros(numnodes);
W(1,1)=(k-1)*d - (k-1)*l*a - (k-1)*m*c;
W(2,2)=(m-1)*e - (m-1)*l*b - (m-1)*k*c;
W(3,3)=(l-1)*f - (l-1)*m*b - (l-1)*k*a;
W(1,2)=k*c*m; W(2,1)=W(1,2);
W(1,3)=k*a*l; W(3,1)=W(1,3);
W(3,2)=l*b*m; W(2,3)=W(3,2);

W=sparse(W);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Wc=[0,k*c*m,k*a*l;k*c*m,0,l*b*m;k*a*l,l*b*m,0];
figure(5), imagesc(Wc)
title('old W coarse')


DD = diag(sum(W, 2));
DDminushalf=sqrt(DD^(-1));
L=speye(size(W,1))-DDminushalf*W*DDminushalf;

opts.disp = 0;
opts.isreal = 1;
opts.issym = 1;
nodims=2;
tol = 0;
[mappedX, lambda] = eigs(DD-W, DD, nodims + 1, 'sa' , opts);            % only need bottom (nodims + 1) eigenvectors
for i=1:numnodes
    if lambda(i,i)<0
        mappedX(:,i)= mappedX(:,i)*(-1);
        lambda(i,i)=lambda(i,i)*(-1);
    end
end
% for i=1:numnodes
%
%         mappedX(:,i)= mappedX(:,i)/norm(mappedX(:,i));
%
% end


lambda = diag(lambda);
[lambda, ind] = sort(lambda, 'ascend');
lambda
mappedX = mappedX(:,ind(2:nodims + 1));




% [mappedX2, lambda2] = eigs(L, nodims + 1, 'sa' , opts );            % only need top (nodims + 1) eigenvectors
% for i=1:3
%     if lambda2(i,i)<0
%         mappedX2(:,i)= mappedX2(:,i)*(-1);
%         lambda2(i,i)=lambda2(i,i)*(-1);
%     end
% end
% for i=1:nodims+1
%         mappedX2(i,:)= mappedX2(i,:)/norm(mappedX2(i,:));
% end
% lambda2 = diag(lambda2);
% [lambda2, ind] = sort(lambda2, 'ascend');
% lambda2
% mappedX2 = mappedX2(:,ind(2:nodims + 1));
% 

figure, imagesc(full(W))
title('W superpixels')
figure, imagesc(full(L))
title('L superpixels')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W=Wc;


DD = diag(sum(W, 2));
DDminushalf=sqrt(DD^(-1));
L=speye(size(W,1))-DDminushalf*W*DDminushalf;

opts.disp = 0;
opts.isreal = 1;
opts.issym = 1;
nodims=2;
tol = 0;
[mappedXc, lambdac] = eigs(DD-W, DD, nodims + 1, 'sa' , opts);            % only need bottom (nodims + 1) eigenvectors
for i=1:numnodes
    if lambdac(i,i)<0
        mappedXc(:,i)= mappedXc(:,i)*(-1);
        lambdac(i,i)=lambdac(i,i)*(-1);
    end
end
% for i=1:numnodes
%
%         mappedX(:,i)= mappedX(:,i)/norm(mappedX(:,i));
%
% end


lambdac = diag(lambdac);
[lambdac, ind] = sort(lambdac, 'ascend');
lambdac
mappedXc = mappedXc(:,ind(2:nodims + 1));





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W=zeros(k+m+l);
for i=1:k+m+l
    for j=i+1:k+m+l
        if (i<=k)&&(j<=k) %nodes 11
            W(i,j)=d;
            W(j,i)=d;
        elseif (i<=k)&&(j>k)&&(j<=k+m) %nodes 12
            W(i,j)=c;
            W(j,i)=c;
        elseif (i<=k)&&(j>k+m) % nodes 13
            W(i,j)=a;
            W(j,i)=a;
        elseif (i>k)&&(i<=k+m)&&(j>k)&&(j<=k+m) %nodes 22
            W(i,j)=e;
            W(j,i)=e;
        elseif (i>k)&&(i<=k+m)&&(j>k+m) %nodes 23
            W(i,j)=b;
            W(j,i)=b;
        else    %nodes 33
            W(i,j)=f;
            W(j,i)=f;
        end
    end
end




%eigendecomposition of the full matrix
W=sparse(W);
figure, imagesc(full(W))
title('full W')


DD = diag(sum(W, 2));
DDminushalf=sqrt(DD^(-1));
L=speye(size(W,1))-DDminushalf*W*DDminushalf;
figure, imagesc(full(L))
title('full L')
opts.disp = 0;
opts.isreal = 1;
opts.issym = 1;
nodims=10;
tol = 0;
[mappedXf, lambdaf] = eigs(DD-W, DD, nodims, 'sa' , opts);            % only need bottom (nodims + 1) eigenvectors

% for i=1:nodims
%     if lambdaf(i,i)<0
%         mappedXf(:,i)= mappedXf(:,i)*(-1);
%         lambdaf(i,i)=lambdaf(i,i)*(-1);
%     end
% end
% for i=1:nodims
%
%         mappedXf(:,i)= mappedXf(:,i)/norm(mappedXf(:,i));
%
% end
lambdaf = diag(lambdaf);
[lambdaf, ind] = sort(lambdaf, 'ascend');
lambdaf
mappedXf = mappedXf(:,ind(2:nodims));



%lambda = diag(lambda);
%[lambda, ind] = sort(lambda, 'ascend');




% [mappedX2f, lambda2f] = eigs(L, nodims, 'sa' , opts);            % only need bottom (nodims + 1) eigenvectors
% % for i=1:nodims
% %     if lambda2f(i,i)<0
% %         mappedX2f(:,i)= mappedX2f(:,i)*(-1);
% %         lambda2f(i,i)=lambda2f(i,i)*(-1);
% %     end
% % end
% for i=1:nodims
%         mappedX2f(i,:)= mappedX2f(i,:)/norm(mappedX2f(:,i));
% 
% end
% 
% lambda2f = diag(lambda2f);
% [lambda2f, ind] = sort(lambda2f, 'ascend');
% lambda2f
% mappedX2f = mappedX2f(:,ind(2:nodims));

for i=1:k+m+l;for j=1:k+m+l; df(i,j)=norm(mappedXf(i,:)-mappedXf(j,:));end;end;
figure,imagesc(df)
title('distances for generalized EV problem')
% for i=1:k+m+l;for j=1:k+m+l; d2f(i,j)=norm(mappedX2f(i,:)-mappedX2f(j,:));end;end;
% figure, imagesc(d2f)
% title('distances for EV problem with L')
for i=1:3;for j=1:3; d(i,j)=norm(mappedX(i,:)-mappedX(j,:));end;end;
figure, imagesc(d)
title('distances for generalized EV problem')
% for i=1:3;for j=1:3; d2(i,j)=norm(mappedX2(i,:)-mappedX2(j,:));end;end;
% figure, imagesc(d2)
% title('distances for EV problem with L')
for i=1:3;for j=1:3; dc(i,j)=norm(mappedXc(i,:)-mappedXc(j,:));end;end;
figure, imagesc(dc)
title('distances for EV problem with naive weighting')
%k-means..





%%





























function Previous_test()

a=0.5; b=0.7; c=0.8;
% k=1; l=1; m=1;
k=3; l=5; m=2;

W=zeros(3);

W(1,1)=(1-k)*( (l-1)*a + (m-1)*c );
W(2,2)=(1-m)*( (l-1)*b + (k-1)*c );
W(3,3)=(1-l)*( (k-1)*a + (m-1)*b );

W(1,2)=k*c*m; W(2,1)=W(1,2);
W(1,3)=k*a*l; W(3,1)=W(1,3);
W(3,2)=l*b*m; W(2,3)=W(3,2);

W=sparse(W);

% forceonediagonal=true;
% W=Forceonediagonal(W,[],forceonediagonal);


DD = diag(sum(W, 2));
DDminushalf=sqrt(DD^(-1));
L=speye(size(W,1))-DDminushalf*W*DDminushalf;

opts.disp = 0;
opts.isreal = 1;
opts.issym = 1;
nodims=2;
tol = 0;
[mappedX, lambda] = eigs(W, DD, nodims + 1, 1 , opts);			% only need bottom (nodims + 1) eigenvectors
% [mappedX, lambda] = eigs(L, DD, nodims + 1, 1 , opts);			% only need bottom (nodims + 1) eigenvectors
mappedX=mappedX./repmat(sqrt(abs(diag(lambda)))',size(mappedX,1),1);

lambda = diag(lambda);
[lambda, ind] = sort(lambda, 'ascend');

mappedXd = mappedX(:,ind(2:nodims + 1));

disp(full(W))


[mappedX2, lambda2] = eig(full(L));			% only need bottom (nodims + 1) eigenvectors
mappedX2=mappedX2./repmat(1-sqrt(diag(lambda2))',size(mappedX2,1),1);


W=zeros(k+l+m);



%Full matrix 

%eigendecomposition of the full matrix


%k-means..



