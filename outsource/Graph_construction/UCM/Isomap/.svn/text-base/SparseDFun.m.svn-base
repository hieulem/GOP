function out = SparseDFun(in)

global XXX

out=ones(1,size(XXX,1))*Inf;
[r,c]=find(XXX);
roweqin=(r==in);
out(c(roweqin))=XXX(sub2ind(size(XXX),r(roweqin),c(roweqin)));

% out = L2_distance(X,X(:,in)); 
% out = out'; 
