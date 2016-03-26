function [ B ] = visgeodistance(sp,graph,seeds )
%VISGEODISTANCE Summary of this function goes here
%   Detailed explanation goes here
nseeds = size(seeds,2);

current = (geocompute(graph,seeds(1)));
%current = min([current;d]);
for n=2:nseeds
    new = geocompute(graph,seeds(n-1));
    current = min([current;new]);   
end

B = double(sp*0);
for i = 1:size(current,2)
    B(sp == i) = current(i);
end;
imagesc(B);

end

