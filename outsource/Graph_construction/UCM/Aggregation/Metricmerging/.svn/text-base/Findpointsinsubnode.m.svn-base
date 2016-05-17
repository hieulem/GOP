function selected=Findpointsinsubnode(treestructure, firstbelonging, id)

nopoints=numel(firstbelonging);
selected=false(1,nopoints);

selected=Findpointsinsubnodehelper(selected,treestructure, firstbelonging, id);

selected=find(selected);



function selected=Findpointsinsubnodehelper(selected,treestructure, firstbelonging, id)

selected(firstbelonging==id)=true;

r=find(treestructure==id);

for i=1:numel(r)
    selected=Findpointsinsubnodehelper(selected,treestructure, firstbelonging, r(i));
end