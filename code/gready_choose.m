function [ assign ] = gready_choose( Unary,UConnection )
% 
 siz = size(Unary);
 
% U = reshape(Unary,1,[]);
% total = length(U);
% [~,ind] = min(U);
% [k,t] = ind2sub(siz,ind); 
% assign=ones(siz(2)+1,siz(1));
% assign(k)=t;
% count =0;
% energy = 0;
% while(count < siz(1))
%     [~,ind] = min(U);
%     energy = energy+min(U);
%     [k,t] = ind2sub(siz,ind); 
%     assign(k)=t;
%     U([0:siz(2)-1]*siz(1) + k) = inf;
%     U((t-1)*siz(1) + [1:siz(1)]) = inf;
%     count = count+1;
% end
%T= reshape(U,siz(1),siz(2))
end

