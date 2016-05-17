
% -------------------------------------------------------------------------
% Function: 
% [RD,CD,order]=optics(x,k)
% -------------------------------------------------------------------------
% Aim: 
% Ordering objects of a data set to obtain the clustering structure 
% -------------------------------------------------------------------------
% Input: 
% x - data set (m,n); m-objects, n-variables
% k - number of objects in a neighborhood of the selected object
% (minimal number of objects considered as a cluster)
% -------------------------------------------------------------------------
% Output: 
% RD - vector with reachability distances (m,1)
% CD - vector with core distances (m,1)
% order - vector specifying the order of objects (1,m)
% -------------------------------------------------------------------------
% Example of use:
% x=[randn(30,2)*.4;randn(40,2)*.5+ones(40,1)*[4 4]];
% [RD,CD,order]=Optics(x,4);
% -------------------------------------------------------------------------
% References: 
% [1] M. Ankrest, M. Breunig, H. Kriegel, J. Sander, 
% OPTICS: Ordering Points To Identify the Clustering Structure, 
% available from www.dbs.informatik.uni-muenchen.de/cgi-bin/papers?query=--CO
% [2] M. Daszykowski, B. Walczak, D.L. Massart, Looking for natural  
% patterns in analytical data. Part 2. Tracing local density 
% with OPTICS, J. Chem. Inf. Comput. Sci. 42 (2002) 500-507
% -------------------------------------------------------------------------
% Written by Michal Daszykowski
% Department of Chemometrics, Institute of Chemistry, 
% The University of Silesia
% December 2004
% http://www.chemometria.us.edu.pl

function [RD,CD,order]=Optics(x,k)

[m,n]=size(x);
CD=zeros(1,m);
RD=ones(1,m)*10^10;

% Calculate Core Distances
for i=1:m	
    D=sort(dist(x(i,:),x));
    CD(i)=D(k+1);  
end

order=[];
seeds=[1:m];

ind=1;

while ~isempty(seeds)
    ob=seeds(ind);        
    seeds(ind)=[]; 
    order=[order ob];
    mm=max([ones(1,length(seeds))*CD(ob);dist(x(ob,:),x(seeds,:))]);
    ii=(RD(seeds))>mm;
    RD(seeds(ii))=mm(ii);
    [i1 ind]=min(RD(seeds));
end   

RD(1)=max(RD(2:m))+.1*max(RD(2:m));


function [D]=dist(i,x)

% function: [D]=dist(i,x)
%
% Aim: 
% Calculates the Euclidean distances between the i-th object and all objects in x	 
% Input: 
% i - an object (1,n)
% x - data matrix (m,n); m-objects, n-variables	    
%                                                                 
% Output: 
% D - Euclidean distance (m,1)

[m,n]=size(x);
D=(sum((((ones(m,1)*i)-x).^2)'));

if n==1
   D=abs((ones(m,1)*i-x))';
end


function Visualize(x)

therand=randperm(size(x,1));
x(:,1)=x(therand,1);
x(:,2)=x(therand,2);

Init_figure_no(10),scatter(x(:,1),x(:,2))

Init_figure_no(10),scatter3(x(order,1),x(order,2),1:size(x,1))
Init_figure_no(10),scatter3(x(:,1),x(:,2),RD')
Init_figure_no(10),scatter3(x(:,1),x(:,2),CD')

Init_figure_no(13),bar(1:numel(order),RD(order))

th=10;
class=ones(1,size(x,1)).*(-2);
count=0;
toincrease=false;
for i=1:size(x,1)
    iinorder=order(i);
    if (RD(iinorder)>th)
        class(iinorder)=-1;
        toincrease=true;
        continue;
    end
    if (toincrease)
        count=count+1;
        toincrease=false;
    end
    class(iinorder)=count;
end

Init_figure_no(10),scatter3(x(:,1),x(:,2),class')



Init_figure_no(10),scatter3(x(:,1),x(:,2),type')



function Otherfunctions()

load fisheriris                            %# Iris dataset
Q = [6 3 4 1 ; 5 4 3 2];                   %# query points

%# build kd-tree
knnObj = createns(meas, 'NSMethod','kdtree', 'Distance','euclidean');

%# find k=5 Nearest Neighbors to Q
[idx Dist] = knnsearch(knnObj, Q, 'K',5);



[matlabroot '\images\images\private\kdtree.m']
[matlabroot '\images\images\private\nnsearch.m']



function Useonmanifold()

x=[Y.coords{6}]';
size(x)

[RD,CD,order]=Optics(x,10);

[class,type]=Dbscan(x,10,0.5);
[class,type]=Dbscan(x,10);
Eps=Determinetheepsilon(x,10)
[max(class), min(class)]

sum(class==(-1))
sum(type==(-1))
% class(class==(-1))=(max(class)+1);
class(class==(-1))=(-10); %(-10) labels represent outliers
% class(class==(-10))=(-1);

%Visualization
distributecolours=true;
includenumbers=false;
Visualiseclusteredpoints(Y,class',2,22,distributecolours,includenumbers);
Visualiseclusteredpoints(Y,class',3,24,distributecolours,includenumbers);
