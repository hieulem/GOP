function labels=Labelthetree(treestructure, firstbelonging, level)

nopoints=numel(firstbelonging);

labels=zeros(1,nopoints);
selected=false(1,nopoints);



%First assign labels to those merged nodes
selectedids=Findidtreeatleveliterative(treestructure, level);
% selectedids=Findidtreeatlevel(treestructure, level);
labelnumber=0;
for i=selectedids
    labelnumber=labelnumber+1;
    selectedwithid=Findpointsinsubnodeiterative(treestructure, firstbelonging, i);
%     selectedwithid=Findpointsinsubnode(treestructure, firstbelonging, i);
    labels(selectedwithid)=labelnumber;
    selected(selectedwithid)=true;
end



%Then assign single labels to nodes not yet merged
missinglabels=sum(~selected);
labels(~selected)=(labelnumber+1):(labelnumber+missinglabels);



function Test()

id=0; %id, 0 is the root
selected=Findpointsinsubnodeiterative(treestructure, firstbelonging, id);
% selected=Findpointsinsubnode(treestructure, firstbelonging, id);

%Code to check
% id=4500;
% selected=Findpointsinsubnode(treestructure, firstbelonging, id)
% find(firstbelonging==id)
% 
% r=find(treestructure==id);
% for i=1:numel(r)
%     fprintf('\n\n%d\n\n\n',i);
%     selected=Findpointsinsubnode(treestructure, firstbelonging, r(i))
%     find(firstbelonging==r(i))
% end

%selects all points at level
level=112; %level, 0 is the root
selectedids=Findidattreelevel(treestructure, level);
selected=[];
for i=selectedids
    selected=[selected,Findpointsinsubnode(treestructure, firstbelonging, i)];
end

level=0;
while ( numel(Findidattreelevel(treestructure, level))>0 )
    level=level+1;
end

