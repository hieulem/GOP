function [ map ] = convertmap2map( map1,map2 )
%CONVERTMAP2MAP
% map1: C->B
% map2: B->A
% out : C->A

num1 = size(map1,1);
num2 = size(map2,1);
map = map1;
for i=1:num1
    %    i
    if (map1(i,2) == 0)
        map(i,2) = 20000;%map(i,1);
    else
        
        k = map2(map2(:,1)==map1(i,2),2);
        if ~isempty(k)
            if k~=0
                map(i,2) = k;
            else
                map(i,1) =map2(map2(:,1)==map1(i,2),1);
            end
        end
        
    end
    
    
end

