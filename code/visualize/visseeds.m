function [ I,rec ] = visseeds( I,sp,se )
%VISSEEDS Summary of this function goes here
%   Detailed explanation goes here

    A = sp*0;
    for i=1:length(se)
        A(sp == se(i)) = 300;
        
    end;
    B = find(A>0);
    [Bx,By] = ind2sub(size(A),B);
    rec  = [min(By),min(Bx),max(By),max(Bx)];

    
    A = uint8(repmat(A,[1,1,3]));
    A(:,:,1) =0;
    A(:,:,2) = 0;
    
    
   % imagesc([I+A]);
    I = I+A;
%     I([rec(2):rec(2)+2,rec(4):rec(4)+2],:,:) = 300;
%     I(:,[rec(1):rec(1)+2,rec(3):rec(3)+2],:) = 300;
end

