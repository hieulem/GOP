function Test_equiv_case_new_margret()

% Test_equiv_case();

%%

% clear all;
% close all;



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
 d=Z*(a*l+c*m);%node 1
 e=Z*(l*b+k*c);%node 2
 f=Z*(k*a+b*m);%node 3
% d=Z*(a+c);%node 1
% e=Z*(b+c);%node 2
% f=Z*(a+b);%node 3
% d=1;%node 1
% e=1;%node 2
% f=1;%node 3



nodims=2;
nodimsfull=k+m+l -1;
methodofchoice=1;



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

Whein=zeros(numnodes);
Whein(1,1)=(k-1)*k*d/2;
Whein(2,2)=(m-1)*m*e/2;
Whein(3,3)=(l-1)*l*f/2;
Whein(1,2)=k*c*m; Whein(2,1)=Whein(1,2);
Whein(1,3)=k*a*l; Whein(3,1)=Whein(1,3);
Whein(3,2)=l*b*m; Whein(2,3)=Whein(3,2);
Whein=sparse(Whein);
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

% The finer graph and the original weights
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
figure(6), imagesc(full(W))
title('full W')



%%%Computation of spectral clusetring
[mappedXf,lambdaf,Lf]=Newlaplacian(W,nodimsfull,methodofchoice);




df=zeros(k+m+l); for i=1:k+m+l;for j=1:k+m+l; df(i,j)=norm(mappedXf(i,:)-mappedXf(j,:));end;end;
figure(7),imagesc(df./(df(1,end)))
% figure(7),imagesc(df)
title('distances for generalized EV problem, finer original graph')
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
