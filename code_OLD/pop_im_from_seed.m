function [ Im, c ] = pop_im_from_seed( I,sp,th,dist_ )
c=dist_<= th;
a= find(dist_<= th);
b=sp*0;
for i=1:length(a)
    b(find(sp == a(i))) =1;
end

tt = repmat(b,[1,1,3]);
tt(:,:,2) = tt(:,:,2)*100;
Im= I + uint8(tt);

end

