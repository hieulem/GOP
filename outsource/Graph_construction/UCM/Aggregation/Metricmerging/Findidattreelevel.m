function selected=Findidattreelevel(treestructure, level)
%selecting level 0 extracts the root id (its value is noids)

noids=numel(treestructure);
selected=false(1,noids);
id=find(treestructure==0); %starting point is the root
selected=Findidattreelevelhelper(selected,treestructure, id, level);

selected=find(selected);



function selected=Findidattreelevelhelper(selected,treestructure, id, level)

if (level==0)
    selected(id)=true;
else
    r=find(treestructure==id);

    for i=1:numel(r)
        selected=Findidattreelevelhelper(selected,treestructure, r(i), level-1);
    end
end