function [ mess] = init_message( Unary,smooth)
k= size(smooth,1);
mess = repmat(Unary,[k,1]);
mess = mess.*smooth;
mess = sum(mess,1);
mess = mess./(sum(mess));
end

