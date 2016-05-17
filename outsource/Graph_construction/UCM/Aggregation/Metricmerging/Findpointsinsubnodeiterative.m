function selected=Findpointsinsubnodeiterative(treestructure, firstbelonging, id)

nopoints=numel(firstbelonging);
noids=numel(treestructure);

activeids(id)=true; %Initialised with the id provided in input

selected=false(1,nopoints);
newactiveids=false(1,noids);
while(true)
    
    for i=find(activeids)
        
        selected(firstbelonging==i)=true;
        
        newactiveids(treestructure==i)=true;

    end
    
    
    activeids=newactiveids;
    
    if (~any(newactiveids))
        break;
    end
    
    newactiveids(:)=false;
    
end

selected=find(selected);


