function upperassignmentrate=Evaluateupperbound(kmidx,mgt,nclusters,ndatapoints,nrepresentative)

% mgt,nclusters
% size(mgt)
% size(kmcenters) %= [nrepresentive,nfeatures]
% size(kmidx) %=[ndatapoints,1]
% numel(unique(kmidx))
% nrepresentive

kmeansupbound=kmidx;
for i=1:nrepresentative
    kmeansupbound( kmidx==i ) = mode(mgt(kmidx==i))  ; % sum(kmidx==i)
end

% numel(unique(kmeansupbound))

upperassignmentrate=Crate(mgt, kmeansupbound, nclusters, ndatapoints);
