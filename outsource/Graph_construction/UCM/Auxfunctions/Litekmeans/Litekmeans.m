function [label,m,residualerror] = Litekmeans(X,k,niter,multiplicity,seed)
%Inputs:
% X = [ d dimensions x n number of points to cluster ]
% k number of clusters looked for
% multiplicity weight of each point in the assignment, generally an integer set to 1 for the case of standard k-means = [ n of points x 1 ]
% seed initial assignment to clusters = [ 1 x n of points ]
%Outputs:
% m cluster centers = [ d dimensions x number of clusters determined (k at most) ]
% label the cluster assignment ids = [n of points x 1]
% residualerror = scalar value with residual error

%Debug assignments:
% X=(Y.coords{chosend});
% k=agroupnumber;
% niter=noreplicates;

if ( (~exist('seed','var')) || (isempty(seed)) )
    seed= zeros(1,size(X,2));
end
if ( (~exist('multiplicity','var')) || (isempty(multiplicity)) )
    multiplicity=(1:size(X,2))';
end


residualerror=Inf;
label=[];
m=[];
for i=1:niter
    
    [newlabel,newm,newresidualerror] = Litekmeans_one_iteration(X, k, multiplicity, seed);
    
    if (newresidualerror<residualerror)
        residualerror=newresidualerror;
        m=newm;
        label=newlabel;
    end
    
    % fprintf('Residualerror=%f, nlabels = %d\n',residualerror,max(label));

end



function Test_code()

X=[0.1,0.5,5,2,7,1,3.2;6.2,0.7,1,8,5.5,9,0.2;10.1,10.5,0.5,12,0.7,11,23.2];
k=3;
niter=10;
multiplicity=[1,2,1,5,2,1,2];
seed=[1,0,2,0,2,0,0];
[label,m,residualerror] = Litekmeans(X,k,niter,multiplicity,seed);
