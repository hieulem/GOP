function [ seeds ] = extract_seeds( nseeds,graph )
%EXTRACT_SEEDS Summary of this function goes here
%   Detailed explanation goes here
%    graph(graph<0) = 0;

conner(1)=10;
for j=1:3
    d(j,:) = geocompute(graph,conner(j));
    [~,conner(j+1)] = max(d(j,:));
end;
current = max(d);
[~,seeds(1)]  = min(current,[],2); % center
current = geocompute(graph,seeds(1));
%current = min([current;d]);
for n=2:nseeds
    new = geocompute(graph,seeds(n-1));
    current = min([current;new]);
    current(current ==inf) = 0;
    [t,seeds(n)] = max (current); 
    
end

end

