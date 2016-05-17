function selected=Findidtreeatleveliterative(treestructure, level)

noids=numel(treestructure);

activeids(noids)=true; %Initialised to the root node

newactiveids=false(1,noids);
for l=1:level
    
    for i=find(activeids)
        
        newactiveids(treestructure==i)=true;
        
    end
    
    
    activeids=newactiveids;
    
    if (~any(newactiveids))
        break;
    end
    
    newactiveids(:)=false;
    
end

selected=find(activeids);

