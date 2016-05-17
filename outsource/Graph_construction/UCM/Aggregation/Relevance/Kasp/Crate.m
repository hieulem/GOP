function correctassignmentrate=Crate(mgt, kmidxnew, nclusters, ndatapoints)
% Compute the clustering accuracy using the true labels in the data.
% 
% If # clusters <=7, look for maximum match over all permutations of 
%       cluster IDs
% Else maximum match over 10000 random sampling from all permutations
%
% No attempt is made to optimize the computation as that is not the focus
% of the algorithm.

fprintf('Computing the accuracy now ......\n');

if (nclusters>7), fprintf('It may take a while as the number of clusters appears to be large ......\n'); end

nrandomsamples=10000;
assignment=zeros(ndatapoints,1); %otherassignment=zeros(ndatapoints,1);

allpermutations=perms(1:nclusters);
correctassignmentrate=0;
if (nclusters <8)
    nassignments=size(allpermutations,1);
    for i=1:nassignments
        for j=1:nclusters
            assignment(kmidxnew==j)=allpermutations(i,j);
        end
        currentassignmentrate=sum(mgt==assignment)/ndatapoints;
        if (correctassignmentrate<currentassignmentrate), correctassignmentrate=currentassignmentrate; end
    end
else
    factorialnclusters=factorial(nclusters);
    if (factorialnclusters>nrandomsamples)
        idx = randperm(factorialnclusters,nrandomsamples);
    else
        idx= 1:factorialnclusters;
        nrandomsamples=factorialnclusters;
    end
    for i=1:nrandomsamples
        permx=allpermutations(idx(i),:);
        for j = 1:nclusters
            assignment(kmidxnew==j)=permx(j);
        end
        currentassignmentrate=sum(mgt==assignment)/ndatapoints;
        if (correctassignmentrate<currentassignmentrate), correctassignmentrate=currentassignmentrate; end
    end
end
fprintf('The clustering rate is %g\n',correctassignmentrate);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To generate all possible permutations of a given list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function pmat=permu(vect)
% 
% n=length(vect);
% if(n>1)
%     pmat=zeros(factorial(n),n);
%     blkSize=factorial(n-1);
%     for i=1:n
%         idxb=(i-1)*blkSize+1; idxe=i*blkSize;
%         pmat(idxb:idxe,1)=repmat(vect(i),1,blkSize);
%         tvect=vect;
%         tvect(i)=[];
%         pmat[idxb:idxe,2:n]=permu(tvect);
%     end
% else
%     pmat=vect(1);
% end

