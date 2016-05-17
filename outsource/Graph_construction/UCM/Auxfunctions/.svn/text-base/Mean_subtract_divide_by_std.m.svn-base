function vect=Mean_subtract_divide_by_std(vect)
%vect is n x noFrames, stds and means are computed over the noFrames
%example: [x1,x2,x3,x4;
%          y1,y2,y3,y4;
%          z1,z2,z3,z4]

std_vect=std(vect,0,2);
vect=(vect-repmat(mean(vect,2),[1 size(vect,2)])); %subtracts the mean of x and y
for i=1:size(vect,1)
    if ( std_vect(i) ~= 0 )
        vect(i,:)=vect(i,:)./std_vect(i); % and divides by their std for x
    end
end

