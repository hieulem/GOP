function [ energy ] = PairValue( sp1,lb1,sp2,lb2,frame,pos)
%PAIRVALUE Summary of this function goes here
%   Detailed explanation goes here
if lb1==lb2
    energy =10;
    return;
end;
energy=1;
%    
% dAB = %pdist2(pos{frame}(sp1,:),pos{frame}(sp2,:),'euclidean');
% dCD = pdist2(pos{frame-1}(lb1,:),pos{frame-1}(lb2,:),'euclidean');
% %energy= abs(dAB-dCD)/9;


end

