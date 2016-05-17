function isrequested=Isaffinityrequested(theset,varargin)
%True if any of the varargin argument is in theset

isrequested=false;
for i=1:numel(varargin)
    if (any(strcmp(varargin{i},theset)))
        isrequested=true;
        return;
    end
end
