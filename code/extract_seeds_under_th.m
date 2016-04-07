function [ seeds,n,t ] = extract_seeds_under_th( graph,th,nseeds )
%EXTRACT_SEEDS_UNDER_TH Summary of this function goes here
%   Detailed explanation goes here
numsp = size(graph,1);
conner(1)=1;

for j=1:3
    d(j,:) = graph(conner(j),:);
    [t,conner(j+1)] = min(d(j,:));
end;


current = max(d,[],1);
[t,seeds(1)]  = min(current,[],2); % center
current = graph(seeds(1),:);
%current = min([current;d]);
n=1;
while  t<th &&  n<nseeds% 
    n=n+1;
    new = graph(seeds(n-1),:);
    current = max([current;new]);%
%    current(current ==inf) = 0;
    [t,seeds(n)] = min (current); 
    
end



end

