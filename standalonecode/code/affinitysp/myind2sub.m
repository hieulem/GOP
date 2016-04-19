function [ out] = myind2sub( siz,ndx,nout)
%MYIND2SUB Summary of this function goes here
%   Detailed explanation goes here

out=0;v2=[];
siz = double(siz);
lensiz = length(siz);

if lensiz < nout
    siz = [siz ones(1,nout-lensiz)];
elseif lensiz > nout
    siz = [siz(1:nout-1) prod(siz(nout:end))];
end
varargout=[];
if nout > 2
    k = cumprod(siz);
    for i = nout:-1:3,
        vi = rem(ndx-1, k(i-1)) + 1;
        vj = (ndx - vi)/k(i-1) + 1;
        varargout(i-2) = double(vj);
        ndx = vi;
    end
end

if nout >= 2
    vi = rem(ndx-1, siz(1)) + 1;
    v2 = double((ndx - vi)/siz(1) + 1);
    v1 = double(vi);
else 
    v1 = double(ndx);
end;
out =[v1,v2,varargout];
end

