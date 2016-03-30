function [ I ] = visseeds( I,sp,se )
%VISSEEDS Summary of this function goes here
%   Detailed explanation goes here

    A = sp*0;
    for i=1:length(se)
        A(sp == se(i)) = 300;
    end;
    A = uint8(repmat(A,[1,1,3]));
    A(:,:,3) =0;
    A(:,:,2) = 0;
    
    
   % imagesc([I+A]);
    I = I+A;
end

