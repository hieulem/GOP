function [backmap,foundempty,foundmultiple]=Getbackmap(map,maxvalue)

if ( (~exist('maxvalue','var')) || (isempty(maxvalue)) )
    maxvalue=max(map);
end

foundempty=false;
foundmultiple=false;

backmap=zeros(1,maxvalue);
for i=1:numel(map)
    if (backmap(map(i))~=0)
        foundmultiple=true;
    else
        backmap(map(i))=i;
    end
end

if any(backmap==0)
        foundempty=true;
end



% dd=[1,2,3,4,5]
% ind=[3,1,2,5,4]
% newdd=dd(ind)
% [backmap,foundempty,foundmultiple]=Getbackmap(ind)
% newdd(backmap)



function [backmap,foundempty,foundmultiple]=Other(map,maxvalue) %#ok<DEFNU>

if ( (~exist('maxvalue','var')) || (isempty(maxvalue)) )
    maxvalue=max(map);
end

backmap=zeros(1,maxvalue);

foundempty=false;
foundmultiple=false;

for k=1:maxvalue
    backvalue=find(map==k);
    if isempty(backvalue)
        backmap(k)=0;
        foundempty=true;
    elseif numel(backvalue)>1
        backmap(k)=backvalue(1);
        foundmultiple=true;
    else
        backmap(k)=backvalue;
    end
end
