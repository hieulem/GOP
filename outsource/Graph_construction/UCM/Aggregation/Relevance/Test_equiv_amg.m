function Test_equiv_amg()

% Test_equiv_amg();

% clear all;
% close all;

%% Setup

%Edge weights
c=0.2; %edge 12
a=0.9; %edge 13
b=0.7; %edge 23

%Node cardinality
numnodes=3;
k=3; %node 1
m=2; %node 2
l=5; %node 3

%Internal weights
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

nodims=2;
nodimsfull=k+m+l -1;
methodofchoice=3;

%%



% The finer graph and the original weights
Wfull=zeros(k+m+l);
for i=1:k+m+l
    for j=i+1:k+m+l
        if (i<=k)&&(j<=k) %nodes 11
            Wfull(i,j)=d;
            Wfull(j,i)=d;
        elseif (i<=k)&&(j>k)&&(j<=k+m) %nodes 12
            Wfull(i,j)=c;
            Wfull(j,i)=c;
        elseif (i<=k)&&(j>k+m) % nodes 13
            Wfull(i,j)=a;
            Wfull(j,i)=a;
        elseif (i>k)&&(i<=k+m)&&(j>k)&&(j<=k+m) %nodes 22
            Wfull(i,j)=e;
            Wfull(j,i)=e;
        elseif (i>k)&&(i<=k+m)&&(j>k+m) %nodes 23
            Wfull(i,j)=b;
            Wfull(j,i)=b;
        else    %nodes 33
            Wfull(i,j)=f;
            Wfull(j,i)=f;
        end
    end
end

% Wfull(logical(eye(size(Wfull,1))))=100;
% Wfull(logical(eye(size(Wfull,1))))=max(Wfull(:));

%eigendecomposition of the full matrix
Wfull=sparse(Wfull);
Init_figure_no(6), imagesc(full(Wfull))
title('Full W')



if (false)
    %%%Computation of spectral clusetring
    [mappedXf,lambdaf,Lf]=Newlaplacian(Wfull,nodimsfull,methodofchoice);

    df=zeros(k+m+l); for i=1:k+m+l;for j=1:k+m+l; df(i,j)=norm(mappedXf(i,:)-mappedXf(j,:));end;end;
    figure(7),imagesc(df./(df(1,end)))
    % figure(7),imagesc(df)
    title('Fistances for generalized eigenvector problem, finer original graph')
end



% Construct diagonal matrix with volumes
dvalues=full(sum(Wfull, 1)); %size(dvalues)
nnodes=k+m+l;
DD = spdiags(reshape(dvalues,[],1),0,nnodes,nnodes);

%Assign each node value equal to its diagonal
Wfull = spdiags(reshape(max(dvalues(:))-dvalues,[],1),0,Wfull);
% Wfull = spdiags(ones(size(Wfull,1),1),0,Wfull);
% Wfull = spdiags(reshape(dvalues,[],1),0,Wfull);


% Label assignment based on the grouped regions (each region a label)
Y=zeros(k+m+l,3);
Y(1:k,1)=1;
Y(k+1:k+m,2)=1;
Y(k+m+1:k+m+l,3)=1;

%Add version with few label switches
Y=[Y,Y]; Y(6:7,end)=0; Y(6:7,end-2)=1;

%Add version with a point labelled per cluster
Y=[Y,zeros(k+l+m,3)]; Y(1,end-2)=1; Y(k+1,end-1)=1; Y(k+m+1,end)=1;

%Normalize Y in case of multiple assignments
% Ybis=Y;
Ybis=Y./repmat( max(sum(Y,1),ones(1,size(Y,2))) , size(Y,1) , 1 ); %IMPORTANT: a same amount of volume must be placed on each labels, thus each label must sum to a constant
% Y=Y./repmat( max(sum(Y,2),ones(size(Y,1),1)) , 1 , size(Y,2) );

Init_figure_no(20), imagesc(Ybis);
% Init_figure_no(20), imagesc(Y);

%Reewight W full
Wfullrw=Wfull/DD;
dvaluesnew=full(sum(Wfullrw, 1)); %size(dvalues)
% DD = diag(sum(W, 2));
Init_figure_no(21), imagesc(full(Wfullrw))
title('Full W rw')


plalpha=0.999999; %0.1, 0.985
niterations=1000; %10, 500

%Propagate labels
S=Sfromw(Wfull); %D^(-1/2) W D^(1/2)
% S=Sfromw(Wfullrw); %D^(-1/2) W D^(1/2)
F=Iteratelabelprop(Ybis,S,niterations,plalpha);
% F=Iteratelabelprop(Y,S,niterations,plalpha);
% F=(1/(1-plalpha))*F; %Re-normalize the F

%Observation: using a volume-balanced-initialization (Ybis) and the defined
%similarity matrix (Wfull) (no normalization per volume) the propagated labels are
%comparable. This shows from the simmetry of propagating a label from a
%node to a neighbor and viceversa.

Init_figure_no(22), imagesc(F);



for i=1:size(F,2)/3
    [mtmp,Lsp(:,i)]=max(F(:,(i-1)*3+1:(i-1)*3+3),[],2);
    % confidence=Computeconfidence(F);
    % [mtmp,Lsp]=max(Y,[],2);
end


Init_figure_no(23), imagesc(Lsp);

%%



%Higher-order decomposition reduced with Hein's method
Whein=zeros(numnodes);
Whein(1,1)=(k-1)*k*d/2;
Whein(2,2)=(m-1)*m*e/2;
Whein(3,3)=(l-1)*l*f/2;
Whein(1,2)=k*c*m; Whein(2,1)=Whein(1,2);
Whein(1,3)=k*a*l; Whein(3,1)=Whein(1,3);
Whein(3,2)=l*b*m; Whein(2,3)=Whein(3,2);
Whein=sparse(Whein);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



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


%%% Constant factor
% W=W/3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Wnaive=[0,c,a;c,0,b;a,b,0];
Wnaive=sparse(Wnaive);
%Wnaive=[0,k*c*m,k*a*l;k*c*m,0,l*b*m;k*a*l,l*b*m,0];
figure(1), imagesc(Wnaive)
title('W coarse - naive method')



%%%Computation of spectral clusetring
[mappedX,lambda,L]=Newlaplacian(W,nodims,methodofchoice);

%%%Computation of spectral clusetring
[mappedXh,lambdah,Lh]=Newlaplacian(Whein,nodims,methodofchoice);

%%% Constant factor
% mappedX=mappedX/(sqrt(3))



%Plot for the fine graph
figure(2), imagesc(full(W))
title('W proposed')
figure(3), imagesc(full(L))
title('L proposed')
figure(4), imagesc(Whein)
title('W - Matthias Heins method')
figure(5), imagesc(full(Lh))
title('L Hein')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Computation of spectral clusetring
[mappedXc,lambdac,Lc]=Newlaplacian(Wnaive,nodims,methodofchoice);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% for i=1:k+m+l;for j=1:k+m+l; d2f(i,j)=norm(mappedX2f(i,:)-mappedX2f(j,:));end;end;
% figure, imagesc(d2f)
% title('distances for EV problem with L')
d=zeros(numnodes); for i=1:3;for j=1:3; d(i,j)=norm(mappedX(i,:)-mappedX(j,:));end;end;
figure(8), imagesc(d./(d(1,3)))
% figure(8), imagesc(d)
title('distances for generalized EV problem, proposed method')
% for i=1:3;for j=1:3; d2(i,j)=norm(mappedX2(i,:)-mappedX2(j,:));end;end;
% figure, imagesc(d2)
% title('distances for EV problem with L')
dc=zeros(numnodes); for i=1:3;for j=1:3; dc(i,j)=norm(mappedXc(i,:)-mappedXc(j,:));end;end;
figure(9), imagesc(dc./(dc(1,3)))
% figure(9), imagesc(dc)
title('distances for EV problem with naive weighting')
%k-means..



%%%%% Experiments with the equivalence of Jordan KDD 09 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wjordan=[0,c,a;c,0,b;a,b,0];
% Wjordan=Wjordan.*repmat([k,m,l],numnodes,1);
% Wjordan=sparse(Wjordan);
% 
% 
% %%%Computation of spectral clusetring
% [mappedXj,lambdaj,Lj]=Newlaplacian(Wjordan,nodims,methodofchoice);
% 
% dj=zeros(numnodes); for i=1:3;for j=1:3; dj(i,j)=norm(mappedXj(i,:)-mappedXj(j,:));end;end;
% figure(8), imagesc(dj./(dj(1,3)))
% % figure(8), imagesc(dc)
% title('distances for EV problem with weighting according to Jordan')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
