%outlierRemoval.m
%
%remove outliers using the IQR method
%
%input is a affinity matrix

function [outMatrix, innerFence] = outlierRemoval( inMatrix, fense )

t = nonzeros(inMatrix);

q3 = prctile(t, 75);
badMatchT = q3 + fense*iqr(t);

if ~isinf(fense) && badMatchT > mean(t) 
    inMatrix(inMatrix >= min([badMatchT, 1])) = 0;
else
    inMatrix(inMatrix > 1 ) = 0;
end

innerFence = badMatchT;
outMatrix = inMatrix;